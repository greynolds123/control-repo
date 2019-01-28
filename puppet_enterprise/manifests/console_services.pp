class puppet_enterprise::console_services(
  $proxy_idle_timeout         = 60,
  $client_certname,
  $master_host,
  $classifier_host            = 'localhost',
  $classifier_port            = $puppet_enterprise::params::console_services_api_listen_port,
  $classifier_url_prefix      = $puppet_enterprise::params::classifier_url_prefix,
  $rbac_host                  = 'localhost',
  $rbac_port                  = $puppet_enterprise::params::console_services_api_listen_port,
  $activity_host              = 'localhost',
  $activity_port              = $puppet_enterprise::params::console_services_api_listen_port,
  $activity_url_prefix        = $puppet_enterprise::params::activity_url_prefix,
  $puppetdb_host              = 'localhost',
  $puppetdb_port              = $puppet_enterprise::params::puppetdb_ssl_listen_port,
  $localcacert                = $puppet_enterprise::params::localcacert,
  Hash $java_args             = $puppet_enterprise::params::console_services_java_args,
  $status_proxy_enabled       = false,
  $service_stop_retries       = 60,
  $start_timeout              = 120,
  String $pcp_broker_host     = $puppet_enterprise::pcp_broker_host,
  Integer $pcp_broker_port    = $puppet_enterprise::pcp_broker_port,
  Integer $pcp_timeout        = 5,
  $service_alert_timeout      = 5000,
  Boolean $display_local_time = false,
) inherits puppet_enterprise::params {

  pe_validate_single_integer($service_stop_retries)
  pe_validate_single_integer($start_timeout)

  $container = 'pe-console-services'

  $confdir = '/etc/puppetlabs/console-services'

  puppet_enterprise::trapperkeeper::console_services { 'console-services':
    client_certname        => $client_certname,
    proxy_idle_timeout     => $proxy_idle_timeout,
    master_host            => $master_host,
    classifier_host        => $classifier_host,
    classifier_port        => $classifier_port,
    classifier_url_prefix  => $classifier_url_prefix,
    puppetdb_host          => $puppetdb_host,
    puppetdb_port          => $puppetdb_port,
    rbac_host              => $rbac_host,
    rbac_port              => $rbac_port,
    activity_host          => $activity_host,
    activity_port          => $activity_port,
    activity_url_prefix    => $activity_url_prefix,
    localcacert            => $localcacert,
    status_proxy_enabled   => $status_proxy_enabled,
    pcp_broker_host        => $pcp_broker_host,
    pcp_broker_port        => $pcp_broker_port,
    pcp_timeout            => $pcp_timeout,
    service_alert_timeout  => $service_alert_timeout,
    display_local_time     => $display_local_time,
    require                => Package['pe-console-services'],
    notify                 => Service['pe-console-services'],
  }

  $console_initconf = "${puppet_enterprise::params::defaults_dir}/pe-console-services"

  puppet_enterprise::trapperkeeper::java_args { 'console-services' :
    java_args => $java_args,
  }

  Pe_ini_setting {
    ensure => present,
    path => $console_initconf,
    key_val_separator => '=',
    section => '',
  }

  pe_ini_setting { "${container} initconf java_bin":
    setting => 'JAVA_BIN',
    value   => '"/opt/puppetlabs/server/bin/java"',
  }

  pe_ini_setting { "${container} initconf user":
    setting => 'USER',
    value   => 'pe-console-services',
  }

  pe_ini_setting { "${container} initconf group":
    setting => 'GROUP',
    value   => 'pe-console-services',
  }

  pe_ini_setting { "${container} initconf install_dir":
    setting => 'INSTALL_DIR',
    value   => '"/opt/puppetlabs/server/apps/console-services"',
  }

  pe_ini_setting { "${container} initconf config":
    setting => 'CONFIG',
    value   => "\"${confdir}/conf.d\"",
  }

  pe_ini_setting { "${container} initconf bootstrap_config":
    setting => 'BOOTSTRAP_CONFIG',
    value   => "\"${confdir}/bootstrap.cfg\"",
  }

  pe_ini_setting { "${container} initconf service_stop_retries":
    setting => 'SERVICE_STOP_RETRIES',
    value   => $service_stop_retries,
  }

  pe_ini_setting { "${container} initconf start_timeout":
    setting => 'START_TIMEOUT',
    value   => $start_timeout,
  }

  service { 'pe-console-services':
    ensure => running,
    enable => true,
  }
}
