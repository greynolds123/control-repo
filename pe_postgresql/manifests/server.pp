# This installs a PostgreSQL server. See README.md for more details.
class pe_postgresql::server (
  $ensure                     = $pe_postgresql::params::ensure,

  $postgres_password          = undef,

  $package_name               = $pe_postgresql::params::server_package_name,
  $client_package_name        = $pe_postgresql::params::client_package_name,
  $package_ensure             = $ensure,

  $plperl_package_name        = $pe_postgresql::params::plperl_package_name,

  $service_ensure             = $pe_postgresql::params::service_ensure,
  $service_name               = $pe_postgresql::params::service_name,
  $service_provider           = $pe_postgresql::params::service_provider,
  $service_status             = $pe_postgresql::params::service_status,
  $default_database           = $pe_postgresql::params::default_database,

  $listen_addresses           = $pe_postgresql::params::listen_addresses,
  $port                       = $pe_postgresql::params::port,
  $ip_mask_deny_postgres_user = $pe_postgresql::params::ip_mask_deny_postgres_user,
  $ip_mask_allow_all_users    = $pe_postgresql::params::ip_mask_allow_all_users,
  $ipv4acls                   = $pe_postgresql::params::ipv4acls,
  $ipv6acls                   = $pe_postgresql::params::ipv6acls,

  $initdb_path                = $pe_postgresql::params::initdb_path,
  $createdb_path              = $pe_postgresql::params::createdb_path,
  $psql_path                  = $pe_postgresql::params::psql_path,
  $pg_hba_conf_path           = $pe_postgresql::params::pg_hba_conf_path,
  $postgresql_conf_path       = $pe_postgresql::params::postgresql_conf_path,

  $datadir                    = $pe_postgresql::params::datadir,
  $xlogdir                    = $pe_postgresql::params::xlogdir,

  $pg_hba_conf_defaults       = $pe_postgresql::params::pg_hba_conf_defaults,

  $user                       = $pe_postgresql::params::user,
  $group                      = $pe_postgresql::params::group,

  $needs_initdb               = $pe_postgresql::params::needs_initdb,

  $encoding                   = $pe_postgresql::params::encoding,
  $locale                     = $pe_postgresql::params::locale,
  $ctype                      = $pe_postgresql::params::ctype,
  $collate                    = $pe_postgresql::params::collate,

  $manage_pg_hba_conf         = $pe_postgresql::params::manage_pg_hba_conf,

  #Deprecated
  $version                    = $pe_postgresql::params::version,
) inherits pe_postgresql::params {
  $pg = 'pe_postgresql::server'

  if ($ensure == 'present' or $ensure == true) {
    # Reload has its own ordering, specified by other defines
    class { "${pg}::reload": require => Class["${pg}::install"] }

    pe_anchor { "${pg}::start": }->
    class { "${pg}::install": }->
    class { "${pg}::initdb": }->
    class { "${pg}::config": }->
    class { "${pg}::service": }->
    class { "${pg}::passwd": }->
    pe_anchor { "${pg}::end": }
  } else {
    pe_anchor { "${pg}::start": }->
    class { "${pg}::passwd": }->
    class { "${pg}::service": }->
    class { "${pg}::install": }->
    class { "${pg}::initdb": }->
    class { "${pg}::config": }->
    pe_anchor { "${pg}::end": }
  }
}
