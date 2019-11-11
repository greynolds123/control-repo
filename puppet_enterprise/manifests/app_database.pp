# A define type to manage the postgresql database for a PE application.
# In addition to ensuring the database exists, this installs extensions
# configures it for SSL client cert authentication.
#
# As the pe-postgresql module does not support configuration of ident.conf,
# this generates it using pe_concat fragments against $pg_ident_conf_path.
# These must be assembled externally using
# `pe_concat { $pg_ident_conf_path: ...}`.
#
# @param database_name [String] The name of the postgresql database to manage.
# @param database_user [String] The name of the postgresql user (role) to
#        manage.
# @param tablespace_name [String] In PE, each database is typically stored in a
#        separate tablespace. This is the name of the tablespace to use.
# @param tablespace_location [String] The directory where the tablespace should
#        be stored.
# @param ip_mask_allow_all_users_ssl [String] Addresses which are allowed to
#        connect to PostgreSQL over TCP for SSL connections
# @param ipv6_mask_allow_all_users_ssl [String] Addresses which are allowed to
#        connect to PostgreSQL over TCP for SSL connections (ipv6 version)
# @param pg_ident_conf_path [String] The path to the postgresql ident.conf
#        configuration file
# @param $client_certnames [Array<String>] The certnames which can access this
#        database (as $database_user) using ssl client cert authentication
# @param $extensions [Array<String>] The postgresql extensions which should be
#        installed in this database
define puppet_enterprise::app_database(
  String $database_name,
  String $database_user,
  String $tablespace_name,
  String $ip_mask_allow_all_users_ssl,
  String $ipv6_mask_allow_all_users_ssl,
  String $pg_ident_conf_path,
  Array $client_certnames,
  String $tablespace_location,
  String $database_password = '',
  Array $extensions = [],
) {
  # each database gets its own tablespace
  pe_postgresql::server::tablespace { $tablespace_name:
    location => $tablespace_location,
    require  => Class['::pe_postgresql::server'],
  }

  # For this module an API has been defined such that if a user/the installer
  # passes in the empty string for a database password, that database should go
  # unmanaged. This is because we don't want to ask a user for their database
  # password on upgrades or overwrite their passwords if they already exists.
  # This ternary block below for `$pdb_db_password` makes sure to not overwrite
  # user passwords if they pass in the empty string, but allows us to always
  # manage the database resource, even without a password.
  $_database_password = $database_password ? {
    ''      => undef,
    default => $database_password
  }

  pe_postgresql::server::role { $database_user:
    password_hash => $_database_password,
    require       => Pe_postgresql::Server::Tablespace[$tablespace_name],
  }

  pe_postgresql::server::db { $database_name:
    user       => $database_user,
    password   => $_database_password,
    tablespace => $tablespace_name,
    require    => Pe_postgresql::Server::Role[$database_user],
  }

  $extensions.each |$extension| {
    pe_postgresql_psql { "${database_name} extension ${extension}":
      command    => "CREATE EXTENSION ${extension};",
      db         => $database_name,
      port       => $pe_postgresql::params::port,
      psql_user  => $pe_postgresql::params::user,
      psql_group => $pe_postgresql::params::group,
      psql_path  => $pe_postgresql::params::psql_path,
      unless     => "select * from pg_extension where extname='${extension}'",
      require    => Pe_postgresql::Server::Db[$database_name],
    }
  }

  if $puppet_enterprise::database_cert_auth and pe_empty($_database_password) {
    $ident_map_key = "${database_name}-map"

    Pe_postgresql::Server::Pg_hba_rule {
      description => 'none',
      type        => 'hostssl',
      database    => $database_name,
      user        => $database_user,
      auth_method => 'cert',
      auth_option => "map=${ident_map_key} clientcert=1",
    }

    pe_postgresql::server::pg_hba_rule { "${database_name} cert auth rule":
      address     => $ip_mask_allow_all_users_ssl,
      order       => '0',
    }

    pe_postgresql::server::pg_hba_rule { "${database_name} ipv6 cert auth rule":
      address     => $ipv6_mask_allow_all_users_ssl,
      order       => '1',
    }

    # Create an ident rule fragment for pg_ident.conf
    $client_certnames.each |$client_certname| {
      pe_concat::fragment { "pg_ident_rule_${database_name}_${client_certname}":
        target  => $pg_ident_conf_path,
        content => "${ident_map_key} ${client_certname} ${database_user}",
      }
    }
  }
}
