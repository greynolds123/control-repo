# This class can be used to setup and install PuppetDB on a node
#
# This class should not be called directly, but rather is used by the profiles.
# For more information, see the [README.md](./README.md)
#
# @param cert_whitelist_path [String] The file where the puppetdb certificate whitelist file will
#        be written.
# @param database_host [String] The hostname of the database that PuppetDB will be running on
# @param certname [String] Name of a certificate Postgres will use for encrypting network traffic
# @param confdir [String] The path to PuppetDB's confdir
# @param database_name [String] The name of the PuppetDB Database
# @param database_password [String] The password of the user
# @param database_port [Integer] The port that the database is running on
# @param database_user [String] The user logging into the database
# @param gc_interval [String] The interval, in minutes, at which garbage collection should occur
# @param node_purge_ttl [String] The amount of time that must elapse before a deactivated node is
#        purged from PuppetDB
# @param node_ttl [String] The amount of time that must elapse before a node is deactivated from
#        PuppetDB
# @param report_ttl [String] The amount of time that must elapse before a report is deleted
# @param listen_address [String] The address which the database is listening on for plain text
#        connections
# @param listen_port [Integer] The port which PuppetDB Listens on for plain text connections
# @param ssl_listen_address [String] The address which the database is listening on for SSL
#        connections
# @param ssl_listen_port [Integer] The port which PuppetDB Listens on for SSL connections
# @param localcacert [String] The path to the local CA certificate
# @param database_properties [String] A url encoded string of JDBC options. This will replace the
#        default database property string which enables SSL connections.
# @param java_args [Hash] A hash containing Java options that puppetdb will run with
# @param auto_configure_sync [Boolean] Set this to true to automatically create a puppetdb sync.ini
#        configured to sync with all other configured PuppetDB nodes.
# @param read_maximum_pool_size [Integer] this value will determine the maximum number
#        of actual connections to the database backend for read connections
# @param write_maximum_pool_size [Integer] this value will determine the maximum number
#        of actual connections to the database backend for write connections
# @param read_database_name [String] The name of the read PuppetDB Database
# @param read_database_password [String] The password of the user for the read PuppetDB database
# @param read_database_port [Integer] The port that the read database is running on
# @param read_database_user [String] The user logging into the read database
# @param read_database_host [String] The hostname of the read database that PuppetDB will be running on
# @param read_database_properties [String] A url encoded string of JDBC options. This will replace the
#        default read database property string which enables SSL connections.
# @param rbac_url [String] The URL of the RBAC service.
class puppet_enterprise::puppetdb(
  $cert_whitelist_path,
  $database_host,
  $certname             = $::clientcert,
  $confdir              = $puppet_enterprise::params::puppetdb_confdir,
  $database_name        = $puppet_enterprise::params::puppetdb_database_name,
  $database_password    = undef,
  $database_port        = $puppet_enterprise::params::database_port,
  $database_user        = $puppet_enterprise::params::puppetdb_database_user,
  $gc_interval          = $puppet_enterprise::params::puppetdb_gc_interval,
  $node_purge_ttl       = $puppet_enterprise::params::puppetdb_node_purge_ttl,
  $node_ttl             = $puppet_enterprise::params::puppetdb_node_ttl,
  $report_ttl           = $puppet_enterprise::params::puppetdb_report_ttl,
  $listen_address       = $puppet_enterprise::params::plaintext_address,
  $listen_port          = $puppet_enterprise::params::puppetdb_listen_port,
  $ssl_listen_address   = $puppet_enterprise::params::ssl_address,
  $ssl_listen_port      = $puppet_enterprise::params::puppetdb_ssl_listen_port,
  $localcacert          = $puppet_enterprise::params::localcacert,
  $database_properties  = '',
  $java_args            = $puppet_enterprise::params::puppetdb_java_args,
  $service_stop_retries = 60,
  $start_timeout        = 120,
  $auto_configure_sync  = undef,
  Optional[
    Array[
      Struct[{
        host => String,
        port => Integer,
        sync_interval_minutes => Integer}]]] $sync_peers = undef,
  Integer           $read_maximum_pool_size     = 25,
  Optional[Integer] $write_maximum_pool_size    = undef,
  Optional[String]  $read_database_host         = undef,
  Optional[String]  $read_database_name         = undef,
  Optional[String]  $read_database_password     = undef,
  Optional[Integer] $read_database_port         = undef,
  Optional[String]  $read_database_user         = undef,
  Optional[String]  $read_database_properties   = undef,
  Integer           $command_processing_threads = pe_max(($::processors['count'] / 2), 1),
  Optional[String] $rbac_url = undef,
) inherits puppet_enterprise::params {

  $_write_maximum_pool_size = pe_pick( $write_maximum_pool_size, pe_max( 25, ($command_processing_threads * 2) ))
  $_read_database_host = pe_pick($read_database_host, $database_host)
  $_read_database_name = pe_pick($read_database_name, $database_name)
  $_read_database_port = 0 + pe_pick($read_database_port, $database_port)
  $_read_database_user = pe_pick($read_database_user, $database_user)

  #can't use pe_pick to set something to a value of undef
  if pe_empty($read_database_password) {
    $_read_database_password = $database_password
  } else {
    $_read_database_password = $read_database_password
  }

  #can't use pe_pick to set something to a value of ''
  if pe_empty($read_database_properties) {
    $_read_database_properties = $database_properties
  } else {
    $_read_database_properties = $read_database_properties
  }

  pe_validate_single_integer($service_stop_retries)
  pe_validate_single_integer($start_timeout)

  include puppet_enterprise::packages
  $container = 'pe-puppetdb'
  Package <| tag == 'pe-puppetdb-packages' |>

  #database.ini
  class { 'puppet_enterprise::puppetdb::database_ini':
    confdir             => $confdir,
    database_host       => $database_host,
    database_name       => $database_name,
    database_password   => $database_password,
    database_port       => $database_port,
    database_user       => $database_user,
    database_properties => $database_properties,
    gc_interval         => $gc_interval,
    node_purge_ttl      => $node_purge_ttl,
    node_ttl            => $node_ttl,
    report_ttl          => $report_ttl,
    write_maximum_pool_size => $_write_maximum_pool_size,
  }

  #read-database.ini
  puppet_enterprise::puppetdb::shared_database_settings { 'read-database' :
    confdir             => $confdir,
    database_host       => $_read_database_host,
    database_name       => $_read_database_name,
    database_password   => $_read_database_password,
    database_port       => $_read_database_port,
    database_user       => $_read_database_user,
    database_properties => $_read_database_properties,
    maximum_pool_size   => $read_maximum_pool_size,
  }

  class { 'puppet_enterprise::puppetdb::jetty_ini':
    certname            => $certname,
    cert_whitelist_path => $cert_whitelist_path,
    confdir             => $confdir,
    listen_address      => $listen_address,
    listen_port         => $listen_port,
    ssl_listen_address  => $ssl_listen_address,
    ssl_listen_port     => $ssl_listen_port,
    localcacert         => $localcacert,
  }

  class { 'puppet_enterprise::puppetdb::rbac_consumer_conf':
    certname    => $certname,
    confdir     => $confdir,
    localcacert => $localcacert,
    rbac_url    => $rbac_url,
  }

  if($sync_peers) {
    class { 'puppet_enterprise::puppetdb::sync_ini':
      peers   => $sync_peers,
      confdir => $confdir,
    }
  }

  class { 'puppet_enterprise::puppetdb::config_ini' :
    confdir                    => $confdir,
    command_processing_threads => $command_processing_threads,
  }

  class { 'puppet_enterprise::puppetdb::service': }

  file { '/var/log/puppetlabs/puppetdb':
    ensure  => directory,
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb']
  }

  file { '/var/log/puppetlabs/puppetdb/puppetdb.log':
    ensure  => present,
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb']
  }

  $puppetdb_initconf = "${puppet_enterprise::params::defaults_dir}/pe-puppetdb"

  puppet_enterprise::trapperkeeper::java_args { 'puppetdb' :
    java_args => $java_args,
    require => Package['pe-puppetdb']
  }

  Pe_ini_setting {
    ensure => present,
    path => $puppetdb_initconf,
    key_val_separator => '=',
    section => '',
    require => Package['pe-puppetdb']
  }

  pe_ini_setting { "${container} initconf java_bin":
    setting => 'JAVA_BIN',
    value   => '"/opt/puppetlabs/server/bin/java"',
  }

  pe_ini_setting { "${container} initconf user":
    setting => 'USER',
    value   => 'pe-puppetdb',
  }

  pe_ini_setting { "${container} initconf group":
    setting => 'GROUP',
    value   => 'pe-puppetdb',
  }

  pe_ini_setting { "${container} initconf install_dir":
    setting => 'INSTALL_DIR',
    value   => '"/opt/puppetlabs/server/apps/puppetdb"',
  }

  pe_ini_setting { "${container} initconf config":
    setting => 'CONFIG',
    value   => "\"${confdir}\"",
  }

  pe_ini_setting { "${container} initconf bootstrap_config":
    setting => 'BOOTSTRAP_CONFIG',
    value   => '"/etc/puppetlabs/puppetdb/bootstrap.cfg"',
  }

  pe_ini_setting { "${container} initconf service_stop_retries":
    setting => 'SERVICE_STOP_RETRIES',
    value   => $service_stop_retries,
  }

  pe_ini_setting { "${container} initconf start_timeout":
    setting => 'START_TIMEOUT',
    value   => $start_timeout,
  }
}
