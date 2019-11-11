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
# @param classifier_database_user [String] The user connecting to the
#        classifier database
# @param rbac_database_name [String] The name of the rbac database
# @param rbac_database_user [String] The user connecting to the rbac database
# @param activity_database_name [String] The name of the activity database
# @param activity_database_user [String] The user connecting to the activity
#        database
# @param localcacert [String] The path to the local CA certificate. This will
#        be used instead of the CA that is in Puppet's ssl dir.
# @param maintenance_work_mem [String] The amount of memory Postgres can use
#        when performing maintenance operations
# @param wal_buffers [String] The amount of memory to be used for the
#        Write-Ahead Log (WAL) during a transaction
# @param work_mem [String] The amount of memory to be used by Postgres for
#        internal sorts and hashes before resorting to temporary disk files
# @param checkpoint_segments [String] The maximum number of log file segments
#        between automatic Write-Ahead Log (WAL) checkpoints
# @param log_min_duration_statement [String] The amount of time, in
#        milliseconds, a statement can run before creating an entry in the
#        Postgres log
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
# @param ip_mask_allow_all_users [String] Addresses which are allowed to connect
#        to PostgreSQL over TCP
# @param ip_mask_allow_all_users_ssl [String] Addresses which are allowed to
#        connect to PostgreSQL over TCP for SSL connections
# @param ipv6_mask_allow_all_users [String] Addresses which are allowed to
#        connect to PostgreSQL over TCP (ipv6 version)
# @param ipv6_mask_allow_all_users_ssl [String] Addresses which are allowed to
#        connect to PostgreSQL over TCP for SSL connections (ipv6 version)
# @param console_database_name [String] This setting is no longer used
# @param console_database_user [String] This setting is no longer used
# @param console_database_password [String] This setting is no longer used
# @param puppetdb_database_password [String] This setting is no longer used
# @param classifier_database_password [String] This setting is no longer used
# @param rbac_database_password [String] This setting is no longer used
# @param activity_database_password [String] This setting is no longer used
class puppet_enterprise::profile::database(
  $certname                       = $::clientcert,
  $database_listen_addresses      = $puppet_enterprise::params::database_listen_addresses,
  $puppetdb_database_name         = $puppet_enterprise::puppetdb_database_name,
  $puppetdb_database_user         = $puppet_enterprise::puppetdb_database_user,
  $puppetdb_database_password     = undef,
  $classifier_database_name       = $puppet_enterprise::classifier_database_name,
  $classifier_database_user       = $puppet_enterprise::classifier_database_user,
  $classifier_database_password   = undef,
  $rbac_database_name             = $puppet_enterprise::rbac_database_name,
  $rbac_database_user             = $puppet_enterprise::rbac_database_user,
  $rbac_database_password         = undef,
  $activity_database_name         = $puppet_enterprise::activity_database_name,
  $activity_database_user         = $puppet_enterprise::activity_database_user,
  $activity_database_password     = undef,
  $orchestrator_database_name     = $puppet_enterprise::orchestrator_database_name,
  $orchestrator_database_user     = $puppet_enterprise::orchestrator_database_user,
  $orchestrator_database_password = undef,
  $localcacert                    = $puppet_enterprise::params::localcacert,
  $maintenance_work_mem           = $puppet_enterprise::params::maintenance_work_mem,
  $wal_buffers                    = $puppet_enterprise::params::wal_buffers,
  $work_mem                       = $puppet_enterprise::params::work_mem,
  $checkpoint_segments            = $puppet_enterprise::params::checkpoint_segments,
  $log_min_duration_statement     = $puppet_enterprise::params::log_min_duration_statement,
  $log_line_prefix                = '%m [db:%d,sess:%c,pid:%p,vtid:%v,tid:%x] ',
  $effective_cache_size           = $puppet_enterprise::params::effective_cache_size,
  $shared_buffers                 = $puppet_enterprise::params::shared_buffers,
  $memorysize_in_bytes            = $puppet_enterprise::params::memorysize_in_bytes,
  Integer $max_connections        = $puppet_enterprise::params::max_connections,
  Float[0,1] $autovacuum_vacuum_scale_factor  = 0.08,
  Float[0,1] $autovacuum_analyze_scale_factor = 0.04,
  $locale                         = 'en_US.UTF-8',
  $ctype                          = 'en_US.UTF-8',
  $collate                        = 'en_US.UTF-8',
  $encoding                       = 'UTF8',
  $ip_mask_allow_all_users        = '0.0.0.0/0',
  $ip_mask_allow_all_users_ssl    = '0.0.0.0/0',
  $ipv6_mask_allow_all_users      = '::/0',
  $ipv6_mask_allow_all_users_ssl  = '::/0',
  $console_database_name          = undef,
  $console_database_user          = undef,
  $console_database_password      = undef,
  Array[String] $puppetdb_hosts   = pe_flatten( [ $puppet_enterprise::puppetdb_host ]),
  Array[String] $console_hosts    = [ $puppet_enterprise::console_host ],
  Array[String] $pcp_broker_hosts = [ $puppet_enterprise::pcp_broker_host ],

) inherits puppet_enterprise {

  $database_names = [ $puppetdb_database_name,
                      $classifier_database_name,
                      $rbac_database_name,
                      $activity_database_name,
                      $orchestrator_database_name ]

  if pe_count(pe_unique( $database_names )) != 5 {
    fail( 'Database names must be unique' )
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
  $pg_user = 'pe-postgres'
  $pg_group = 'pe-postgres'
  $datadir = "${pgsqldir}/${version}/data"
  $pg_ident_conf_path = "${datadir}/pg_ident.conf"

  # set our parameters for the params for to inherit
  class { '::pe_postgresql::globals':
    user                 => $pg_user,
    group                => $pg_group,
    client_package_name  => $puppet_enterprise::postgresql_client_package_name,
    server_package_name  => 'pe-postgresql-server',
    contrib_package_name => 'pe-postgresql-contrib',
    service_name         => 'pe-postgresql',
    default_database     => 'pe-postgres',
    version              => $version,
    bindir               => $puppet_enterprise::server_bin_dir,
    datadir              => $datadir,
    confdir              => $datadir,
    psql_path            => "${puppet_enterprise::server_bin_dir}/psql",
    needs_initdb         => true,
    locale               => $locale,
    ctype                => $ctype,
    collate              => $collate,
    encoding             => $encoding,
  }

  include puppet_enterprise::postgresql::client
  class { '::pe_postgresql::server::contrib':
    package_ensure => $puppet_enterprise::postgresql_ensure,
  }

  include puppet_enterprise::packages
  Package <| tag == 'pe-psql-pglogical' |> {
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

  # This is a hack to workaround the fact that the postgresql module 3.4.0
  # hardcodes /etc/sysconfig/pgsql/postgresql, even though the path in PE is
  # /etc/sysconfig/pe-pgsql/pe-postgresql. We ensure
  # /etc/sysconfig/pgsql exists so the module can create and manage
  # pgsql/postgresql, and we symlink /etc/sysconfig/pe-pgsql/pe-postgresql to
  # it.
  if ($::osfamily == 'RedHat') and ($::operatingsystemrelease !~ /^7/) {
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
    before  => Puppet_enterprise::Certs[$pg_user],
  }
  # use existing certs/key from puppet master
  # and place them in pgsql dir
  puppet_enterprise::certs { $pg_user:
    certname => $certname,
    cert_dir => "${datadir}/certs",
    notify   => Class['pe_postgresql::server::service'],
  }

  # enable ssl in postgres using certs/key
  pe_postgresql::server::config_entry { 'ssl':
    value => on,
  }

  # tell postgresql host cert name
  pe_postgresql::server::config_entry { 'ssl_cert_file':
    value => "certs/${certname}.cert.pem",
  }

  # tell postgresql host private key name
  pe_postgresql::server::config_entry { 'ssl_key_file':
    value => "certs/${certname}.private_key.pem",
  }

  # tell postgresql CA cert name
  pe_postgresql::server::config_entry { 'ssl_ca_file':
    value => $localcacert,
  }

  # These values were originally in the pe_puppetdb
  # module but are now defaults managed here
  pe_postgresql::server::config_entry { 'effective_cache_size':
    value => $effective_cache_size,
  }

  pe_postgresql::server::config_entry { 'shared_buffers':
    value => $shared_buffers,
  }

  pe_postgresql::server::config_entry { 'maintenance_work_mem':
    value => $maintenance_work_mem,
  }

  pe_postgresql::server::config_entry { 'wal_buffers':
    value => $wal_buffers,
  }

  pe_postgresql::server::config_entry { 'work_mem':
    value => $work_mem,
  }

  pe_postgresql::server::config_entry { 'checkpoint_segments':
    value => $checkpoint_segments,
  }

  pe_postgresql::server::config_entry { 'log_line_prefix':
    value => $log_line_prefix,
  }

  pe_postgresql::server::config_entry { 'log_min_duration_statement':
    value => $log_min_duration_statement,
  }

  # PE-14944 Older versions had set $max_connections to 100, which is too low
  # so we will set it to a minimum of 200, regardless of what was passed in.
  $_max_connections = pe_max($max_connections, 200)

  #Our version of config_entry can't handle an integer directly
  pe_postgresql::server::config_entry { 'max_connections':
    value => "${_max_connections}",
  }

  pe_postgresql::server::config_entry { 'autovacuum_vacuum_scale_factor':
    value => "${autovacuum_vacuum_scale_factor}",
  }

  pe_postgresql::server::config_entry { 'autovacuum_analyze_scale_factor':
    value => "${autovacuum_analyze_scale_factor}",
  }

  pe_postgresql::server::pg_hba_rule { 'allow access to all ipv6':
    description => 'none',
    type        => 'host',
    database    => 'all',
    user        => 'all',
    address     => $ipv6_mask_allow_all_users,
    auth_method => 'md5',
    order       => '2',
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

  Puppet_enterprise::App_database {
    pg_ident_conf_path            => $pg_ident_conf_path,
    ip_mask_allow_all_users_ssl   => $ip_mask_allow_all_users_ssl,
    ipv6_mask_allow_all_users_ssl => $ipv6_mask_allow_all_users_ssl,
  }

  puppet_enterprise::app_database { 'puppetdb':
    client_certnames    => pe_unique(
                             pe_union( [$certname], $puppetdb_hosts )
                           ),
    database_name       => $puppetdb_database_name,
    database_user       => $puppetdb_database_user,
    database_password   => $puppetdb_database_password,
    tablespace_name     => 'pe-puppetdb',
    tablespace_location => "${pgsqldir}/puppetdb",
    extensions          => ['pg_trgm', 'pgcrypto'],
  }

  $console_certnames = pe_unique(
                           pe_union( [$certname] , $console_hosts )
                         )

  puppet_enterprise::app_database { 'classifier':
    client_certnames    => $console_certnames,
    database_name       => $classifier_database_name,
    database_user       => $classifier_database_user,
    database_password   => $classifier_database_password,
    tablespace_name     => 'pe-classifier',
    tablespace_location => "${pgsqldir}/classifier",
  }

  puppet_enterprise::app_database { 'rbac':
    client_certnames    => $console_certnames,
    database_name       => $rbac_database_name,
    database_user       => $rbac_database_user,
    database_password   => $rbac_database_password,
    tablespace_name     => 'pe-rbac',
    tablespace_location => "${pgsqldir}/rbac",
    extensions          => ['citext'],
  }

  puppet_enterprise::app_database { 'activity':
    client_certnames    => $console_certnames,
    database_name       => $activity_database_name,
    database_user       => $activity_database_user,
    database_password   => $activity_database_password,
    tablespace_name     => 'pe-activity',
    tablespace_location => "${pgsqldir}/activity",
  }

  puppet_enterprise::app_database { 'orchestrator':
    client_certnames    => pe_unique(
                             pe_union( [$certname] , $pcp_broker_hosts )
                           ),
    database_name       => $orchestrator_database_name,
    database_user       => $orchestrator_database_user,
    database_password   => $orchestrator_database_password,
    tablespace_name     => 'pe-orchestrator',
    tablespace_location => "${pgsqldir}/orchestrator",
  }
}
