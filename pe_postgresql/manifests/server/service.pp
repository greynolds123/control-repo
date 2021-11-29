# PRIVATE CLASS: do not call directly
class pe_postgresql::server::service {
  $ensure           = $pe_postgresql::server::ensure
  $service_ensure   = $pe_postgresql::server::service_ensure
  $service_name     = $pe_postgresql::server::service_name
  $service_provider = $pe_postgresql::server::service_provider
  $service_status   = $pe_postgresql::server::service_status
  $user             = $pe_postgresql::server::user
  $port             = $pe_postgresql::server::port
  $default_database = $pe_postgresql::server::default_database

  if $service_ensure {
    $real_service_ensure = $service_ensure
  } else {
    $real_service_ensure = $ensure ? {
      present => 'running',
      absent  => 'stopped',
      default => $ensure
    }
  }

  $service_enable = $ensure ? {
    present => true,
    absent  => false,
    default => $ensure
  }

  pe_anchor { 'pe_postgresql::server::service::begin': }

  service { 'postgresqld':
    ensure    => $real_service_ensure,
    name      => $service_name,
    enable    => $service_enable,
    provider  => $service_provider,
    hasstatus => true,
    status    => $service_status,
  }

  if $real_service_ensure == 'running' {
    # This blocks the class before continuing if chained correctly, making
    # sure the service really is 'up' before continuing.
    #
    # Without it, we may continue doing more work before the database is
    # prepared leading to a nasty race condition.
    pe_postgresql::validate_db_connection { 'validate_service_is_running':
      run_as          => $user,
      database_name   => $default_database,
      database_port   => $port,
      sleep           => 1,
      tries           => 60,
      create_db_first => false,
      require         => Service['postgresqld'],
      before          => Pe_anchor['pe_postgresql::server::service::end']
    }
  }

  pe_anchor { 'pe_postgresql::server::service::end': }
}
