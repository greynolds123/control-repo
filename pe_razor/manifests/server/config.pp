# Basic configuration of the razor server
define pe_razor::server::config(
  $protect_new_nodes,
  $repo_store_root,
  $task_path,
  $broker_path,
  $hook_path,
  $hook_execution_path,
  $match_nodes_on,
  $pe_tarball_base_url,
  $server_http_port,
  $server_https_port,
  $microkernel_url,
  $microkernel_debug_level,
  $microkernel_kernel_args,
  $microkernel_extension_zip,
  $database_url,
  $auth_enabled,
  $auth_config,
  $secure_api,
  $checkin_interval,
  $facts_blacklist,
  $facts_match_on,
  $api_config_blacklist,
  $auth_allow_localhost,
  $store_hook_input,
  $store_hook_output,
) {
  include pe_razor::params

  file { '/etc/sysconfig/pe-razor-server':
    ensure  => file,
    owner   => 'root',
    content => template('pe_razor/sysconfig.erb'),
    mode    => '0644'
  }

  # The following directories need to be managed by root
  file { $pe_razor::params::data_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  file { [$pe_razor::params::razor_etc,
          "${pe_razor::params::razor_etc}/tasks",
          "${pe_razor::params::razor_etc}/brokers",
          "${pe_razor::params::razor_etc}/hooks",]:
    ensure => directory,
    owner  => 'pe-razor',
    group  => 'pe-razor',
    mode   => '0640'
  }

  file { $pe_razor::params::repo_dir:
    ensure => directory,
    owner  => 'pe-razor',
    group  => 'pe-razor',
    mode   => '0755'
  }

  # Configuration
  # This defaults file is fully managed by puppet.
  # Template uses:
  # - $protect_new_nodes
  # - $repo_store_root
  # - $task_path
  # - $broker_path
  # - $hook_path
  # - $hook_execution_path
  # - $match_nodes_on
  # - $pe_tarball_base_url
  # - $server_http_port
  # - $server_https_port
  # - $microkernel_url
  # - $microkernel_debug_level
  # - $microkernel_kernel_args
  # - $microkernel_extension_zip
  # - $database_url
  # - $auth_enabled
  # - $auth_config
  # - $secure_api
  # - $checkin_interval
  # - $facts_blacklist,
  # - $api_config_blacklist,
  # - $auth_allow_localhost,
  # - $store_hook_input,
  # - $store_hook_output,
  file { $pe_razor::params::config_defaults_path:
    ensure  => file,
    owner   => 'root',
    mode    => '0444',
    content => template('pe_razor/config-defaults.yaml.erb'),
    # All config changes currently require a manual service restart since Razor
    # being down could be crippling to the ability for nodes to boot.
    # notify  => Service['pe-razor-server']
  }

  # Only put this here if it does not exist already. The user adds
  # overrides here.
  exec { "/bin/echo ${pe_razor::params::razor_etc}/config.yaml is not used any more. Please transfer any modified configuration properties to the respective class parameter and delete this file.":
    onlyif   => "/usr/bin/test -e ${pe_razor::params::razor_etc}/config.yaml",
    loglevel => warning,
  }

  file { "${pe_razor::params::razor_etc}/shiro.ini":
    ensure  => file,
    owner   => 'root',
    content => template('pe_razor/shiro.ini.erb'),
    require => File[$pe_razor::params::razor_etc],
    replace => $facts['should_install_shiro_ini'],
  }
}
