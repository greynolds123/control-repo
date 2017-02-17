# This class is for configuring a node to be a PuppetDB node for an environment.
#
# For more information, see the [README.md](./README.md)
#
# @param database_host [String] The host which the database server is running on
# @param master_certname [String] The master certificate name
# @param whitelisted_certnames [Array] An array of certificates allowed to communicate directly with
#        PuppetDB. This list is added to the base PE certificate list.
# @param certname [String] The certname of the host that PuppetDB is running on
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
# @param localcacert [String] The path to the local CA certificate. This will be used instead of the
#        CA that is in Puppet's ssl dir.
# @param database_properties [String] A url encoded string of JDBC options.  This will replace the
#        default database property string which enables SSL connections.
# @param java_args [Hash] A hash containing Java options that puppetdb will run with. This will
#        replace any arguments that are used by default.
# @param auto_configure_sync This setting is deprecated1
# @param sync_peers [Optional[Array[Puppet_enterprise::Puppetdb::Sync_peer]]] The hosts from which
#        this puppetdb should pull data, along with the interval at which the sync should be run.
# @param sync_whitelist [Array[String]] Certnames which are allowed to sync from this puppetdb.
# @param rbac_host [String] The hostname of the RBAC node.
# @param rbac_port [String] The port of the RBAC service.
# @param rbac_prefix [String] The URL prefix of the RBAC service.
class puppet_enterprise::profile::puppetdb(
  $database_host       = $puppet_enterprise::database_host,
  $master_certname     = $puppet_enterprise::puppet_master_host,
  $whitelisted_certnames = [],
  $certname            = $::clientcert,
  $confdir             = $puppet_enterprise::params::puppetdb_confdir,
  $database_name       = $puppet_enterprise::puppetdb_database_name,
  $database_password   = $puppet_enterprise::puppetdb_database_password,
  $database_port       = $puppet_enterprise::database_port,
  $database_user       = $puppet_enterprise::puppetdb_database_user,
  $gc_interval         = $puppet_enterprise::params::puppetdb_gc_interval,
  $node_purge_ttl      = $puppet_enterprise::params::puppetdb_node_purge_ttl,
  $node_ttl            = $puppet_enterprise::params::puppetdb_node_ttl,
  $report_ttl          = $puppet_enterprise::params::puppetdb_report_ttl,
  $listen_address      = $puppet_enterprise::params::plaintext_address,
  $listen_port         = $puppet_enterprise::params::puppetdb_listen_port,
  $ssl_listen_address  = $puppet_enterprise::params::ssl_address,
  $ssl_listen_port     = $puppet_enterprise::puppetdb_port,
  $localcacert         = $puppet_enterprise::params::localcacert,
  $database_properties = $puppet_enterprise::database_properties,
  $java_args           = $puppet_enterprise::params::puppetdb_java_args,
  $auto_configure_sync = undef, # deprecated
  $sync_peers          = undef,
  $sync_whitelist      = [],
  $rbac_host           = $puppet_enterprise::console_host,
  $rbac_port           = $puppet_enterprise::api_port,
  $rbac_prefix         = $puppet_enterprise::rbac_url_prefix,
) inherits puppet_enterprise {
  $cert_whitelist_path = '/etc/puppetlabs/puppetdb/certificate-whitelist'

  if !pe_empty($java_args) {
    pe_validate_hash($java_args)
  }

  if ($auto_configure_sync != undef) {
    warning("The \$auto_configure_sync parameter is deprecated and will be ignored. \
Please explicitly configure PuppetDB sync using the \$sync_peers and \
\$sync_whitelist parameters.")
  }

  $puppetdb_ssl_dir = $puppet_enterprise::params::puppetdb_ssl_dir
  if $puppet_enterprise::database_ssl and $puppet_enterprise::database_cert_auth {
    $puppetdb_jdbc_ssl_properties = pe_join(
      [$database_properties,
       "&sslkey=${puppetdb_ssl_dir}/${certname}.private_key.pk8",
       "&sslcert=${puppetdb_ssl_dir}/${certname}.cert.pem"])
  } else {
    $puppetdb_jdbc_ssl_properties = $database_properties
  }

  if $rbac_host {
    $rbac_url = "https://${rbac_host}:${rbac_port}${rbac_prefix}"
  } else {
    $rbac_url = undef
  }

  class { 'puppet_enterprise::puppetdb':
    certname            => $certname,
    cert_whitelist_path => $cert_whitelist_path,
    confdir             => $confdir,
    database_name       => $database_name,
    database_port       => $database_port,
    database_host       => $database_host,
    database_user       => $database_user,
    database_password   => $database_password,
    gc_interval         => $gc_interval,
    node_purge_ttl      => $node_purge_ttl,
    node_ttl            => $node_ttl,
    report_ttl          => $report_ttl,
    listen_address      => $listen_address,
    listen_port         => $listen_port,
    ssl_listen_address  => $ssl_listen_address,
    ssl_listen_port     => $ssl_listen_port,
    localcacert         => $localcacert,
    database_properties => $puppetdb_jdbc_ssl_properties,
    java_args           => $java_args,
    rbac_url            => $rbac_url,
    sync_peers          => $sync_peers,
  }

  file { $puppetdb_ssl_dir :
    ensure  => directory,
    mode    => '0600',
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    before  => Puppet_enterprise::Certs['pe-puppetdb'],
    require => Package['pe-puppetdb']
  }

  puppet_enterprise::certs { 'pe-puppetdb' :
    certname => $certname,
    owner    => 'pe-puppetdb',
    group    => 'pe-puppetdb',
    cert_dir => $puppetdb_ssl_dir,
    notify   => Service['pe-puppetdb'],
  }

  file { $cert_whitelist_path:
    ensure  => file,
    group   => 'pe-puppetdb',
    owner   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb']
  }

  puppet_enterprise::certs::pk8_cert { "${puppetdb_ssl_dir}/${certname}.private_key.pk8":
    pem_file  => "${puppetdb_ssl_dir}/${certname}.private_key.pem",
    owner     => 'pe-puppetdb',
    group     => 'pe-puppetdb',
    mode      => '0400',
    require   => Puppet_enterprise::Certs['pe-puppetdb'],
    notify    => Service['pe-puppetdb'],
  }

  $certs = pe_union($whitelisted_certnames,
                    pe_union($sync_whitelist,
                             [$puppet_enterprise::console_host,
                              $puppet_enterprise::puppet_master_host, # for the orchestrator
                              $master_certname,
                              $certname ]))

  class { 'puppet_enterprise::certs::puppetdb_whitelist':
    cert_whitelist_path => $cert_whitelist_path,
    certnames           => $certs,
    notify              => Service['pe-puppetdb'],
  }
}
