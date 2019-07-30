# This class sets up the master. For more information, see the [README.md](./README.md)
#
# @param allow_unauthenticated_ca [Boolean] True allows unauthenticated access, by default. False requires authentication on the certificate endpoints.
# @param allow_unauthenticated_status [Boolean] True allows unauthenticated access, by default. False requires authentication on the puppetserver status-service endpoint.
# @param ca_host [String] The hostname of the node acting as a certificate authority.
# @param ca_port [Integer] The port the CA service is listening on.
# @param console_host [String] The hostname of the node acting as the PE Console.
# @param enable_ca_proxy [Boolean] Enable the internal PE CA proxy that will forward agent CA requests to the @ca_host
# @param dashboard_port [Integer] *Deprecated* The port the PE console is listening on.
# @param puppetdb_host Array[String] The hostname of the PuppetDB host.
# @param puppetdb_port Array[Integer] The port the PuppetDB host is listening on.
# @param console_server_certname [String] The name of the console's SSL certificate.
# @param master_of_masters_certname [String] The certname of the Master of Masters
# @param certname [String] The name of the the master SSL certificate.
# @param classifier_host [String] The hostname of the PE Classifier.
# @param classifier_port [Integer] The port the PE Classifter is listening on.
# @param classifier_url_prefix [String] What to prefix to URLs used with the classifier.
# @param console_client_certname [String]  The name of the certificate to use when connecting to the PE Console.
# @param classifier_client_certname [String] The name of the certificate to use when connecting to the PE Classifier.
# @param localcacert [String] Certificate of the CA to use when verifying certificates.
# @param java_args [Hash] Key-value pairs describing the java arguments to be passed when starting the master.
# @param metrics_server_id [String] Unique identifier for this server in the metrics backend.
# @param metrics_jmx_enabled [Boolean] Flag to enable JMX on metrics.
# @param metrics_graphite_enabled [Boolean] Flag to enable logging metrics to Graphite.
# @param metrics_graphite_host [String] The name of the Graphite server to log metrics to.
# @param metrics_graphite_port [Integer] the port the Graphite server is listening on.
# @param metrics_graphite_update_interval_seconds [Integer] How often to write metrics to the Graphite server.
# @param metrics_puppetserver_metrics_allowed [Array] A whitelist of metric names to be sent to the enabled reporters.
# @param profiler_enabled [Boolean] Flag to enable the profiler.
# @param file_sync_enabled [Variant[Boolean, Enum['automatic']]] Flag to enable file sync.
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
# @param r10k_remote [String] The git url for the pe_r10k configuration
# @param r10k_private_key [String] The rugged private key path for pe_r10k configuration
# @param r10k_postrun [String] An optional command that will be run after r10k finishes deploying environments. The command must be an array of strings that will be used as an argument vector.
# @param r10k_git_provider [String] The git provider to use for pe_r10k configuration, either 'rugged' or 'shellgit'
# @param code_manager_auto_configure [Boolean] Configure code-manager based on r10k params
# @param facts_terminus [String] The terminus to use when agents submit facts
# @param environmentpath [String] Set environmentpath in puppet.conf
# @param app_management [Boolean] Deprecated setting; app_management is always enabled
# @param code_id_command [String] The absolute path to a script to run to generate the code_id for an environment.
# @param code_content_command [String] The absolute path to a script to run to retrieve a file from an environment for a given code_id.
# @param codedir [String] Path to codedir for puppetserver and for puppet.conf setting
# @param check_for_updates [Boolean] Enable/disable update checking on puppetserver start-up.
# @param send_analytics_data [Boolean] Enable/disable telemetry reporting on puppetserver start-up.
# @param replication_mode ['source', 'replica', 'none'] Which kind of replica this master is, if any.
# @param ssl_listen_port [Integer] What port puppetserver should listen on
# @param provisioned_replicas [Array[String]] Array of certnames for provisioned replicas; these will be given access to the ca-data file sync repo.
# @param ha_enabled_replicas [Array[String]] Array of certnames of enabled replicas; these will be used as pcp contollers.
# @param connect_timeout_milliseconds [Optional[Integer]] The amount of time an outbound HTTP connection will wait to connect before giving up
class puppet_enterprise::profile::master(
  Boolean $allow_unauthenticated_ca                       = true,
  Boolean $allow_unauthenticated_status                   = $puppet_enterprise::allow_unauthenticated_status,
  $ca_host                                                = $puppet_enterprise::certificate_authority_host,
  $ca_port                                                = $puppet_enterprise::certificate_authority_port,
  $certname                                               = $facts['clientcert'],
  $classifier_client_certname                             = $puppet_enterprise::console_host,
  $classifier_host                                        = $puppet_enterprise::console_host,
  $classifier_port                                        = $puppet_enterprise::api_port,
  $classifier_url_prefix                                  = $puppet_enterprise::classifier_url_prefix,
  $console_client_certname                                = $puppet_enterprise::console_host,
  $console_host                                           = $puppet_enterprise::console_host,
  $console_server_certname                                = $puppet_enterprise::console_host,
  $orchestrator_client_certname                           = $puppet_enterprise::puppet_master_host,
  $master_of_masters_certname                             = $puppet_enterprise::puppet_master_host,
  $dashboard_port                                         = undef,
  Boolean $enable_ca_proxy                                = true,
  $enable_future_parser                                   = undef,
  $facts_terminus                                         = 'puppetdb',
  Hash $java_args                                         = $puppet_enterprise::params::puppetserver_java_args,
  $localcacert                                            = $puppet_enterprise::params::localcacert,
  Boolean $manage_symlinks                                = $puppet_enterprise::manage_symlinks,
  $metrics_enabled                                        = undef,
  $metrics_graphite_enabled                               = false,
  $metrics_graphite_host                                  = 'graphite',
  $metrics_graphite_port                                  = 2003,
  $metrics_graphite_update_interval_seconds               = 60,
  $metrics_puppetserver_metrics_allowed                   = undef,
  $metrics_jmx_enabled                                    = true,
  $metrics_server_id                                      = $facts['hostname'],
  $profiler_enabled                                       = true,
  Variant[Boolean, Enum['automatic']] $file_sync_enabled  = 'automatic',
  Array[String]    $puppetdb_host                         = $puppet_enterprise::puppetdb_hosts_array,
  Array[Integer]   $puppetdb_port                         = $puppet_enterprise::puppetdb_ports_array,
  Optional[String] $r10k_remote                           = undef,
  Optional[String] $r10k_private_key                      = undef,
  Optional[String] $r10k_proxy                            = undef,
  Optional[Array]  $r10k_postrun                          = undef,
  Optional[Enum['rugged', 'shellgit']] $r10k_git_provider = undef,
  Boolean $code_manager_auto_configure                    = false,
  Optional[String] $environmentpath                       = undef,
  $app_management                                         = undef,
  Optional[String] $code_id_command                       = undef,
  Optional[String] $code_content_command                  = undef,
  Optional[String] $codedir                               = undef,
  Boolean $check_for_updates                              = true,
  Boolean $send_analytics_data                            = $puppet_enterprise::send_analytics_data,
  Puppet_enterprise::Replication_mode $replication_mode   = 'none',
  Array[String] $provisioned_replicas                     = [],
  Array[String] $ha_enabled_replicas                      = $puppet_enterprise::ha_enabled_replicas,
  Integer $ssl_listen_port                                = $puppet_enterprise::puppet_master_port,
  Optional[Integer] $connect_timeout_milliseconds         = undef,
) inherits puppet_enterprise {
  # This brings in the license class to ensure that the file, if present,
  # is readable by the pe-puppet user in a split install for purposes of analytics
  # reporting.
  include puppet_enterprise::license

  include puppet_enterprise::master::meep

  $compiling_server_version = pe_compiling_server_version()
  $compiling_server_aio_build = pe_compiling_server_aio_build()
  $_aio_agent_build = $facts['aio_agent_build']
  if pe_compile_master() and ($compiling_server_aio_build != $_aio_agent_build) {
    fail("This compile master has a PE version of '${pe_current_server_version()}' and an aio puppet-agent version of '${_aio_agent_build}', while the master of masters has version '${compiling_server_version}' and an aio puppet-agent version of '${compiling_server_aio_build}'. Please ensure that the PE versions are consistent across all Puppet masters by following the LEI upgrade documentation.")
  }

  $confdir = '/etc/puppetlabs/puppet'

  if !pe_compile_master($replication_mode) {
    Package <| tag == 'pe-installer-packages' |>
  }

  Pe_ini_setting {
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'master',
    notify  => Service['pe-puppetserver'],
  }

  # In ankeny we set this in master we need to ensure it's absent
  pe_ini_setting { 'deprecated puppetserver puppetconf app_management' :
    ensure  => absent,
    setting => 'app_management',
    section => 'master',
  }

  # In Puppet 5 app_management is always on and the setting is deprecated
  pe_ini_setting { 'puppetserver puppetconf app_management' :
    ensure  => absent,
    setting => 'app_management',
    section => 'main',
  }

  if $enable_ca_proxy {
    # A reverse proxy between the master and the ca will be configured,
    # allowing agents to have their ca traffic silently forwarded
    $ca_namespace   = 'puppetlabs.enterprise.services.reverse-proxy.reverse-proxy-ca-service'
    $ca_service     = 'reverse-proxy-ca-service'
    $ca_conf_ensure = file
    $ca_setting_ensure = present
  }
  else {
    # We disable the certificate-authority-service on masters.
    # Relevant resources are collected and overridden in the ca profile
    $ca_namespace   = 'puppetlabs.services.ca.certificate-authority-disabled-service'
    $ca_service     = 'certificate-authority-disabled-service'
    $ca_conf_ensure = absent
    $ca_setting_ensure = absent
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'certificate-authority-service' :
    container => 'puppetserver',
    namespace => $ca_namespace,
    service   => $ca_service,
    require   => Package['pe-puppetserver'],
    notify    => Service['pe-puppetserver'],
  }

  $puppetserver_confdir = '/etc/puppetlabs/puppetserver/conf.d'

  Pe_hocon_setting {
    ensure  => present,
    require => Package['pe-puppetserver'],
    notify  => Service['pe-puppetserver'],
  }

  # Uses
  #   $metrics_graphite_host
  #   $metrics_graphite_port
  #   $metrics_graphite_update_interval_seconds
  # Global graphite host setting
  pe_hocon_setting { 'metrics.reporters.graphite.host':
    path    => "${puppetserver_confdir}/metrics.conf",
    setting => 'metrics.reporters.graphite.host',
    value   => $metrics_graphite_host,
    require => File["${puppetserver_confdir}/metrics.conf"],
  }
  # Global graphite port setting
  pe_hocon_setting { 'metrics.reporters.graphite.port':
    path    => "${puppetserver_confdir}/metrics.conf",
    setting => 'metrics.reporters.graphite.port',
    value   => $metrics_graphite_port,
    require => File["${puppetserver_confdir}/metrics.conf"],
  }
  # Global setting for how often to send metrics
  pe_hocon_setting { 'metrics.reporters.graphite.update-interval-seconds':
    path    => "${puppetserver_confdir}/metrics.conf",
    setting => 'metrics.reporters.graphite.update-interval-seconds',
    value   => $metrics_graphite_update_interval_seconds,
    require => File["${puppetserver_confdir}/metrics.conf"],
  }

  # Uses
  #   $ca_host
  #   $ca_port
  #   $certname
  #   $localcacert
  file { "${puppetserver_confdir}/ca.conf":
    ensure  => $ca_conf_ensure,
    require => Package['pe-puppetserver'],
  }

  pe_hocon_setting{ 'certificate-authority.proxy-config.proxy-target-url':
    ensure  => $ca_setting_ensure,
    path    => "${puppetserver_confdir}/ca.conf",
    setting => 'certificate-authority.proxy-config.proxy-target-url',
    value   => "https://${ca_host}:${ca_port}",
    require => Package['pe-puppetserver'],
  }
  pe_hocon_setting{ 'certificate-authority.proxy-config.ssl-opts.ssl-cert':
    ensure  => $ca_setting_ensure,
    path    => "${puppetserver_confdir}/ca.conf",
    setting => 'certificate-authority.proxy-config.ssl-opts.ssl-cert',
    value   => "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
    require => Package['pe-puppetserver'],
  }
  pe_hocon_setting{ 'certificate-authority.proxy-config.ssl-opts.ssl-key':
    ensure  => $ca_setting_ensure,
    path    => "${puppetserver_confdir}/ca.conf",
    setting => 'certificate-authority.proxy-config.ssl-opts.ssl-key',
    value   => "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
    require => Package['pe-puppetserver'],
  }
  pe_hocon_setting{ 'certificate-authority.proxy-config.ssl-opts.ssl-ca-cert':
    ensure  => $ca_setting_ensure,
    path    => "${puppetserver_confdir}/ca.conf",
    setting => 'certificate-authority.proxy-config.ssl-opts.ssl-ca-cert',
    value   => $localcacert,
    require => Package['pe-puppetserver'],
  }

  # Updating puppet.conf node terminus
  if ! pe_empty($classifier_host) {
    class { 'puppet_enterprise::profile::master::classifier' :
      classifier_host       => $classifier_host,
      classifier_port       => $classifier_port,
      classifier_url_prefix => $classifier_url_prefix,
      notify                => Service['pe-puppetserver'],
      require               => Package['pe-puppetserver'],
    }
  }

  # Only copy the hostcrl if this is a puppet agent run.
  # This is needed for working with a puppet apply that also
  # generates the certs in the same run.
  if pe_servername() {
    # Copy the crl from the ca is we're a secondary master
    # and if we're the ca just move it to the hostcrl as the canonical location
    $_crl_content = file($::settings::cacrl, $::settings::hostcrl, '/dev/null')
    if pe_empty($_crl_content) {
      warning("CRL file not found on ${::servername}")
    } else {
      file { $puppet_enterprise::params::hostcrl:
        ensure  => file,
        owner   => 'pe-puppet',
        group   => 'pe-puppet',
        mode    => '0644',
        content => $_crl_content,
        require => Package['pe-puppetserver'],
      }
    }
  }

  $private_keys_dir = "${puppet_enterprise::params::ssl_dir}/private_keys"

  file { $private_keys_dir :
    ensure  => directory,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0640',
    require => Package['pe-puppetserver'],
  }

  file { "${private_keys_dir}/${facts['clientcert']}.pem":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0640',
    require => Package['pe-puppetserver'],
    notify  => Service['pe-puppetserver'],
  }

  puppet_enterprise::set_owner_group_permissions{ $private_keys_dir :
    file_mode   => '0640',
    owner       => 'pe-puppet',
    group       => 'pe-puppet',
    target_type => 'directory',
    dir_mode    => '0750',
    require     => [ Package['pe-puppetserver'],
                     File["${puppet_enterprise::params::ssl_dir}/private_keys/${facts['clientcert']}.pem"]]
  }

  # PMT access to pe_only content
  pe_ini_setting { 'module_groups' :
    section => 'main',
    setting => 'module_groups',
    value   => 'base+pe_only',
  }

  if $codedir {
    pe_ini_setting { 'codedir_setting':
      setting => 'codedir',
      value   => $codedir,
      section => 'main',
    }

    $real_codedir = $codedir
  } else {
    pe_ini_setting { 'codedir_setting':
      ensure  => absent,
      setting => 'codedir',
      section => 'main',
    }

    $real_codedir = $::settings::codedir
  }

  if $environmentpath {
    $dangerous_envpath = $environmentpath.match(Regexp[$real_codedir])

    if $dangerous_envpath {
      warning("Do not hardcode environmentpath to include the value of the codedir. Use Puppet's interpolation capabilities instead. Found codedir ${real_codedir} in environmentpath ${environmentpath}")
    }

    pe_ini_setting { 'environmentpath_setting':
      setting => 'environmentpath',
      value   => $environmentpath,
      section => 'main',
    }
  } else {
    pe_ini_setting { 'environmentpath_setting':
      ensure  => absent,
      setting => 'environmentpath',
      section => 'main',
    }
  }


  class { 'puppet_enterprise::profile::master::auth_conf':
    console_client_certname      => $console_client_certname,
    classifier_client_certname   => $classifier_client_certname,
    orchestrator_client_certname => $orchestrator_client_certname,
    allow_unauthenticated_ca     => $allow_unauthenticated_ca,
    allow_unauthenticated_status => $allow_unauthenticated_status,
    require                      => Package['pe-puppetserver'],
    notify                       => Service['pe-puppetserver'],
  }

  class { 'puppet_enterprise::profile::master::puppetdb' :
    puppetdb_host               => $puppetdb_host,
    puppetdb_port               => $puppetdb_port,
    facts_terminus              => $facts_terminus,
    notify                      => Service['pe-puppetserver'],
    require                     => Package['pe-puppetserver'],
  }

  # When terminus configuration is going to do some kind of failover (i.e. in HA
  # configurations), we need to use a smaller connect timeout. Only do this if
  # the parameter wasn't explicitly specified.
  $is_ha = (pe_count(pe_any2array($puppetdb_host)) > 1) or (pe_count(pe_any2array($classifier_host)) > 1)
  $defaulted_connect_timeout = if $connect_timeout_milliseconds {
                                  $connect_timeout_milliseconds
                                } elsif $is_ha {
                                  5000
                                } else {
                                  undef
                                }

  class { 'puppet_enterprise::master' :
    certname                                  => $certname,
    static_files                              => {'/packages' => "${puppet_enterprise::packages_dir}/public"},
    localcacert                               => $localcacert,
    java_args                                 => $java_args,
    metrics_server_id                         => $metrics_server_id,
    metrics_jmx_enabled                       => $metrics_jmx_enabled,
    metrics_graphite_enabled                  => $metrics_graphite_enabled,
    metrics_puppetserver_metrics_allowed      => $metrics_puppetserver_metrics_allowed,
    profiler_enabled                          => $profiler_enabled,
    enable_future_parser                      => $enable_future_parser,
    manage_symlinks                           => $manage_symlinks,
    code_manager_auto_configure               => $code_manager_auto_configure,
    puppetserver_jruby_puppet_master_code_dir => $real_codedir,
    ssl_listen_port                           => $ssl_listen_port,
    connect_timeout_milliseconds              => $defaulted_connect_timeout,
  }

  # Only compile masters have pcp-broker. On the MoM and replica, pcp-broker
  # lives in orchestration-services.
  if (pe_compile_master($replication_mode)) {
    class { 'puppet_enterprise::master::pcp_broker':
      orchestrator_hosts => [$puppet_enterprise::puppet_master_host] + $ha_enabled_replicas
    }
  }

  # PE MODULE DEPLOYMENT
  # Puppet Enterprise supported deployments need to have a base set of modules
  # installed. These modules are not packaged using rpm or deb, but come from
  # tarball sources. Ensure that each required module is retrieved and
  # deployed.

  $sharedir = $facts['os']['family'] ? {
    'windows' => "${facts['common_appdata']}/PuppetLabs/puppet/share",
    default   => "${puppet_enterprise::server_share_dir}/puppet_enterprise",
  }

  file { $sharedir:
    ensure => directory,
    owner  => $puppet_enterprise::params::root_user,
    group  => $puppet_enterprise::params::root_group,
    mode   => '0755',
    require => Package['pe-puppet-enterprise-release'],
  }

  $public_packages_dir = "${puppet_enterprise::packages_dir}/public"

  # This directory is managed by pe_repo.  However, if this directory does not
  # exist and pe_repo is not part of the classification (during initial installation
  # puppet apply) then an error will be thrown by Puppet's fileserver mount code.
  exec { "Ensure public dir ${public_packages_dir}":
      command => "mkdir -p ${public_packages_dir}",
      path    => '/sbin/:/bin/',
      unless  => "ls ${public_packages_dir}",
      require => Package['pe-puppetserver'],
  }

  # FILESERVER
  # Allow Puppet to serve puppet-agent packages from the public fileserver set up
  # by pe_repo.
  puppet_enterprise::fileserver_conf { $puppet_enterprise::packages_mountpoint:
    mountpoint => $puppet_enterprise::packages_mountpoint,
    path       => $public_packages_dir,
    require    => Exec["Ensure public dir ${public_packages_dir}"],
  }

  if $code_manager_auto_configure {
    $deploy_settings = {
      'write_lock' => 'Direct invocation of r10k is disabled when Code Manager is auto configured.',
    }
  }
  else {
    $deploy_settings = undef
  }

  if ($r10k_remote and !pe_empty($r10k_remote)) or $code_manager_auto_configure {
    # If users declare r10k via the installer we automatically enable
    # rugged support if they specify a private_key so we have no
    # external dependencies on the os providing git. This also
    # allows us to hardcode a path to the key without knowing what
    # user account they will run r10k as in the future.

    if $r10k_private_key and !pe_empty($r10k_private_key) {
      pe_validate_absolute_path($r10k_private_key)

      # Because of the way set_owner_group_permissions works, we need to
      # set the same mode for contents of /etc/puppetlabs/puppetserver/ssh
      # and $r10k_private_key, otherwise, in the case of $r10k_private_key
      # being in /etc/puppetlabs/puppetserver/ssh, these two
      # set_owner_group_permissions will fight one another in every puppet run.
      $ssh_private_key_mode = '0600'
      puppet_enterprise::set_owner_group_permissions{ '/etc/puppetlabs/puppetserver/ssh' :
        file_mode   => $ssh_private_key_mode,
        owner       => 'pe-puppet',
        group       => 'pe-puppet',
        target_type => 'directory',
        dir_mode    => '0700',
      }

      puppet_enterprise::set_owner_group_permissions{ $r10k_private_key :
        file_mode   => $ssh_private_key_mode,
        owner       => 'pe-puppet',
        group       => 'pe-puppet',
        target_type => 'file',
      }

      $git_settings = {
        'provider'    => 'rugged',
        'private_key' => $r10k_private_key,
      }
    }
    else {
      $git_settings = undef
    }

    class {'pe_r10k':
      remote          => $r10k_remote,
      proxy           => $r10k_proxy,
      git_settings    => $git_settings,
      deploy_settings => $deploy_settings,
      r10k_basedir    => $environmentpath,
      postrun         => $r10k_postrun,
    }
  }
  else {
    # If the user did not specify a remote, then only include
    # the package and not the configuration. We don't want to
    # include the main class here as that prevents the user
    # from using a class resource to declare their configuration
    include pe_r10k::package
  }

  if ($code_manager_auto_configure and $file_sync_enabled == false) {
    fail('Configuring $code_manager_auto_configure requires $file_sync_enabled to be either true or undef. Please unset $file_sync_enabled before continuing.')
  }

  # Reuse r10k answers to autoconfigure (only on MoM/Primary Master)
  if (!pe_compile_master($replication_mode) and $replication_mode != 'replica') and $code_manager_auto_configure {
    class {'puppet_enterprise::master::code_manager':
      certname                    => $certname,
      remote                      => $r10k_remote,
      proxy                       => $r10k_proxy,
      private_key                 => $r10k_private_key,
      git_provider                => $r10k_git_provider,
      puppet_master_port          => $ssl_listen_port,
      require                     => Package['pe-puppetserver'],
    }
  }

  if ($code_manager_auto_configure or ($file_sync_enabled == true)) {
    class {'puppet_enterprise::master::file_sync':
      certname                                  => $certname,
      puppet_master_host                        => $puppet_enterprise::puppet_master_host,
      master_of_masters_certname                => $master_of_masters_certname,
      puppetserver_jruby_puppet_master_code_dir => $real_codedir,
      puppetserver_webserver_ssl_port           => $ssl_listen_port,
      localcacert                               => $puppet_enterprise::params::localcacert,
      replication_mode                          => $replication_mode,
      provisioned_replicas                      => $provisioned_replicas,
      storage_service_disabled                  => (pe_compile_master($replication_mode) or ($replication_mode == 'replica')),
      require                                   => Package['pe-puppetserver'],
    }
  } else {
    class {'puppet_enterprise::master::file_sync_disabled':
      code_id_command      => $code_id_command,
      code_content_command => $code_content_command,
    }
  }

  $send_updates_ensure = $check_for_updates ? {
    true  => absent,
    false => file,
  }

  file { '/etc/puppetlabs/puppetserver/opt-out':
    ensure  => $send_updates_ensure,
    notify  => Service['pe-puppetserver'],
    require => Package['pe-puppetserver']
  }

  $analytics_opt_out_ensure = $send_analytics_data ? {
    true  => absent,
    false => file,
  }

  file { '/etc/puppetlabs/analytics-opt-out':
    ensure  => $analytics_opt_out_ensure,
    notify  => Service['pe-puppetserver'],
    require => Package['pe-puppetserver']
  }

  # We only want one analytics service
  # Analytics has some dependencies on pe-puppetserver for now so should not be on a separate host
  if (!pe_compile_master($replication_mode) and $replication_mode != 'replica') {
    class { 'puppet_enterprise::trapperkeeper::analytics':
      container => 'puppetserver',
    }
  }

  include puppet_enterprise::profile::controller
}
