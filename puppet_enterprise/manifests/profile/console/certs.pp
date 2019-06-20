# Profile for configuring dashboard ssl certs.
#
#
# @param certname [String] The certname the console will use to encrypt network traffic.
# @param localcacert [String] The path to the local CA certificate. This will be used instead of the
#        CA that is in Puppet's ssl dir.
# @param hostcrl [String] Path to certificate revocation list file.
class puppet_enterprise::profile::console::certs(
  $certname    = $facts['clientcert'],
  $localcacert = $puppet_enterprise::params::localcacert,
  $hostcrl     = $puppet_enterprise::params::hostcrl,
) inherits puppet_enterprise::params {
  $console_server_certname = $certname
  $console_services_ssl_dir = $puppet_enterprise::console_services_ssl_dir

  puppet_enterprise::certs { 'pe-console-services::server_cert' :
    certname  => $console_server_certname,
    container => 'console-services',
    cert_dir  => $console_services_ssl_dir,
    append_ca => false,
    before    => File[ '/etc/puppetlabs/console-services/conf.d/webserver.conf' ],
    make_pk8_cert => true,
  }

}
