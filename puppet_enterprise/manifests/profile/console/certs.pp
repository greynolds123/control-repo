# Profile for configuring dashboard ssl certs.
#
#
# @param certname [String] The certname the console will use to encrypt network traffic.
# @param localcacert [String] The path to the local CA certificate. This will be used instead of the
#        CA that is in Puppet's ssl dir.
# @param hostcrl [String] Path to certificate revocation list file.
class puppet_enterprise::profile::console::certs(
  $certname    = $::clientcert,
  $localcacert = $puppet_enterprise::params::localcacert,
  $hostcrl     = $puppet_enterprise::params::hostcrl,
) inherits puppet_enterprise::params {
  $console_server_certname = $certname
  $console_services_ssl_dir = $puppet_enterprise::console_services_ssl_dir

  file { $console_services_ssl_dir :
    ensure => directory,
    mode   => '0600',
    owner  => 'pe-console-services',
    group  => 'pe-console-services',
    before => Puppet_enterprise::Certs[ 'pe-console-services::server_cert' ],
  }
  puppet_enterprise::certs { 'pe-console-services::server_cert' :
    certname  => $console_server_certname,
    owner     => 'pe-console-services',
    group     => 'pe-console-services',
    cert_dir  => $console_services_ssl_dir,
    append_ca => false,
    before    => File[ '/etc/puppetlabs/console-services/conf.d/webserver.conf' ],
    notify    => Service['pe-console-services'],
  }

  $cert_basename = "${console_services_ssl_dir}/${console_server_certname}"
  $client_pk8_key  = "${cert_basename}.private_key.pk8"
  $client_pem_key  = "${cert_basename}.private_key.pem"
  $client_cert     = "${cert_basename}.cert.pem"

  puppet_enterprise::certs::pk8_cert { $client_pk8_key:
    pem_file => $client_pem_key,
    owner    => 'pe-console-services',
    group    => 'pe-console-services',
    mode     => '0400',
    notify   => Service['pe-console-services'],
    require  => File[$console_services_ssl_dir],
  }

}
