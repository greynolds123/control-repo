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
  Array[String] $client_whitelist                       = [],
) inherits puppet_enterprise::profile::master {
  include puppet_enterprise::params
  include puppet_enterprise::master::recover_configuration

  $confdir_ssl = $puppet_enterprise::params::ssl_dir
  $confdir_ca = "${confdir_ssl}/ca"

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg['certificate-authority-service'] {
    namespace => 'puppetlabs.services.ca.certificate-authority-service',
    service   => 'certificate-authority-service',
    notify  => Service['pe-puppetserver'],
  }

  $_client_whitelist = [$puppet_enterprise::console_host,
                        $puppet_enterprise::puppet_master_host] + $client_whitelist
  $ca_cli_extension = { 'extensions' => { ':pp_cli_auth' => 'true' } }

  Pe_hocon_setting {
    notify  => Service['pe-puppetserver'],
  }

  pe_hocon_setting { 'certificate-authority.certificate-status':
    ensure  => absent,
    path    => '/etc/puppetlabs/puppetserver/conf.d/ca.conf',
    setting => 'certificate-authority.certificate-status',
  }

  pe_hocon_setting{ 'certificate-authority.allow-subject-alt-names':
    ensure  => present,
    path    => '/etc/puppetlabs/puppetserver/conf.d/ca.conf',
    setting => 'certificate-authority.allow-subject-alt-names',
    value   => true,
  }

  pe_hocon_setting { 'certificate-authority.enable-infra-crl':
    ensure  => present,
    path    => '/etc/puppetlabs/puppetserver/conf.d/ca.conf',
    setting => 'certificate-authority.enable-infra-crl',
    value   => true,
  }

  if $settings::storeconfigs {
    $_masters = puppet_enterprise::get_masters()
  } else {
    $_masters = [$puppet_enterprise::puppet_master_host]
  }

  file { $confdir_ca:
    ensure  => directory,
    owner => 'pe-puppet',
    group => 'pe-puppet',
    require => Package['pe-puppetserver']
  }

  file { "${confdir_ca}/infra_inventory.txt":
    ensure  => $ca_setting_ensure,  # lint:ignore:variable_scope
    owner => 'pe-puppet',
    group => 'pe-puppet',
    mode => '0644',
    require => Package['pe-puppetserver'],
    content => $_masters.join("\n")
  }

  exec { 'generate auxiliary infra CRL files':
    command => '/opt/puppetlabs/bin/puppetserver ca enable --infracrl',
    creates => "${confdir_ca}/infra_crl.pem",
    require => File["${confdir_ca}/infra_inventory.txt"],
  }

  pe_puppet_authorization::rule { 'puppetlabs certificate status':
    ensure               => present,
    match_request_path   => '/puppet-ca/v1/certificate_status/',
    match_request_type   => 'path',
    match_request_method => ['get','put','delete'],
    allow                => $_client_whitelist << $ca_cli_extension,
    sort_order           => 500,
    path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    notify               => Service['pe-puppetserver'],
  }

  pe_puppet_authorization::rule { 'puppetlabs certificate statuses':
    ensure               => present,
    match_request_path   => '/puppet-ca/v1/certificate_statuses/',
    match_request_type   => 'path',
    match_request_method => 'get',
    allow                => $_client_whitelist << $ca_cli_extension,
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
    ensure  => absent,
    path    => '/etc/puppetlabs/puppetserver/conf.d/ca.conf',
    setting => 'certificate-authority.proxy-config',
  }

  # FILESERVER
  # This mountpoint has been unused since 2016.4.5; ensure that it is removed.
  # This can be dropped once we are no longer upgrading from versions < 2016.4.5.
  puppet_enterprise::fileserver_conf { $puppet_enterprise::module_mountpoint:
    ensure     => absent,
    mountpoint => $puppet_enterprise::module_mountpoint,
    path       => '',
  } -> Pe_anchor['puppet_enterprise:barrier:ca']
}
