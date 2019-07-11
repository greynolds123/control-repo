# This profile sets up a PE Plan Executor service. There are two variants of this service available in PE:
#
# - The 'ruby' variant is a ruby service that runs separately from the orchestrator to execute plans.
# - The 'jruby' variant executes plans via a jruby service within orchestrator itself. There is no separate service.
#
# By default, neither of these is enabled.
#
# @param variant [Enum[jruby, ruby]] The type of plan executor to run. Can be 'jruby', 'ruby', or undef (for neither)
# @param ruby_service_name [String] The name of the ruby service ('pe-plan-executor' by default).
# @param ssl_listen_port [Boolean] The port used for SSL connections to the ruby service.
# @param certname [String] The name of the service SSL certificate for the ruby service.
# @param run_service [Boolean] Whether the ruby service variant, if selected, should be running.
# @param whitelist [Array[String]] Certificates that can be used to make requests to the ruby service.
# @param ssl_cipher_suites [Array[String]] Cipher suites for TLS for the ruby service, in preference order.
# @param service_loglevel [Enum[notice, debug, info, error, warn]] Set service log level. FIXME: this does not affect the 'jruby' variant yet.
# @param workers [Integer] The number of puma workers to start when using the ruby service.
# @param modulepath [String] The modulepath to use.
# @param orchestrator_url [String] The orchestrator's URL, including the port number.
# @param jruby_compile_mode [String] The compile mode to use when using the jruby service (defaults to 'jit').
# @param jruby_max_requests_per_instance [Integer] Maximum number of active jruby instances for the jruby service.
# @param settings [Hash] Any additional hocon settings to set in the ruby service configuration.

class puppet_enterprise::profile::plan_executor(
  Optional[Enum[jruby, ruby]] $variant = undef,
  String $ruby_service_name = 'pe-plan-executor',
  Integer $ssl_listen_port = $puppet_enterprise::plan_executor_port,
  String $certname = $facts['clientcert'],
  Boolean $run_service = true,
  Array[String] $whitelist = [$certname],
  Array[String] $ssl_cipher_suites = $puppet_enterprise::params::secure_ciphers,
  Enum[notice, debug, info, error, warn] $service_loglevel = 'notice',
  Integer $workers = $puppet_enterprise::plan_executor_workers,
  String $modulepath = $puppet_enterprise::system_module_dir,
  String $orchestrator_url = $puppet_enterprise::orchestrator_url,
  String $jruby_compile_mode = 'jit',
  Integer $jruby_max_requests_per_instance = 100000,
  Hash $settings = {},
) {
  $container = 'orchestration-services'

  #########################
  # Service file management

  if $variant == 'ruby' {
    $_ruby_service_file = {
      ensure => file,
      before => Service[$ruby_service_name],
    }
  } else {
    $_ruby_service_file = {
      ensure  => absent,
      require => Service[$ruby_service_name],
    }
  }

  # Logrotate configs for the ruby plan executor service
  file { "/etc/logrotate.d/${ruby_service_name}":
    * => $_ruby_service_file,
    source => "puppet:///modules/puppet_enterprise/plan_executor/${ruby_service_name}.logrotate",
  }

  $_sysvinit = ($facts['os']['family'] == 'RedHat' and Integer($facts['os']['release']['major']) <= 6) or
    ($facts['os']['family'] == 'Suse' and Integer($facts['os']['release']['major']) <= 11)

  if $_sysvinit {
    file { "/etc/rc.d/init.d/${ruby_service_name}":
      * => $_ruby_service_file,
      source => "puppet:///modules/puppet_enterprise/plan_executor/${ruby_service_name}.init",
      mode => '0755',
    }

    file { "/etc/sysconfig/${ruby_service_name}":
      * => $_ruby_service_file,
      source => "puppet:///modules/puppet_enterprise/plan_executor/${ruby_service_name}.sysconfig",
      replace => false,
    }
  } else {
    $_systemd_service_file = $facts['os']['family'] ? {
      'Debian' => "/lib/systemd/system/${ruby_service_name}.service",
      default  => "/usr/lib/systemd/system/${ruby_service_name}.service",
    }

    file { $_systemd_service_file:
      * => $_ruby_service_file,
      source => "puppet:///modules/puppet_enterprise/plan_executor/${ruby_service_name}.service"
    }
  }

  ##############################
  # Hocon configuration settings

  $_orchestrator_conf_path = "/etc/puppetlabs/${container}/conf.d/orchestrator.conf"
  $_orchestrator_conf_entry = {
    ensure => present,
    path   => $_orchestrator_conf_path,
    notify => Service["pe-${container}"]
  }

  if $variant == 'ruby' {
    puppet_enterprise::orchestrator::ruby_service { 'plan-executor':
      container         => 'plan-executor',
      ssl_listen_port   => $ssl_listen_port,
      certname          => $certname,
      run_service       => $run_service,
      whitelist         => $whitelist,
      ssl_cipher_suites => $ssl_cipher_suites,
      service_loglevel  => $service_loglevel,
      settings          => {
        'workers'          => $workers,
        'modulepath'       => $modulepath,
        'orchestrator-url' => $orchestrator_url,
      } + $settings,
    }

    pe_hocon_setting { 'orchestrator.plan-executor-enable':
      * => $_orchestrator_conf_entry,
      value   => 'external',
    }
  } elsif $variant == 'jruby' {
    pe_hocon_setting { 'orchestrator.url':
      * => $_orchestrator_conf_entry,
      value => "${orchestrator_url}/orchestrator/v1",
    }

    pe_hocon_setting { 'orchestrator.plan-executor-enable':
      * => $_orchestrator_conf_entry,
      value   => 'jruby',
    }

    pe_hocon_setting { 'orchestrator.jruby.compile-mode':
      * => $_orchestrator_conf_entry,
      value  => $jruby_compile_mode,
    }

    pe_hocon_setting { 'orchestrator.jruby.gem-home':
      * => $_orchestrator_conf_entry,
      value  => '/opt/puppetlabs/server/apps/bolt-server/lib/ruby',
    }

    pe_hocon_setting { 'orchestrator.jruby.gem-path':
      * => $_orchestrator_conf_entry,
      value  => '/opt/puppetlabs/server/apps/bolt-server/lib/ruby:/opt/puppetlabs/puppet/lib/ruby/vendor_gems:/opt/puppetlabs/puppet/lib/ruby/gems/2.5.0',
    }

    # 'max-borrows-per-instance' is the name of this setting in jruby-utils, while
    # puppetserver calls this 'max-requests-per-instance'. The parameter uses
    # puppetserver's name for consistency.
    pe_hocon_setting { 'orchestrator.jruby.max-requests-per-instance':
      * => $_orchestrator_conf_entry,
      value  => $jruby_max_requests_per_instance,
    }

    pe_hocon_setting { 'orchestrator.jruby.ruby-load-path':
      * => $_orchestrator_conf_entry,
      type   => 'array',
      value  => [
        '/opt/puppetlabs/server/apps/bolt-server/lib/ruby',
        '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby',
      ],
    }

    # The jruby service loads its modulepath from orchestrator's config
    pe_hocon_setting { 'orchestrator.modulepath':
      * => $_orchestrator_conf_entry,
      value => [$modulepath],
    }
  } else {
    # Make sure neither variant of the plan executor is enabled:
    pe_hocon_setting { 'orchestrator.plan-executor-enable':
      ensure => absent,
      path   => $_orchestrator_conf_path,
      notify => Service["pe-${container}"],
    }
  }

  # The orchestration service controls the enabled/disabled status of the ruby
  # service via a config file setting (see the $run_service parameter).
  # Here we are explicitly ensuring that if we're using any variant other than
  # the ruby service, the ruby service is not somehow left running by accident.
  unless $variant == 'ruby' {
    service { $ruby_service_name:
      ensure => stopped,
      enable => false,
      notify => Service["pe-${container}"],
    }
  }
}
