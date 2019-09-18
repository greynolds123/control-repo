define pe_razor::server::database(
  $dbpassword,
  $setup_cert_auth,
  $db_listen_address = '*',
  Optional[String] $default_database = undef
) {
  include pe_razor::params

  # Without this, the default owner is 'pe-razor', which gets created
  # by the package (which hasn't happened yet).
  File {
    ensure => file,
    owner  => 'pe-postgres',
    group  => 'pe-postgres',
  }

  $pgsqldir       = $pe_razor::params::pgsqldir
  $version        = $pe_razor::params::pg_version
  $pgsql_data_dir = $pe_razor::params::pgsql_data_dir
  $_default_database = pe_empty($default_database) ? {
    true    => $pe_razor::params::postgresql_default_database,
    default => $default_database,
  }

  # set our parameters for the params for to inherit
  class { ':pe_postgresql::globals':
    user                 => 'pe-postgres',
    group                => 'pe-postgres',
    client_package_name  => $pe_razor::params::postgresql_client_package_name,
    contrib_package_name => $pe_razor::params::postgresql_contrib_package_name,
    server_package_name  => $pe_razor::params::postgresql_server_package_name,
    service_name         => 'pe-postgresql',
    default_database     => $_default_database,
    version              => $version,
    bindir               => $pe_razor::params::pg_bin_dir,
    datadir              => $pgsql_data_dir,
    confdir              => $pgsql_data_dir,
    psql_path            => $pe_razor::params::pg_sql_path,
    needs_initdb         => true,
    # If we need to set-up certificate authentication
    # for the DB, we will need full control over pg_hba.conf.
    # Otherwise, use whatever defaults the pe-postgresql module
    # ships with.
    pg_hba_conf_defaults => !$setup_cert_auth,
  }

  # manage the directories the pgsql server will use
  file {[$pgsqldir, "${pgsqldir}/${version}" ]:
    ensure  => directory,
    mode    => '0755',
    owner   => 'pe-postgres',
    group   => 'pe-postgres',
    require => Class['pe_postgresql::server::install'],
    before  => Class['pe_postgresql::server::initdb'],
  }
  # Ensure /etc/sysconfig/pgsql exists so the module can create and manage
  # pgsql/postgresql
  -> file { '/etc/sysconfig/pgsql':
    ensure => directory,
  }

  # get the pg server up and running
  class { '::pe_postgresql::server':
    listen_addresses        => $db_listen_address,
    ip_mask_allow_all_users => '0.0.0.0/0',
    package_ensure          => 'latest',
  }

  # The contrib package provides pg_upgrade, which is necessary for migrations
  # form one version of postgres (9.4 -> 9.6, for example)
  class { '::pe_postgresql::server::contrib':
    package_ensure => 'latest',
  }

  # The client package is a dependency of pe-postgresql-server, but upgrading
  # pe-postgresql-server to latest does not in all cases ensure that pe-postgresql
  # is upgrading to the same version. This resource makes it explicit.
  class { '::pe_postgresql::client':
    package_ensure => 'latest',
  }

  if $setup_cert_auth {
    # Since we're managing pg_hba.conf, we need to create a rule
    # that lets the pe-postgres user access the DB locally. Otherwise,
    # we won't be able to create our DB.
    $pe_postgres_local_access = 'allow pe_postgres local access'
    pe_postgresql::server::pg_hba_rule { $pe_postgres_local_access :
      type        => 'local',
      user        => 'pe-postgres',
      database    => 'all',
      auth_method => 'ident',
      order       => '001',
      before      => Pe_postgresql::Server::Tablespace['razor'],
    }

    pe_razor::server::database::cert_auth { 'configure database for cert. auth':
      pgsql_data_dir => $pgsql_data_dir,
      # The require ensures that the pe_postgres local access rule above is written
      # first in pg_hba.conf before any of our cert-auth config.
      require        => Pe_postgresql::Server::Pg_hba_rule[$pe_postgres_local_access],
    }
  }

  # If we are upgrading from < Kearney, this database is probably not present,
  # but it is the default database for pe-postgresql96 packaging and up.
  pe_postgresql::server::database { 'postgres':
    owner   => 'pe-postgres',
    require => Class['::pe_postgresql::server'],
  }

  # create the razor tablespace
  # create the razor database
  pe_postgresql::server::tablespace { 'razor':
    location => "${pgsqldir}/${version}/razor",
    require  => Class['::pe_postgresql::server'],
  }
  # create our database
  pe_postgresql::server::db { 'razor':
    user       => 'razor',
    password   => $dbpassword,
    tablespace => 'razor',
    require    => Pe_postgresql::Server::Tablespace['razor'],
  }
}
