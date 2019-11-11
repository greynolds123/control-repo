class puppet_enterprise::trapperkeeper::inventory(
  String $database_host                   = $puppet_enterprise::inventory_database_host,
  Puppet_enterprise::Port $database_port  = $puppet_enterprise::database_port,
  String $database_name                   = $puppet_enterprise::inventory_database_name,
  String $database_user                   = $puppet_enterprise::inventory_service_regular_db_user,
  String $database_migration_user         = $puppet_enterprise::inventory_service_migration_db_user,
  Optional[String]$database_password      = undef,
  String $database_properties             = '',
  String $container                       = 'orchestration-services',
  String $user                            = "pe-${container}",
  String $group                           = "pe-${container}",
  String $client_certname                 = $puppet_enterprise::puppet_master_host,
  String $puppetdb_url,
  String $client_pem_key,
  String $client_cert,
  String $localcacert                     = $puppet_enterprise::params::localcacert,
) {

  $confdir = "/etc/puppetlabs/${container}/conf.d"

  file { "${confdir}/inventory.conf":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  file { "${confdir}/secrets":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  Pe_hocon_setting {
    ensure => present,
    notify => Service["pe-${container}"],
  }

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg {
    container => $container,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:inventory inventory-service" :
    namespace => 'puppetlabs.inventory.service',
    service   => 'inventory-service',
  }

  pe_hocon_setting { "${container}.inventory.keypath":
    path    => "${confdir}/inventory.conf",
    setting => 'inventory.keypath',
    value   => "${confdir}/secrets",
  }

  pe_hocon_setting { "${container}.inventory.database.subname":
    path    => "${confdir}/inventory.conf",
    setting => 'inventory.database.subname',
    value   => "//${database_host}:${database_port}/${database_name}${database_properties}",
  }

  pe_hocon_setting { "${container}.inventory.database.user":
    path    => "${confdir}/inventory.conf",
    setting => 'inventory.database.user',
    value   => $database_user,
  }

  pe_hocon_setting { "${container}.inventory.database.migration-user":
    ensure  => present,
    path    => "${confdir}/inventory.conf",
    setting => 'inventory.database.migration-user',
    value   => $database_migration_user,
  }

  pe_hocon_setting { "${container}.web-router-service.inventory-service":
    path    => "/etc/puppetlabs/${container}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.inventory.service/inventory-service"',
    value   => { route => '/inventory', server => 'orchestrator' },
  }

  if !pe_empty($database_password) {
    pe_hocon_setting { "${container}.inventory.database.password":
      path    => "${confdir}/inventory.conf",
      setting => 'inventory.database.password',
      value   => $database_password,
    }
    pe_hocon_setting { "${container}.inventory.database.migration-password":
      path    => "${confdir}/inventory.conf",
      setting => 'inventory.database.migration-password',
      value   => $database_password,
    }
  }

  pe_hocon_setting { "${container}.inventory.ssl-ca-cert":
    path    => "${confdir}/inventory.conf",
    setting => 'inventory.ssl-ca-cert',
    value   => $localcacert,
  }

  pe_hocon_setting { "${container}.inventory.ssl-cert":
    path    => "${confdir}/inventory.conf",
    setting => 'inventory.ssl-cert',
    value   => $client_cert,
  }

  pe_hocon_setting { "${container}.inventory.ssl-key":
    path    => "${confdir}/inventory.conf",
    setting => 'inventory.ssl-key',
    value   => $client_pem_key,
  }

  pe_hocon_setting { "${container}.inventory.puppetdb-url":
    path    => "${confdir}/inventory.conf",
    setting => 'inventory.puppetdb-url',
    value   => $puppetdb_url,
  }

}
