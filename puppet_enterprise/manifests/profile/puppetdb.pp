# This class is for configuring a node to be a PuppetDB node for an environment.
#
# For more information, see the [README.md](./README.md)
#
# @param database_host The host which the database server is running on
# @param master_certname The master certificate name
# @param whitelisted_certnames An array of certificates allowed to communicate directly with
#        PuppetDB. This list is added to the base PE certificate list.
# @param certname The certname of the host that PuppetDB is running on
# @param confdir The path to PuppetDB's confdir
# @param database_name The name of the PuppetDB Database
# @param database_password The password of the user
# @param database_port The port that the database is running on
# @param database_user The user logging into the database
# @param gc_interval The interval, in minutes, at which garbage collection should occur
# @param node_purge_ttl The amount of time that must elapse before a deactivated node is
#        purged from PuppetDB
# @param node_ttl The amount of time that must elapse before a node is deactivated from
#        PuppetDB
# @param report_ttl The amount of time that must elapse before a report is deleted
# @param listen_address The address which the database is listening on for plain text
#        connections
# @param listen_port The port which PuppetDB Listens on for plain text connections
# @param ssl_listen_address The address which the database is listening on for SSL
#        connections
# @param ssl_listen_port The port which PuppetDB Listens on for SSL connections
# @param localcacert The path to the local CA certificate. This will be used instead of the
#        CA that is in Puppet's ssl dir.
# @param database_properties A url encoded string of JDBC options.  This will replace the
#        default database property string which enables SSL connections.
# @param java_args A hash containing Java options that puppetdb will run with. This will
#        replace any arguments that are used by default.
# @param auto_configure_sync This setting is deprecated1
# @param sync_peers The hosts from which
#        this puppetdb should pull data, along with the interval at which the sync should be run.
# @param sync_whitelist Certnames which are allowed to sync from this puppetdb.
# @param rbac_host The hostname of the RBAC node.
# @param rbac_port The port of the RBAC service.
# @param rbac_prefix The URL prefix of the RBAC service.
class puppet_enterprise::profile::puppetdb(
  String                          $database_host          = $puppet_enterprise::puppetdb_database_host,
  String                          $master_certname        = $puppet_enterprise::puppet_master_host,
  Array[String]                   $whitelisted_certnames  = [],
  String                          $certname               = $facts['clientcert'],
  Puppet_enterprise::Unixpath     $confdir                = $puppet_enterprise::params::puppetdb_confdir,
  String                          $database_name          = $puppet_enterprise::puppetdb_database_name,
  Optional[String]                $database_password      = $puppet_enterprise::puppetdb_database_password,
  Puppet_enterprise::Port         $database_port          = $puppet_enterprise::database_port,
  String                          $database_user          = $puppet_enterprise::puppetdb_database_user,
  Variant[Pattern[/^[0-9]+$/],Integer] $gc_interval       = $puppet_enterprise::params::puppetdb_gc_interval,
  Optional[String]                $node_purge_ttl         = undef,
  Puppet_enterprise::Puppetdb_ttl $node_ttl               = $puppet_enterprise::params::puppetdb_node_ttl,
  Puppet_enterprise::Puppetdb_ttl $report_ttl             = $puppet_enterprise::params::puppetdb_report_ttl,
  Puppet_enterprise::Ip           $listen_address         = $puppet_enterprise::params::plaintext_address,
  Puppet_enterprise::Port         $listen_port            = $puppet_enterprise::params::puppetdb_listen_port,
  Puppet_enterprise::Ip           $ssl_listen_address     = $puppet_enterprise::params::ssl_address,
  Puppet_enterprise::Port         $ssl_listen_port        = $puppet_enterprise::puppetdb_port,
  Puppet_enterprise::Unixpath     $localcacert            = $puppet_enterprise::params::localcacert,
  String                          $database_properties    = $puppet_enterprise::database_properties,
  Hash                            $java_args              = $puppet_enterprise::params::puppetdb_java_args,
  $auto_configure_sync = undef, # deprecated
  Optional[
    Array[
      Struct[{
        host => String,
        port => Integer,
        sync_interval_minutes => Integer}]]] $sync_peers  = undef,
  Array[String]                   $sync_whitelist         = [],
  String                          $rbac_host              = $puppet_enterprise::console_host,
  String                          $rbac_port              = $puppet_enterprise::api_port,
  String                          $rbac_prefix            = $puppet_enterprise::rbac_url_prefix,
) inherits puppet_enterprise {
  $cert_whitelist_path = '/etc/puppetlabs/puppetdb/certificate-whitelist'

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

  puppet_enterprise::certs { 'pe-puppetdb' :
    certname => $certname,
    container => 'puppetdb',
    cert_dir => $puppetdb_ssl_dir,
    make_pk8_cert => true,
  }

  file { $cert_whitelist_path:
    ensure  => file,
    group   => 'pe-puppetdb',
    owner   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb']
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
