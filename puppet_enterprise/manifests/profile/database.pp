# This is the class for configuring a node as a database node with Postgresql
# for PuppetDB, RBAC, Console Services, and the activity services databases for
# Puppet Enterprise.
#
# For more information, see the [README.md](./README.md)
#
# @param certname [String] Name of a certificate Postgres will use for
#        encrypting network traffic
# @param database_listen_addresses [String] The hostname and port that Postgres
#        will be listening on
# @param puppetdb_database_name [String] The name of the puppetdb database
# @param puppetdb_database_user [String] The user connecting to the puppetdb
#        database
# @param classifier_database_name [String] The name of the classifier database
# @param classifier_database_migration_user [String] The user for migrating the classifier database
# @param classifier_database_read_user [String] The read-only user for the classifier database
# @param classifier_database_write_user [String] The user with write access to
#        the classifier database
# @param rbac_database_name [String] The name of the rbac database
# @param rbac_database_migration_user [String] The user for migrating the rbac database
# @param rbac_database_migration_read_user [String] The read-only user for the rbac database
# @param rbac_database_migration_write_user [String] The user with write access
#        to the rbac database
# @param activity_database_name [String] The name of the activity database
# @param activity_database_migration_user [String] The user for migrating the activity database
# @param activity_database_read_user [String] The read-only user for the activity database
# @param activity_database_write_user [String] The user with write access to the activity database
# @param orchestrator_database_name [String] The name of the orchestrator database
# @param orchestrator_database_migration_user [String] The user for migrating
#        the orchestrator database
# @param orchestrator_database_read_user [String] The read-only user for the orchestrator database
# @param orchestrator_database_write_user [String] The user with write access
#        to the orchestrator database
# @param inventory_database_name [String] The name of the inventory database
# @param inventory_database_migration_user [String] The user for migrating
#        the inventory database
# @param inventory_database_read_user [String] The read-only user for the inventory database
# @param inventory_database_write_user [String] The user with write access
#        to the inventory database
# @param localcacert [String] The path to the local CA certificate. This will
#        be used instead of the CA that is in Puppet's ssl dir.
# @param maintenance_work_mem [String] The amount of memory Postgres can use
#        when performing maintenance operations
# @param wal_buffers [String] The amount of memory to be used for the
#        Write-Ahead Log (WAL) during a transaction
# @param work_mem [String] The amount of memory to be used by Postgres for
#        internal sorts and hashes before resorting to temporary disk files
# @param checkpoint_segments [String] (DEPRECATED - no longer exists in
#        Postgresql 9.6, use max_wal_size instead) The maximum number of log
#        file segments between automatic Write-Ahead Log (WAL) checkpoints
# @param max_wal_size [Integer] Maximum size in MB to let the WAL grow to
#        between automatic WAL checkpoints. The Postgres 9.6 default is 1000MB.
# @param checkpoint_completion_target [Float] Specifies the target of checkpoint
#        completion, as a fraction of total time between checkpoints
# @param checkpoint_timout [String] Maximum time between automatic WAL checkpoints
# @param log_min_messages [String] See postgres documentation
# @param log_min_error_statement [String] See postgres documentation
# @param log_error_verbosity [String] See postgres documentation
# @param log_min_duration_statement [String] The amount of time, in
#        milliseconds, a statement can run before creating an entry in the
#        Postgres log
# @param $log_checkpoints Enum['on','off'] Causes checkpoints and restartpoints
#        to be logged in the server log. Some statistics are included in the log
#        messages, including the number of buffers written and the time spent writing
#        them.
# @param $log_connections Causes each attempted connection to the server to be
#        logged, as well as successful completion of client authentication.
# @param $log_disconnections Causes session terminations to be logged. The log
#        output provides information similar to log_connections, plus the duration of
#        the session.
# @param $log_lock_waits Controls whether a log message is produced when a
#        session waits longer than deadlock_timeout to acquire a lock. This is useful
#        in determining if lock waits are causing poor performance.
# @param $log_temp_files Controls logging of temporary file names and sizes.
#        Temporary files can be created for sorts, hashes, and temporary query results.
#        A log entry is made for each temporary file when it is deleted. A value of
#        zero logs all temporary file information, while positive values log only files
#        whose size is greater than or equal to the specified number of kilobytes.
# @param $log_autovacuum_min_duration Causes each action executed by autovacuum
#        to be logged if it ran for at least the specified number of milliseconds.
#        Setting this to zero logs all autovacuum actions. Minus-one (the default)
#        disables logging autovacuum actions. For example, if you set this to 250ms
#        then all automatic vacuums and analyzes that run 250ms or longer will be
#        logged. In addition, when this parameter is set to any value other than -1,
#        a message will be logged if an autovacuum action is skipped due to the
#        existence of a conflicting lock.
# @param log_line_prefix [String] A printf-style string that is output at the
#        beginning of each log line. in the Postgres log
# @param effective_cache_size [String] The amount of disk space that is
#        available to a single query
# @param shared_buffers [String] The amount of memory that Postgres may use for
#        shared buffers
# @param memorysize_in_bytes [Integer] The amount of memory available in bytes
#        for managing kernal_shmmax setting
# @param max_connections [Integer] The maximum number of connections Postgres
#        will allow
# @param autovacuum_vacuum_scale_factor [Float] Specifies a fraction of the table
#        size when deciding whether to trigger a VACUUM.
# @param autovacuum_analyze_scale_factor [Float] Specifies a fraction of the table
#        size when deciding whether to trigger an ANALYZE.
# @param autovacuum_max_workers [Integer] Specifies the maximum number of
#        autovacuum processes (other than the autovacuum launcher) which may be
#        running at any one time
# @param autovacuum_work_mem [String] The maximum amount of memory to be used by
#        each autovacuum worker process.
# @param locale [String] The default locale to be used
# @param ctype [String] The default character classification to be used
# @param collate [String] The default string sort order to be used
# @param encoding [String] The default character set encoding to be used
# @param ssl_ciphers [Array[String]] The allowed list of ciphers
# @param ip_mask_allow_all_users [String] Addresses which are allowed to connect
#        to PostgreSQL over TCP
# @param ip_mask_allow_all_users_ssl [String] Addresses which are allowed to
#        connect to PostgreSQL over TCP for SSL connections
# @param ipv6_mask_allow_all_users [String] Addresses which are allowed to
#        connect to PostgreSQL over TCP (ipv6 version)
# @param ipv6_mask_allow_all_users_ssl [String] Addresses which are allowed to
#        connect to PostgreSQL over TCP for SSL connections (ipv6 version)
# @param $additional_pg_hba_rules [Hash] Takes a hash of hashes containing the
#        name of a rule to add and a hash of attributes to pass to pg_hba_rule
# @param console_database_name [String] This setting is no longer used
# @param console_database_user [String] This setting is no longer used
# @param console_database_password [String] This setting is no longer used
# @param puppetdb_database_password [String] This setting is no longer used
# @param puppetdb_hosts Array[String] An array of puppetdb hostnames
# @param console_hosts Array[String]  An array of console hostnames
# @param pcp_broker_hosts Array[String] An array of pcp_broker hostnames
# @param classifier_database_password [String] This setting is no longer used
# @param rbac_database_password [String] This setting is no longer used
# @param activity_database_password [String] This setting is no longer used
# @param max_worker_processes [Integer] See postgres documentation
# @param max_replication_slots [Integer] See postgres documentation
# @param max_wal_senders [Integer] See postgres documentation
# @param replication_mode [Enum] One of "none", "source", or "replica", which
#        indicates to console-services what the app should expect when
#        interacting with its database. Value must be the same as that provided
#        to the console config profile or app behavior will be incorrect.
# @param wal_level [String] See postgres documentation
# @param shared_preload_libraries [Array[String]] See postgres documentation
class puppet_enterprise::profile::database(
  $certname                       = $facts['clientcert'],
  $database_listen_addresses      = $puppet_enterprise::params::database_listen_addresses,
  $puppetdb_database_name         = $puppet_enterprise::puppetdb_database_name,
  $puppetdb_database_user         = $puppet_enterprise::puppetdb_database_user,
  $puppetdb_database_password     = undef,
  $classifier_database_name       = $puppet_enterprise::classifier_database_name,
  $classifier_database_user       = undef,
  $classifier_database_super_user = $puppet_enterprise::classifier_database_super_user,
  $classifier_database_read_user  = $puppet_enterprise::classifier_database_read_user,
  $classifier_database_write_user = $puppet_enterprise::classifier_database_write_user,
  $classifier_database_password   = undef,
  $rbac_database_name             = $puppet_enterprise::rbac_database_name,
  $rbac_database_user             = undef,
  $rbac_database_super_user       = $puppet_enterprise::rbac_database_super_user,
  $rbac_database_read_user        = $puppet_enterprise::rbac_database_read_user,
  $rbac_database_write_user       = $puppet_enterprise::rbac_database_write_user,
  $rbac_database_password         = undef,
  $activity_database_name         = $puppet_enterprise::activity_database_name,
  $activity_database_user         = undef,
  $activity_database_super_user   = $puppet_enterprise::activity_database_super_user,
  $activity_database_read_user    = $puppet_enterprise::activity_database_read_user,
  $activity_database_write_user   = $puppet_enterprise::activity_database_write_user,
  $activity_database_password     = undef,
  $orchestrator_database_name     = $puppet_enterprise::orchestrator_database_name,
  $orchestrator_database_user     = undef,
  $orchestrator_database_super_user = $puppet_enterprise::orchestrator_database_super_user,
  $orchestrator_database_read_user  = $puppet_enterprise::orchestrator_database_read_user,
  $orchestrator_database_write_user = $puppet_enterprise::orchestrator_database_write_user,
  $orchestrator_database_password = undef,
  String $inventory_database_name               = $puppet_enterprise::inventory_database_name,
  Optional[String] $inventory_database_user     = undef,
  String $inventory_database_super_user         = $puppet_enterprise::inventory_database_super_user,
  String $inventory_database_read_user          = $puppet_enterprise::inventory_database_read_user,
  String $inventory_database_write_user         = $puppet_enterprise::inventory_database_write_user,
  Optional[String] $inventory_database_password = undef,
  $localcacert                    = $puppet_enterprise::params::localcacert,
  String $maintenance_work_mem    = "${facts['memory']['system']['total_bytes'] / 1024 / 1024 / 8}MB",
  $wal_buffers                    = $puppet_enterprise::params::wal_buffers,
  Variant[Puppet_enterprise::Postgresql_setting_numeric_w_memory_unit_regex,
          Pattern[/\A\d+\Z/],
          Integer[64]]  $work_mem = $puppet_enterprise::params::work_mem,
  $checkpoint_segments            = undef, # DEPRECATED
  Integer $max_wal_size           = 6144,
  Float[0,1] $checkpoint_completion_target = 0.9,
  String     $checkpoint_timeout  = '10min',
  $log_min_duration_statement     = $puppet_enterprise::params::log_min_duration_statement,
  Puppet_enterprise::Postgres_log_levels $log_min_messages = 'warning',
  Puppet_enterprise::Postgres_log_levels $log_min_error_statement = 'error',
  Enum['terse','default','verbose'] $log_error_verbosity = 'default',
  Enum['on','off'] $log_checkpoints    = 'on',
  Enum['on','off'] $log_connections    = 'on',
  Enum['on','off'] $log_disconnections = 'on',
  Enum['on','off'] $log_lock_waits     = 'on',
  Integer          $log_temp_files     = puppet_enterprise::calculate_log_temp_files($work_mem),
  Integer $log_autovacuum_min_duration = 0,
  $log_line_prefix                = '%m [db:%d,sess:%c,pid:%p,vtid:%v,tid:%x] ',
  $effective_cache_size           = $puppet_enterprise::params::effective_cache_size,
  $shared_buffers                 = $puppet_enterprise::params::shared_buffers,
  $memorysize_in_bytes            = $puppet_enterprise::params::memorysize_in_bytes,
  Integer $max_connections        = 400,
  Float[0,1] $autovacuum_vacuum_scale_factor  = 0.08,
  Float[0,1] $autovacuum_analyze_scale_factor = 0.04,
  Integer $autovacuum_max_workers = pe_max( 3, pe_min( 8, $facts['processors']['count'] / 3)),
  String  $autovacuum_work_mem    = "${facts['memory']['system']['total_bytes'] / 1024 / 1024 / 8/ $autovacuum_max_workers}MB",
  $locale                         = 'en_US.UTF-8',
  $ctype                          = 'en_US.UTF-8',
  $collate                        = 'en_US.UTF-8',
  $encoding                       = 'UTF8',
  Array[String] $ssl_ciphers      = $puppet_enterprise::params::secure_ciphers,
  $ip_mask_allow_all_users        = '0.0.0.0/0',
  $ip_mask_allow_all_users_ssl    = '0.0.0.0/0',
  $ipv6_mask_allow_all_users      = '::/0',
  $ipv6_mask_allow_all_users_ssl  = '::/0',
  Hash[String, Hash] $additional_pg_hba_rules = {},
  $console_database_name          = undef,
  $console_database_user          = undef,
  $console_database_password      = undef,
  Array[String] $puppetdb_hosts   = ( puppet_enterprise::active_puppetdb_hosts() +
                                      pe_flatten([ $puppet_enterprise::puppetdb_hosts_array ])),
  Array[String] $console_hosts    = [ $puppet_enterprise::console_host ],
  Array[String] $pcp_broker_hosts = [ $puppet_enterprise::pcp_broker_host ],
  Puppet_enterprise::Replication_mode $replication_mode = 'none',
  String $replication_source_hostname = '',
  Array $replica_hostnames = [],
  Integer $max_worker_processes = 40,
  Integer $max_replication_slots = 20,
  Integer $max_wal_senders = 20,
  String  $wal_level = 'logical',
  Array[String]  $shared_preload_libraries = $puppet_enterprise::params::postgres_shared_preload_libraries,
  Hash           $auto_explain_settings    = {},
) inherits puppet_enterprise {

  if $::puppet_enterprise::database_ssl == false {
    fail('You may not set $puppet_enterprise::database_ssl to false when PE manages PostgreSQL.')
  }

  $database_names = [ $puppetdb_database_name,
                      $classifier_database_name,
                      $rbac_database_name,
                      $activity_database_name,
                      $orchestrator_database_name,
                      $inventory_database_name ]

  if pe_count(pe_unique( $database_names )) != 6 {
    fail( 'Database names must be unique' )
  }

  if $puppet_enterprise::database_cert_auth == false and $puppetdb_database_password == undef {
    fail('You must chose a PuppetDB database authetication method. Please set $puppet_enterprise::database_cert_auth or $puppetdb_database_password')
  } elsif $puppet_enterprise::database_cert_auth == true and $puppetdb_database_password != undef {
    fail('$puppetdb_database_password and $puppet_enterprise::database_cert_auth are both set. You may not use both certificate and password authentication')
  }


  # We would like to run silent with regards to the deprecation warning around
  # the package type's allow_virtual parameter, and so must explicitly set a
  # default for it as long as we support clients older than 3.6.1. No packages
  # are declared here, but the postgresql class has package types. We will take
  # advantage of another feature that will be deprecated at some point (dynamic
  # scope for resource defaults) to accomplish the desired suppression of the
  # deprecation warning without modifying the postgresql module itself, by
  # setting the package resource defaults here.
  Package {
    allow_virtual => $puppet_enterprise::params::allow_virtual_default,
  }

  $pgsqldir = "${puppet_enterprise::server_data_dir}/postgresql"
  $version = $puppet_enterprise::params::postgres_version
  $pg_user = $puppet_enterprise::pg_user
  $pg_group = $puppet_enterprise::pg_group
  $datadir = "${pgsqldir}/${version}/data"
  $pg_ident_conf_path = "${datadir}/pg_ident.conf"

  # set our parameters for the params for to inherit
  class { '::pe_postgresql::globals':
    user                 => $pg_user,
    group                => $pg_group,
    client_package_name  => $puppet_enterprise::params::postgresql_client_package_name,
    server_package_name  => $puppet_enterprise::params::postgresql_server_package_name,
    contrib_package_name => $puppet_enterprise::params::postgresql_contrib_package_name,
    service_name         => 'pe-postgresql',
    default_database     => $puppet_enterprise::params::postgresql_default_database,
    version              => $version,
    bindir               => $puppet_enterprise::server_bin_dir,
    datadir              => $datadir,
    confdir              => $datadir,
    psql_path            => $puppet_enterprise::pg_psql_path,
    needs_initdb         => true,
    locale               => $locale,
    ctype                => $ctype,
    collate              => $collate,
    encoding             => $encoding,
    pg_hba_conf_defaults => false,
  }

  include puppet_enterprise::postgresql::client
  class { '::pe_postgresql::server::contrib':
    package_ensure => $puppet_enterprise::postgresql_ensure,
  }

  include puppet_enterprise::packages

  $_postgresql_server_package_refs = [
    Class['pe_postgresql::server'],
    Class['pe_postgresql::server::contrib'],
    # Class['pe_postgresql::client'] ordering is handled by
    # puppet_enterprise::postgresql::client above
  ]
  if $puppet_enterprise::params::postgres_multi_version_packaging {
    Package <| tag == 'pe-psql-common' |> {
      before +> $_postgresql_server_package_refs,
    }
    $postgresql_package_refs = $_postgresql_server_package_refs + [
      Package['pe-postgresql-common']
    ]
  } else {
    $postgresql_package_refs = $_postgresql_server_package_refs
  }

  Package <| tag == 'pe-database-packages' |> {
    before +> $postgresql_package_refs,
  }

  if ($puppet_enterprise::params::postgres_first_version_number < 10) {
    Package <| tag == 'pe-psql-pglogical' |> {
      require => Package['postgresql-server'],
    }
  }
  Package <| tag == 'pe-database-extensions' |> {
    require => Package['postgresql-server'],
  }

  # manage the directories the pgsql server will use
  file {[$pgsqldir, "${pgsqldir}/${version}" ]:
    ensure  => directory,
    mode    => '0755',
    owner   => $pg_user,
    group   => $pg_group,
    require => Package['postgresql-server'],
  }

  file { "${datadir}/postgresql.conf" :
    ensure  => file,
    mode    => '0600',
    owner   => $pg_user,
    group   => $pg_group,
    require => [ Package['postgresql-server'],
                 Exec['postgresql_initdb'] ],
    notify  => Service['postgresqld'],
  }

  # This is a hack to workaround the fact that the postgresql module 3.4.0
  # hardcodes /etc/sysconfig/pgsql/postgresql, even though the path in PE is
  # /etc/sysconfig/pe-pgsql/pe-postgresql. We ensure
  # /etc/sysconfig/pgsql exists so the module can create and manage
  # pgsql/postgresql, and we symlink /etc/sysconfig/pe-pgsql/pe-postgresql to
  # it.
  if ($facts['os']['family'] == 'RedHat') and ($facts['os']['release']['major'] !~ '^7') {
    file { ['/etc/sysconfig/pgsql', '/etc/sysconfig/pe-pgsql']:
      ensure => directory,
    }

    file { '/etc/sysconfig/pe-pgsql/pe-postgresql':
      ensure => link,
      target => '/etc/sysconfig/pgsql/postgresql',
    }
  }

  # get the pg server up and running
  class { '::pe_postgresql::server':
    listen_addresses        => $database_listen_addresses,
    ip_mask_allow_all_users => $ip_mask_allow_all_users,
    package_ensure          => $puppet_enterprise::postgresql_ensure,
  }

  file { "${datadir}/certs" :
    ensure  => directory,
    mode    => '0600',
    owner   => $pg_user,
    group   => $pg_group,
    require => [Package['postgresql-server'], Class['pe_postgresql::server::initdb']],
  }

  $ssl_dir = $puppet_enterprise::params::ssl_dir
  $ssl_cert_file = "${datadir}/certs/_local.cert.pem"
  $ssl_key_file = "${datadir}/certs/_local.private_key.pem"
  $ssl_ca_file = $localcacert

  file { $ssl_cert_file:
    source  => "${ssl_dir}/certs/${certname}.pem",
    owner   => 'pe-postgres',
    group   => 'pe-postgres',
    mode    => '0400',
    require => File["${datadir}/certs"],
    notify   => Class['pe_postgresql::server::service'],
  }

  file { $ssl_key_file:
    source  => "${ssl_dir}/private_keys/${certname}.pem",
    owner   => 'pe-postgres',
    group   => 'pe-postgres',
    mode    => '0400',
    require => File["${datadir}/certs"],
    notify   => Class['pe_postgresql::server::service'],
  }

  if ($checkpoint_segments == undef) {
    $_max_wal_size = "${max_wal_size}MB"
  } else {
    warning('Deprecation: $puppet_enterprise::profile::database::checkpoint_segments is deprecated. If you need to adjust the size of the Postgresql WAL between checkpoints, please set $puppet_enterprise::profile::database::max_wal_size instead, but be aware that this defaults to 1000MB now (and the previous default of 16 checkpoint_segments was the equivalent of about 768MB. See Postgresql release notes for more information: https://www.postgresql.org/docs/9.6/static/release-9-5.html')
    # https://www.postgresql.org/docs/9.6/static/release-9-5.html
    # See checkpoint_segment release notes.
    $_translated_checkpoint_segments = 3 * Integer($checkpoint_segments) * 16
    $_max_wal_size = ($_translated_checkpoint_segments > $max_wal_size) ? {
        true  => "${_translated_checkpoint_segments}MB",
        false => "${max_wal_size}MB",
    }
  }

  $_shared_preload_libraries = pe_empty($auto_explain_settings) ? {
    true  => $shared_preload_libraries,
    false => $shared_preload_libraries + 'auto_explain',
  }

  $auto_explain_settings.each |$key, $val| {
    pe_postgresql::server::config_entry {$key:
      # Some values may be integers, but the postgres module expects strings
      value => String($val),
    }
  }

  $pg_config_settings = {
    'ssl'                             => on,
    'ssl_cert_file'                   => $ssl_cert_file,
    'ssl_key_file'                    => $ssl_key_file,
    'ssl_ca_file'                     => $ssl_ca_file,
    'ssl_ciphers'                     => pe_join($ssl_ciphers, ':'),
    'effective_cache_size'            => $effective_cache_size,
    'shared_buffers'                  => $shared_buffers,
    'maintenance_work_mem'            => $maintenance_work_mem,
    'wal_buffers'                     => $wal_buffers,
    'work_mem'                        => $work_mem,
    'max_wal_size'                    => $_max_wal_size,
    'checkpoint_completion_target'    => sprintf('%#.2f', $checkpoint_completion_target),
    'checkpoint_timeout'              => $checkpoint_timeout,
    'log_line_prefix'                 => $log_line_prefix,
    'log_min_duration_statement'      => $log_min_duration_statement,
    # PE-14944 Older versions had set $max_connections to 100, which is too low
    # so we will set it to a minimum of 200, regardless of what was passed in.
    'max_connections'                 => pe_max($max_connections, 200),
    'autovacuum_vacuum_scale_factor'  => sprintf('%#.2f', $autovacuum_vacuum_scale_factor),
    'autovacuum_analyze_scale_factor' => sprintf('%#.2f', $autovacuum_analyze_scale_factor),
    'wal_level'                       => $wal_level,
    'max_worker_processes'            => $max_worker_processes,
    'max_replication_slots'           => $max_replication_slots,
    'max_wal_senders'                 => $max_wal_senders,
    'shared_preload_libraries'        => pe_join($_shared_preload_libraries, ','),
    'autovacuum_max_workers'          => $autovacuum_max_workers,
    'autovacuum_work_mem'             => $autovacuum_work_mem,
    'log_checkpoints'                 => $log_checkpoints,
    'log_connections'                 => $log_connections,
    'log_disconnections'              => $log_disconnections,
    'log_lock_waits'                  => $log_lock_waits,
    'log_temp_files'                  => $log_temp_files,
    'log_autovacuum_min_duration'     => $log_autovacuum_min_duration,
    'log_min_messages'                => $log_min_messages,
    'log_min_error_statement'         => $log_min_error_statement,
    'log_error_verbosity'             => $log_error_verbosity,
  }

  $pg_config_settings.each |$key, $val| {
    pe_postgresql::server::config_entry {$key:
      # Some values may be integers, but the postgres module expects strings
      value => String($val),
    }
  }

  # No longer present in Postgresql 9.6; this guard can be removed when this
  # version of puppet_enterprise is no longer upgrading from 9.4.
  pe_postgresql::server::config_entry { 'checkpoint_segments':
    ensure => absent,
  }

  if $puppet_enterprise::database_cert_auth == false {
    pe_postgresql::server::pg_hba_rule { 'allow access to all ipv6':
      description => 'none',
      type        => 'hostssl',
      database    => 'all',
      user        => 'all',
      address     => $ipv6_mask_allow_all_users,
      auth_method => 'md5',
      order       => '101',
    }

    pe_postgresql::server::pg_hba_rule { 'allow access to all users':
      description => 'none',
      type        => 'hostssl',
      database    => 'all',
      user        => 'all',
      address     => $ip_mask_allow_all_users,
      auth_method => 'md5',
      order       => '100',
    }
  }

  pe_postgresql::server::pg_hba_rule { "local access as ${pg_user} user":
    database    => 'all',
    user        => $pg_user,
    type        => 'local',
    auth_method => 'peer',
    order       => '001',
  }

  $additional_pg_hba_rules.each | $rule_name, $rule_hash | {
    pe_postgresql::server::pg_hba_rule { $rule_name :
      * => $rule_hash,
    }
  }

  # This is essentially a hack until the pe_postgresql module has been updated
  # and we can use the `pg_ident_rule` type
  pe_concat { $pg_ident_conf_path:
    owner          => $pg_user,
    group          => $pg_group,
    force          => true, # do not crash if there is no pg_ident_rules
    mode           => '0640',
    warn           => true,
    require        => [Package['postgresql-server'], Class['pe_postgresql::server::initdb']],
    notify         => Class['pe_postgresql::server::reload'],
    ensure_newline => true,
  }

  $replication_user = 'pe-ha-replication'
  pe_postgresql::server::role { $replication_user:
    superuser     => true,
  }

  # *NOTE* this parameter is a development feature flag that is not suitable
  # for production. Do not use it for anything other than testing bidrectional
  # replication in development builds. It is currently only implemented as a
  # lookup(), and so must be set in pe.conf or another production hiera layer.
  # (This was done to prevent the parameter from showing up in the classifier)
  $two_way_replication = lookup('puppet_enterprise::ha_two_way_replication', { 'default_value' => false })

  # The replication user needs to be able to make a special 'replication'
  # connection from the replica back to the source. To do this, you write
  # 'replication' where you would usually write the database name in
  # pg_hba.conf.
  if $replication_mode == 'source' {
    $replica_hostnames.each |$replica| {
      puppet_enterprise::pg::cert_whitelist_entry {
        "Allow replication connections by ${replication_user} from ${replica}":
          user                          => $replication_user,
          database                      => 'replication',
          allowed_client_certname       => $replica,
          pg_ident_conf_path            => $pg_ident_conf_path,
          ip_mask_allow_all_users_ssl   => $ip_mask_allow_all_users_ssl,
          ipv6_mask_allow_all_users_ssl => $ipv6_mask_allow_all_users_ssl,
      }
    }
  } elsif ($two_way_replication and $replication_mode == 'replica') {
    puppet_enterprise::pg::cert_whitelist_entry {
      "Allow replication connections by ${replication_user} from ${replication_source_hostname}":
        user                          => $replication_user,
        database                      => 'replication',
        allowed_client_certname       => $replication_source_hostname,
        pg_ident_conf_path            => $pg_ident_conf_path,
        ip_mask_allow_all_users_ssl   => $ip_mask_allow_all_users_ssl,
        ipv6_mask_allow_all_users_ssl => $ipv6_mask_allow_all_users_ssl,
    }
  }

  # In PE, the maintenance database is named 'pe-postgres'. But pglogical
  # requires a database named 'postgres' to exist.
  pe_postgresql::server::database { 'postgres':
    owner   => $pe_postgresql::params::user,
    require => Class['::pe_postgresql::server']
  }

  if $puppet_enterprise::params::postgres_multi_version_packaging {
    # For backwards compatability
    pe_postgresql::server::database { 'pe-postgres':
      owner   => $pe_postgresql::params::user,
      require => Class['::pe_postgresql::server']
    }
  }

  Puppet_enterprise::App_database {
    certname                      => $certname,
    pg_ident_conf_path            => $pg_ident_conf_path,
    ip_mask_allow_all_users_ssl   => $ip_mask_allow_all_users_ssl,
    ipv6_mask_allow_all_users_ssl => $ipv6_mask_allow_all_users_ssl,
    ssl_cert_file                 => $ssl_cert_file,
    ssl_key_file                  => $ssl_key_file,
    ssl_ca_file                   => $ssl_ca_file,
    require                       => [
      File[$ssl_cert_file],
      File[$ssl_key_file],
    ],
    two_way_replication           => $two_way_replication,
    database_cert_auth            => $puppet_enterprise::database_cert_auth,
    enabled_replicas           => $puppet_enterprise::ha_enabled_replicas,
  }

  $default_extensions = ['pg_repack']

  puppet_enterprise::app_database { 'puppetdb':
    client_certnames    => pe_unique(
                             pe_union( [$certname], $puppetdb_hosts )
                           ),
    database_name       => $puppetdb_database_name,
    write_user          => $puppetdb_database_user,
    database_password   => $puppetdb_database_password,
    tablespace_name     => 'pe-puppetdb',
    tablespace_location => "${pgsqldir}/puppetdb",
    extensions          => $default_extensions + ['pg_trgm', 'pgcrypto'],
  }

  $console_certnames = pe_unique(
                           pe_union( [$certname] , $console_hosts )
                         )

  puppet_enterprise::app_database { 'classifier':
    client_certnames            => $console_certnames,
    database_name               => $classifier_database_name,
    super_user                  => $classifier_database_super_user,
    read_user                   => $classifier_database_read_user,
    write_user                  => $classifier_database_write_user,
    database_password           => $classifier_database_password,
    tablespace_name             => 'pe-classifier',
    tablespace_location         => "${pgsqldir}/classifier",
    extensions                  => $default_extensions,
    replication_mode            => $replication_mode,
    replication_user            => $replication_user,
    replication_source_hostname => $replication_source_hostname,
    replica_hostnames           => $replica_hostnames,
  }

  puppet_enterprise::app_database { 'rbac':
    client_certnames            => $console_certnames,
    database_name               => $rbac_database_name,
    super_user                  => $rbac_database_super_user,
    read_user                   => $rbac_database_read_user,
    write_user                  => $rbac_database_write_user,
    database_password           => $rbac_database_password,
    tablespace_name             => 'pe-rbac',
    tablespace_location         => "${pgsqldir}/rbac",
    extensions                  => $default_extensions + ['citext', 'pgcrypto'],
    replication_mode            => $replication_mode,
    replication_user            => $replication_user,
    replication_source_hostname => $replication_source_hostname,
    replica_hostnames           => $replica_hostnames,
  }

  puppet_enterprise::app_database { 'activity':
    client_certnames            => $console_certnames,
    database_name               => $activity_database_name,
    super_user                  => $activity_database_super_user,
    read_user                   => $activity_database_read_user,
    write_user                  => $activity_database_write_user,
    database_password           => $activity_database_password,
    tablespace_name             => 'pe-activity',
    tablespace_location         => "${pgsqldir}/activity",
    extensions                  => $default_extensions,
    replication_mode            => $replication_mode,
    replication_user            => $replication_user,
    replication_source_hostname => $replication_source_hostname,
    replica_hostnames           => $replica_hostnames,
  }

  puppet_enterprise::app_database { 'orchestrator':
    client_certnames            => pe_unique(
                                     pe_union( [$certname] , $pcp_broker_hosts )
                                   ),
    database_name               => $orchestrator_database_name,
    super_user                  => $orchestrator_database_super_user,
    read_user                   => $orchestrator_database_read_user,
    write_user                  => $orchestrator_database_write_user,
    database_password           => $orchestrator_database_password,
    tablespace_name             => 'pe-orchestrator',
    tablespace_location         => "${pgsqldir}/orchestrator",
    extensions                  => $default_extensions,
    replication_mode            => $replication_mode,
    replication_user            => $replication_user,
    replication_source_hostname => $replication_source_hostname,
    replica_hostnames           => $replica_hostnames,
  }

  puppet_enterprise::app_database { 'inventory':
    client_certnames            => pe_unique(
                                     pe_union( [$certname] , $pcp_broker_hosts )
                                   ),
    database_name               => $inventory_database_name,
    super_user                  => $inventory_database_super_user,
    read_user                   => $inventory_database_read_user,
    write_user                  => $inventory_database_write_user,
    database_password           => $inventory_database_password,
    tablespace_name             => 'pe-inventory',
    tablespace_location         => "${pgsqldir}/inventory",
    extensions                  => $default_extensions + ['pgcrypto'],
    replication_mode            => $replication_mode,
    replication_user            => $replication_user,
    replication_source_hostname => $replication_source_hostname,
    replica_hostnames           => $replica_hostnames,
  }
}
