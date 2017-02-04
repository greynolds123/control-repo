# Class: openldap::server
#
# Deploy and OpenLDAP server
#
class openldap::server (
  String $server_package = undef,
  String $server_service = undef,
  String $conf_d         = undef,
  String $ssl_d          = undef,
  String $user           = undef,
  String $group          = undef,
  $pid                   = undef,
  $ca_cert_source        = undef,
  $ldap_cert_source      = undef,
  $ldap_key_source       = undef,
) {

  package { $server_package:
    ensure => installed,
  }


  service { $server_service:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package[$server_package],
  }

  # The openldap user is created by the slapd package on Debian
  # systems.
  #
  # Resources that require the openldap user account need to require
  # the Package['slapd'] resource.


  # All slapd configuration is managed using ldif which means we
  # don't have the traditional /etc/ldap/slapd.conf.  All configuration
  # data is stored under /etc/ldap/slapd.d.  Configuration data is not
  # managed by Puppet right now; instead we are using a LDAP editor
  # like Apache Directory Studio.
  #
  # Managing slapd configuration via Puppet is possible but may take
  # some work as the LDAP entries can be huge, especially when you
  # consider the LDAP schema entires.
  #
  # You can find more details about slapd's ldif based configuration
  # system in the OpenLDAP 2.4 admin guide:
  #
  #    http://www.openldap.org/doc/admin24/slapdconf2.html
  #
  file { $conf_d:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    recurse => true,
    notify  => Service[$server_service],
    require => Package[$server_package],
  }

  file { $pid: 
   ensure      => present,
    owner      => $user,
    group      => $group,
    mode       => '0644'
  }

  file { $ssl_d:
    ensure => directory,
    owner  => $user,
    group  => '0',
    mode   => '0750',
  }

  # SSL Certs
  #
  # Manage the openldap SSL keys.
  #
  if $ldap_key_source {
    file { "${ssl_d}/openldap.key":
      owner   => $user,
      group   => '0',
      mode    => '0400',
      source  => $ldap_key_source,
      notify  => Service[$server_service],
      require => Package[$server_package],
    }
  }

  if $ldap_cert_source {
    file { "${ssl_d}/openldap.crt":
      owner   => $user,
      group   => '0',
      mode    => '0440',
      source  => $ldap_cert_source,
      notify  => Service[$server_service],
      require => Package[$server_package],
    }
  }

  if $ca_cert_source {
    file { "${ssl_d}/ca.crt":
      owner   => $user,
      group   => '0',
      mode    => '0440',
      source  => $ca_cert_source,
      notify  => Service[$server_service],
      require => Package[$server_package],
    }
  }
}

