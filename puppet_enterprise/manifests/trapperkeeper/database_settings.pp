define puppet_enterprise::trapperkeeper::database_settings (
  String $container,
  String $database_host,
  String $database_name,
  Optional[String] $database_password,
  Integer $database_port,
  String $database_properties,
  String $database_user,
  String $migration_user,
  Optional[String] $migration_password,
  String $group,
  String $user,
  String $tk_service          = $title,
  Integer $maximum_pool_size  = lookup( "puppet_enterprise::trapperkeeper::database_settings::${tk_service}::maximum_pool_size",
                                        {'default_value' => 10}),
  Integer $pool_timeout       = lookup( "puppet_enterprise::trapperkeeper::database_settings::${tk_service}::pool_timeout",
                                        {'default_value' => 60}),
  Integer $pool_check_timeout = lookup( "puppet_enterprise::trapperkeeper::database_settings::${tk_service}::pool_check_timeout",
                                        {'default_value' => 5}),
) {

  $database_conf = "/etc/puppetlabs/${container}/conf.d/${tk_service}-database.conf"

  Pe_hocon_setting {
    path    => $database_conf,
    notify  => Service["pe-${container}"],
  }

  file { $database_conf:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    notify  => Service["pe-${container}"],
  }
  pe_hocon_setting { "${container}.${tk_service}.database.subprotocol":
    setting => "${tk_service}.database.subprotocol",
    value   => 'postgresql',
  }
  pe_hocon_setting { "${container}.${tk_service}.database.subname":
    setting => "${tk_service}.database.subname",
    value   => "//${database_host}:${database_port}/${database_name}${database_properties}",
  }
  pe_hocon_setting { "${container}.${tk_service}.database.user":
    setting => "${tk_service}.database.user",
    value   => $database_user,
  }

  pe_hocon_setting { "${container}.${tk_service}.database.migration-user":
    setting => "${tk_service}.database.migration-user",
    value   => $migration_user,
  }

  if !pe_empty($database_password) {
    pe_hocon_setting { "${container}.${tk_service}.database.password":
      setting => "${tk_service}.database.password",
      value   => $database_password,
    }
    pe_hocon_setting { "${container}.${tk_service}.database.migration-password":
      setting => "${tk_service}.database.migration-password",
      value   => $migration_password,
    }
  }

  pe_hocon_setting { "${container}.${tk_service}.database.maximum-pool-size":
    setting => "${tk_service}.database.maximum-pool-size",
    value   => $maximum_pool_size,
  }

  # Timeouts in this module are in seconds, but the services expect them in milliseconds
  pe_hocon_setting { "${container}.${tk_service}.database.connection-timeout":
    setting => "${tk_service}.database.connection-timeout",
    value   => $pool_timeout * 1000,
  }

  # Timeouts in this module are in seconds, but the services expect them in milliseconds
  pe_hocon_setting { "${container}.${tk_service}.database.connection-check-timeout":
    setting => "${tk_service}.database.connection-check-timeout",
    value   => $pool_check_timeout * 1000,
  }
}
