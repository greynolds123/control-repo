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
# @param write_user [String] The name of the postgresql user (role) to
#        manage, which will have write access to the database.
# @param database_password [String] The password for the user that can login to
#        the PE application DB.
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
#        database using ssl client cert authentication
# @param $extensions [Array<String>] The postgresql extensions which should be
#        installed in this database
# @param $super_user [String] The name of the user to create which will have
#        superuser privileges, to be used for database migrations. If this is
#        specified, it will be expected to create and own all schema objects.
#        $write_user will be given write access to them.
# @param $read_user [String] The name of the user to create which will have
#        read-only access to the database.
# @param $replication_mode [Puppet_enterprise::Replication_mode] The way to
#        configure this database for pglogical replication.
# @param $replication_user [String] The user to use for pglogical replication;
#        must be a superuser, and already exist.
# @param $replication_source_hostname [String] When using
#        replication_mode=replica, the host from which data will be
#        replicated.
# @param $replica_hostnames [Array<String>] The hostnames of machines which will
#        replicate this database using pglogical; used to add to the cert whitelist.
# @param $ssl_cert_file [String] The path to the agent cert, used when
#        configuring replication. This path (and the other ssl paths)
#        must exist on both the master and the replica.
# @param $ssl_key_file [String] The path to the agent private key,
#        used when configuration replication.
# @param $ssl_ca_file [String] The path to the ca cert, used when
#        configuring replication.
# @param $two_way_replication [Boolean] This is a feature flag for
#        testing development builds of PE HA using two way logical
#        replication. Do not use it in production.
# @param $database_cert_auth [Boolean] Whether or not to enable SSL cert auth
#        when connecting with PostgreSQL.
# @param enabled_replicas [Array[String]] A list of replicas that are ready
#        to serve various services requests.
define puppet_enterprise::app_database(
  String $certname,
  String $database_name,
  String $write_user,
  String $tablespace_name,
  String $ip_mask_allow_all_users_ssl,
  String $ipv6_mask_allow_all_users_ssl,
  String $pg_ident_conf_path,
  Array $client_certnames,
  String $tablespace_location,
  String $database_password = '',
  Array $extensions = [],
  String $read_user = '',
  String $super_user = '',
  Puppet_enterprise::Replication_mode $replication_mode = 'none',
  String $replication_user = none,
  String $replication_source_hostname = '',
  Array $replica_hostnames = [],
  String $ssl_cert_file = none,
  String $ssl_key_file = none,
  String $ssl_ca_file = none,
  Boolean $two_way_replication = false,
  Boolean $database_cert_auth = true,
  Array[String] $enabled_replicas = [],
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

  if !pe_empty($super_user) {
    $database_owner = $super_user
    $owner_is_superuser = true
  } else {
    # We do this for apps which don't use pglogical (puppetdb)
    $database_owner = $write_user
    $owner_is_superuser = false
  }

  pe_postgresql::server::role { $database_owner:
    password_hash => $_database_password,
    superuser     => $owner_is_superuser,
    require       => Pe_postgresql::Server::Tablespace[$tablespace_name],
  }

  pe_postgresql::server::db { $database_name:
    user       => $database_owner,
    password   => $_database_password,
    tablespace => $tablespace_name,
    require    => Pe_postgresql::Server::Role[$database_owner],
  }

  Puppet_enterprise::Psql {
    db => $database_name
  }

  puppet_enterprise::psql { "${database_name} revoke public table create perms":
    command => 'REVOKE CREATE ON SCHEMA public FROM public',
    unless  => "SELECT * FROM
                  (SELECT has_schema_privilege('public', 'public', 'create') can_create) privs
                WHERE privs.can_create=false",
    require => Pe_postgresql::Server::Db[$database_name],
  }

  puppet_enterprise::psql { "grant table create to ${database_owner} on ${database_name}":
    command => "GRANT CREATE ON SCHEMA public TO \"${database_owner}\"",
    unless  => "SELECT * FROM
                  (SELECT has_schema_privilege('${database_owner}', 'public', 'create') can_create) privs
                WHERE privs.can_create=true",
    require => Pe_postgresql::Server::Db[$database_name],
  }

  if !pe_empty($super_user) {
    puppet_enterprise::pg::enforce_ownership { "${database_name} objects should be owned by ${super_user}":
      database => $database_name,
      schema   => 'public',
      owner    => $super_user,
      require  => Pe_postgresql::Server::Db[$database_name]
    }

    if !pe_empty($read_user) {
      puppet_enterprise::pg::ordinary_user{$read_user:
        user_name         => $read_user,
        database          => $database_name,
        database_password => $database_password,
        write_access      => false,
        db_owner          => $super_user,
        replication_user  => $replication_user,
        require           => Pe_postgresql::Server::Db[$database_name]
      }
    }

    if !pe_empty($write_user) {
      puppet_enterprise::pg::ordinary_user{$write_user:
        user_name         => $write_user,
        database          => $database_name,
        database_password => $database_password,
        write_access      => true,
        db_owner          => $super_user,
        replication_user  => $replication_user,
        require           => Pe_postgresql::Server::Db[$database_name]
      }
    }
  }

  $extensions.each |$extension| {
    puppet_enterprise::pg::extension { "${database_name}/${extension}":
      database  => $database_name,
      extension => $extension,
      require   => Pe_postgresql::Server::Db[$database_name],
    }
  }

  if $replication_mode == 'source' or $replication_mode == 'replica' {
    puppet_enterprise::pg::extension { "${database_name}/pglogical":
      database  => $database_name,
      extension => 'pglogical',
      require   => [
        Pe_postgresql::Server::Db[$database_name],
        Pe_postgresql::Server::Database['postgres'],
      ]
    }
  }

  $certname_sha = sha1($certname)
  $local_node_name = sprintf('n%.14s', $certname_sha)
  $subscription_name = sprintf('s%.14s', $certname_sha)

  $pglogical_opts = {
    database      => $database_name,
    user          => $replication_user,
    ssl_cert_file => $ssl_cert_file,
    ssl_key_file  => $ssl_key_file,
    ssl_ca_file   => $ssl_ca_file,
  }


  Puppet_enterprise::Pg::Pglogical::Subscription {
    subscription_name => $subscription_name,
    database          => $database_name,
    require           => [
      Puppet_enterprise::Pg::Extension["${database_name}/pglogical"],
      Puppet_enterprise::Pg::Pglogical::Node["${database_name}/${local_node_name}"],
      Class['pe_postgresql::server::reload'],
    ]
  }

  Puppet_enterprise::Pg::Pglogical::Replication_set {
    database             => $database_name,
    replication_set_name => 'default',
    schema               => 'public',
    require              => Puppet_enterprise::Pg::Extension["${database_name}/pglogical"],
  }

  if $replication_mode == 'source' or $replication_mode == 'replica' {
    # TODO how to make this work with external postgres?
    puppet_enterprise::pg::pglogical::node { "${database_name}/${local_node_name}":
      node_name => $local_node_name,
      host      => $certname,
      *         => $pglogical_opts,
      require   => [
        Puppet_enterprise::Pg::Extension["${database_name}/pglogical"],
        Class['pe_postgresql::server::reload'],
      ],
    }
  }

  # lint:ignore:case_without_default
  case $replication_mode {
    'source': {
      # Set up replication set so that replica can subscribe to the source
      puppet_enterprise::pg::pglogical::replication_set { "${database_name}/default":
        ensure => 'populated',
      }

      if $two_way_replication {
        # Have the source primary subscribe to the replicas as well.
        $replica_hostnames.each |$replica| {

          # Only attempt to configure a subscription from the master to a
          # replica if the replica has been enabled. Without this, the
          # master will attempt to subscribe to the postgres service on
          # the replica during provisioning...before the replica is even configured.
          # This will fail, breaking the catalog application.
          if $replica in $enabled_replicas {
            $replica_node_name = sprintf('n%.14s', sha1($replica))
            puppet_enterprise::pg::pglogical::subscription { "${database_name}/${subscription_name}_${replica_node_name}":
              ensure                => present,
              subscription_name     => "${subscription_name}_${replica_node_name}",
              host                  => $replica,
              synchronize_structure => false,
              *                     => $pglogical_opts,
            }
          }
        }
      } else {
          puppet_enterprise::pg::pglogical::subscription { "${database_name}/${subscription_name}":
            ensure => absent,
          }
      }
    }

    'replica': {
      $ensure_replication_set = $two_way_replication ? {
        true  => 'populated',
        false => 'empty',
      }
      puppet_enterprise::pg::pglogical::replication_set { "${database_name}/default":
        ensure => $ensure_replication_set,
      }

      puppet_enterprise::pg::pglogical::subscription { "${database_name}/${subscription_name}":
        ensure => present,
        host   => $replication_source_hostname,
        *      => $pglogical_opts,
      }
    }
  }
  # lint:endignore

  if $database_cert_auth and pe_empty($_database_password) {
    $client_cert_whitelist = pe_flatten($client_certnames.map |$client_certname| {
      [$super_user, $read_user, $write_user].map |$user| {
        if !pe_empty($user) {
          {allowed_client_certname => $client_certname, user => $user }
        } else {
          undef
        }
      }
    })

    $replication_peers = $replication_mode ? {
      'none' => [],
      /(source|replica)/ =>
        if $replication_source_hostname == '' {
          pe_unique(pe_union($replica_hostnames, [$certname]))
        } else {
          pe_unique(pe_union($replica_hostnames, [$replication_source_hostname, $certname]))
        }
    }

    $peer_replication_user_whitelist = $replication_peers.map |$peer| {
      { allowed_client_certname => $peer, user => $replication_user }
    }

    $full_whitelist = [
      $client_cert_whitelist,
      $peer_replication_user_whitelist,
    ].reduce |$wl1, $wl2| {
      pe_union($wl1, $wl2)
    }

    $full_whitelist.each |$entry| {
      if $entry {
        puppet_enterprise::pg::cert_whitelist_entry {
          "Allow ${entry['allowed_client_certname']} to connect to ${database_name} as ${entry['user']}":
            database                      => $database_name,
            pg_ident_conf_path            => $pg_ident_conf_path,
            ip_mask_allow_all_users_ssl   => $ip_mask_allow_all_users_ssl,
            ipv6_mask_allow_all_users_ssl => $ipv6_mask_allow_all_users_ssl,
            * => $entry,
        }
      }
    }
  }
}
