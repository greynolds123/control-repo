define puppet_enterprise::trapperkeeper::activity (
  $container           = $title,
  $database_host       = 'localhost',
  $database_name       = $puppet_enterprise::params::activity_database_name,
  $database_password   = undef,
  $database_port       = $puppet_enterprise::database_port,
  $database_properties = '',
  $database_user       = $puppet_enterprise::activity_service_regular_db_user,
  $database_migration_user = $puppet_enterprise::activity_service_migration_db_user,
  $group               = "pe-${title}",
  $rbac_host           = 'localhost',
  $rbac_port           = $puppet_enterprise::params::console_services_api_listen_port,
  $rbac_url_prefix     = $puppet_enterprise::params::rbac_url_prefix,
  $user                = "pe-${title}",
) {
  File {
    owner => $user,
    group => $group,
    mode  => '0640',
  }

  Pe_hocon_setting {
    ensure  => present,
    notify  => Service["pe-${container}"],
  }

  # Uses
  #   $rbac_host
  #   $rbac_port
  #   $rbac_url_prefix
  file { "/etc/puppetlabs/${container}/conf.d/activity.conf":
    ensure => present,
  }
  pe_hocon_setting { 'activity.rbac-base-url':
    path    => "/etc/puppetlabs/${container}/conf.d/activity.conf",
    setting => 'activity.rbac-base-url',
    value   => "http://${rbac_host}:${rbac_port}${rbac_url_prefix}/v1",
  }
  pe_hocon_setting { 'activity.cors-origin-pattern':
    path    => "/etc/puppetlabs/${container}/conf.d/activity.conf",
    setting => 'activity.cors-origin-pattern',
    value   => '.*'
  }

  puppet_enterprise::trapperkeeper::database_settings { 'activity' :
    container           => $container,
    database_host       => $database_host,
    database_name       => $database_name,
    database_password   => $database_password,
    database_port       => Integer($database_port),
    database_properties => $database_properties,
    database_user       => $database_user,
    migration_user      => $database_migration_user,
    migration_password  => $database_password,
    group               => $group,
    user                => $user,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:activity activity-service" :
    container => $container,
    namespace => 'puppetlabs.activity.services',
    service   => 'activity-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:activity jetty9-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }
}
