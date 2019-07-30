# This class is for setting up the PuppetDB rbac_consumer.conf configuration
# file
#
# @param certname [String] Name of a certificate Postgres will use for
#        encrypting network traffic
# @param confdir [String] The path to PuppetDB's confdir
# @param localcacert [String] The path to the local CA certificate
# @param rbac_host [String] The URL of the RBAC service.
class puppet_enterprise::puppetdb::rbac_consumer_conf(
  String $certname,
  String $confdir,
  String $localcacert,
  Optional[String] $rbac_url = undef,
  String $ssl_dir = $puppet_enterprise::params::puppetdb_ssl_dir,
) inherits puppet_enterprise::params {
  include puppet_enterprise::packages

  $rbac_consumer_conf = "${confdir}/rbac_consumer.conf"

  file { $rbac_consumer_conf :
    ensure  => present,
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb'],
  }

  #Set the defaults
  Pe_hocon_setting {
    path    => $rbac_consumer_conf,
    ensure  => present,
    require => File[$rbac_consumer_conf],
  }

  pe_hocon_setting {'puppetdb_rbac_consumer_ssl_key':
    setting => 'global.certs.ssl-key',
    value   => "${ssl_dir}/${certname}.private_key.pem",
  }

  pe_hocon_setting {'puppetdb_rbac_consumer_ssl_cert':
    setting => 'global.certs.ssl-cert',
    value   => "${ssl_dir}/${certname}.cert.pem",
  }

  pe_hocon_setting {'puppetdb_rbac_consumer_ssl_ca_cert':
    setting => 'global.certs.ssl-ca-cert',
    value   => $localcacert,
  }

  if $rbac_url {
    pe_hocon_setting {'puppetdb_rbac_consumer_api_url':
      setting => 'rbac-consumer.api-url',
      value   => $rbac_url,
    }
  }

}
