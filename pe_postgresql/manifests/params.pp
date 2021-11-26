# PRIVATE CLASS: do not use directly
class pe_postgresql::params inherits pe_postgresql::globals {
  $ensure                     = present
  $version                    = $globals_version
  $postgis_version            = $globals_postgis_version
  $listen_addresses           = 'localhost'
  $port                       = 5432
  $ip_mask_deny_postgres_user = '0.0.0.0/0'
  $ip_mask_allow_all_users    = '127.0.0.1/32'
  $ipv4acls                   = []
  $ipv6acls                   = []
  $encoding                   = $encoding
  $locale                     = $locale
  $service_ensure             = undef
  $service_provider           = $service_provider
  $manage_pg_hba_conf         = pe_pick($manage_pg_hba_conf, true)

  # Amazon Linux's OS Family is 'Linux', operating system 'Amazon'.
  case $::osfamily {
    'RedHat', 'Linux': {
      $user               = pe_pick($user, 'postgres')
      $group              = pe_pick($group, 'postgres')
      $needs_initdb       = pe_pick($needs_initdb, true)
      $version_parts      = split($version, '[.]')
      $package_version    = "${version_parts[0]}${version_parts[1]}"

      if $version == $default_version {
        $client_package_name  = pe_pick($client_package_name, 'postgresql')
        $server_package_name  = pe_pick($server_package_name, 'postgresql-server')
        $contrib_package_name = pe_pick($contrib_package_name,'postgresql-contrib')
        $devel_package_name   = pe_pick($devel_package_name, 'postgresql-devel')
        $java_package_name    = pe_pick($java_package_name, 'postgresql-jdbc')
        $plperl_package_name  = pe_pick($plperl_package_name, 'postgresql-plperl')
        $service_name         = pe_pick($service_name, 'postgresql')
        $bindir               = pe_pick($bindir, '/usr/bin')
        $datadir              = $::operatingsystem ? {
          'Amazon' => pe_pick($datadir, '/var/lib/pgsql9/data'),
          default  => pe_pick($datadir, '/var/lib/pgsql/data'),
        }
        $confdir              = pe_pick($confdir, $datadir)
      } else {
        $client_package_name  = pe_pick($client_package_name, "postgresql${package_version}")
        $server_package_name  = pe_pick($server_package_name, "postgresql${package_version}-server")
        $contrib_package_name = pe_pick($contrib_package_name,"postgresql${package_version}-contrib")
        $devel_package_name   = pe_pick($devel_package_name, "postgresql${package_version}-devel")
        $java_package_name    = pe_pick($java_package_name, "postgresql${package_version}-jdbc")
        $plperl_package_name  = pe_pick($plperl_package_name, "postgresql${package_version}-plperl")
        $service_name         = pe_pick($service_name, "postgresql-${version}")
        $bindir               = pe_pick($bindir, "/usr/pgsql-${version}/bin")
        $datadir              = $::operatingsystem ? {
          'Amazon' => pe_pick($datadir, "/var/lib/pgsql9/${version}/data"),
          default  => pe_pick($datadir, "/var/lib/pgsql/${version}/data"),
        }
        $confdir              = pe_pick($confdir, $datadir)
      }
      $psql_path            = pe_pick($psql_path, "${bindir}/psql")

      $service_status      = $service_status
      $perl_package_name   = pe_pick($perl_package_name, 'perl-DBD-Pg')
      $python_package_name = pe_pick($python_package_name, 'python-psycopg2')

      $postgis_package_name = pe_pick(
        $postgis_package_name,
        $::operatingsystemrelease ? {
          /5/     => 'postgis',
          default => versioncmp($postgis_version, '2') ? {
            '-1'    => "postgis${package_version}",
            default => "postgis2_${package_version}",}
        }
      )
    }

    'Archlinux': {
      $needs_initdb       = pe_pick($needs_initdb, true)
      $user               = pe_pick($user, 'postgres')
      $group              = pe_pick($group, 'postgres')

      # Archlinux doesn't have a client-package but has a libs package which
      # pulls in postgresql server
      $client_package_name  = pe_pick($client_package_name, 'postgresql')
      $server_package_name  = pe_pick($server_package_name, 'postgresql-libs')
      $java_package_name    = pe_pick($java_package_name, 'postgresql-jdbc')
      # Archlinux doesn't have develop packages
      $devel_package_name   = pe_pick($devel_package_name, 'postgresql-devel')
      # Archlinux does have postgresql-contrib but it isn't maintained
      $contrib_package_name = pe_pick($contrib_package_name,'undef')
      # Archlinux postgresql package provides plperl
      $plperl_package_name  = pe_pick($plperl_package_name, 'undef')
      $service_name         = pe_pick($service_name, 'postgresql')
      $bindir               = pe_pick($bindir, '/usr/bin')
      $datadir              = pe_pick($datadir, '/var/lib/postgres/data')
      $confdir              = pe_pick($confdir, $datadir)
      $psql_path            = pe_pick($psql_path, "${bindir}/psql")

      $service_status      = $service_status
      $python_package_name = pe_pick($python_package_name, 'python-psycopg2')
      # Archlinux does not have a perl::DBD::Pg package
      $perl_package_name = pe_pick($perl_package_name, 'undef')
    }

    'Debian': {
      $user               = pe_pick($user, 'postgres')
      $group              = pe_pick($group, 'postgres')

      if $manage_package_repo == true {
        $needs_initdb = pe_pick($needs_initdb, true)
        $service_name = pe_pick($service_name, 'postgresql')
      } else {
        $needs_initdb = pe_pick($needs_initdb, false)
        $service_name = $::operatingsystem ? {
          'Debian' => pe_pick($service_name, 'postgresql'),
          'Ubuntu' => $::lsbmajdistrelease ? {
            /^10/ => pe_pick($service_name, "postgresql-${version}"),
            default => pe_pick($service_name, 'postgresql'),
          },
          default => undef
        }
      }

      $client_package_name  = pe_pick($client_package_name, "postgresql-client-${version}")
      $server_package_name  = pe_pick($server_package_name, "postgresql-${version}")
      $contrib_package_name = pe_pick($contrib_package_name, "postgresql-contrib-${version}")
      $postgis_package_name = pe_pick(
        $postgis_package_name,
        versioncmp($postgis_version, '2') ? {
          '-1'    => "postgresql-${version}-postgis",
          default => "postgresql-${version}-postgis-${postgis_version}",
        }
      )
      $devel_package_name   = pe_pick($devel_package_name, 'libpq-dev')
      $java_package_name    = pe_pick($java_package_name, 'libpostgresql-jdbc-java')
      $perl_package_name    = pe_pick($perl_package_name, 'libdbd-pg-perl')
      $plperl_package_name  = pe_pick($plperl_package_name, "postgresql-plperl-${version}")
      $python_package_name  = pe_pick($python_package_name, 'python-psycopg2')

      $bindir               = pe_pick($bindir, "/usr/lib/postgresql/${version}/bin")
      $datadir              = pe_pick($datadir, "/var/lib/postgresql/${version}/main")
      $confdir              = pe_pick($confdir, "/etc/postgresql/${version}/main")
      $service_status       = $service_status
      $psql_path            = pe_pick($psql_path, "/usr/bin/psql")

    }

    'FreeBSD': {
      $user                 = pe_pick($user, 'pgsql')
      $group                = pe_pick($group, 'pgsql')

      $client_package_name  = pe_pick($client_package_name, "databases/postgresql${version}-client")
      $server_package_name  = pe_pick($server_package_name, "databases/postgresql${version}-server")
      $contrib_package_name = pe_pick($contrib_package_name, "databases/postgresql${version}-contrib")
      $devel_package_name   = pe_pick($devel_package_name, 'databases/postgresql-libpqxx3')
      $java_package_name    = pe_pick($java_package_name, 'databases/postgresql-jdbc')
      $perl_package_name    = pe_pick($plperl_package_name, 'databases/p5-DBD-Pg')
      $plperl_package_name  = pe_pick($plperl_package_name, "databases/postgresql${version}-plperl")
      $python_package_name  = pe_pick($python_package_name, 'databases/py-psycopg2')

      $service_name         = pe_pick($service_name, 'postgresql')
      $bindir               = pe_pick($bindir, '/usr/local/bin')
      $datadir              = pe_pick($datadir, '/usr/local/pgsql/data')
      $confdir              = pe_pick($confdir, $datadir)
      $service_status       = pe_pick($service_status, "/usr/local/etc/rc.d/${service_name} status")
      $psql_path            = pe_pick($psql_path, "${bindir}/psql")

      $needs_initdb         = pe_pick($needs_initdb, true)
    }

    'Suse': {
        # placeholder
    }

    default: {
      $psql_path            = pe_pick($psql_path, "${bindir}/psql")

      # Since we can't determine defaults on our own, we rely on users setting
      # parameters with the pe_postgresql::globals class. Here we are checking
      # that the mandatory minimum is set for the module to operate.
      $err_prefix = "Module ${module_name} does not provide defaults for osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}; please specify a value for ${module_name}::globals::"
      if ($needs_initdb == undef) { fail("${err_prefix}needs_initdb") }
      if ($service_name == undef) { fail("${err_prefix}service_name") }
      if ($client_package_name == undef) { fail("${err_prefix}client_package_name") }
      if ($server_package_name == undef) { fail("${err_prefix}server_package_name") }
      if ($bindir == undef) { fail("${err_prefix}bindir") }
      if ($datadir == undef) { fail("${err_prefix}datadir") }
      if ($confdir == undef) { fail("${err_prefix}confdir") }
    }
  }

  $initdb_path          = pe_pick($initdb_path, "${bindir}/initdb")
  $createdb_path        = pe_pick($createdb_path, "${bindir}/createdb")
  $pg_hba_conf_path     = pe_pick($pg_hba_conf_path, "${confdir}/pg_hba.conf")
  $pg_hba_conf_defaults = pe_pick($pg_hba_conf_defaults, true)
  $postgresql_conf_path = pe_pick($postgresql_conf_path, "${confdir}/postgresql.conf")
  $default_database     = pe_pick($default_database, 'postgres')
}
