# Profile for configuring puppet-server to act as a certificate authority.
#
# Also performs some fileserver configuration to allow additional compile masters
# to get PE modules.
#
# For more information, see the [README.md](./README.md#certificate-authority)
#
# @param client_whitelist [Array] A list of additional certificates to be allowed access
#         to the /certificate_status API endpoint. This list is additive to the base PE
#         certificate list.
class puppet_enterprise::profile::certificate_authority (
  Array[String] $client_whitelist = []
) inherits puppet_enterprise::profile::master {
  include puppet_enterprise::params

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg['certificate-authority-service'] {
    namespace => 'puppetlabs.services.ca.certificate-authority-service',
    service   => 'certificate-authority-service',
    notify  => Service['pe-puppetserver'],
  }

  $_client_whitelist = [$puppet_enterprise::console_host] + $client_whitelist

  Pe_hocon_setting {
    notify  => Service['pe-puppetserver'],
  }

  pe_hocon_setting{ 'certificate-authority.certificate-status':
    ensure  => absent,
    path    => '/etc/puppetlabs/puppetserver/conf.d/ca.conf',
    setting => 'certificate-authority.certificate-status',
  }

  pe_puppet_authorization::rule { 'puppetlabs certificate status':
    ensure               => present,
    match_request_path   => '/puppet-ca/v1/certificate_status',
    match_request_type   => 'path',
    match_request_method => ['get','put','delete'],
    allow                => $_client_whitelist,
    sort_order           => 500,
    path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    notify               => Service['pe-puppetserver'],
  }

  Pe_hocon_setting['certificate-authority.proxy-config.proxy-target-url'] {
    ensure => absent,
  }
  Pe_hocon_setting['certificate-authority.proxy-config.ssl-opts.ssl-cert'] {
    ensure => absent,
  }
  Pe_hocon_setting['certificate-authority.proxy-config.ssl-opts.ssl-key'] {
    ensure => absent,
  }
  Pe_hocon_setting['certificate-authority.proxy-config.ssl-opts.ssl-ca-cert'] {
    ensure => absent,
  }
  # Remove external CA to prevent conflict
  pe_hocon_setting {'certificate-authority.proxy-config':
    path    => '/etc/puppetlabs/puppetserver/conf.d/ca.conf',
    setting => 'certificate-authority.proxy-config',
    ensure  => absent,
  }

  # FILESERVER
  # The certificate authority in a standard PE deployment is also the
  # master-of-masters responsible for deploying new systems. Besides native OS
  # packages, PE has its own "packaged" components that may need to be deployed
  # on new systems. We will serve these using Puppet's built-in fileserver.
  puppet_enterprise::fileserver_conf { "${puppet_enterprise::module_mountpoint}":
    mountpoint => $puppet_enterprise::module_mountpoint,
    path       => $puppet_enterprise::module_tarballsrc,
  } -> Pe_anchor['puppet_enterprise:barrier:ca']
}
