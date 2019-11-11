# Install FreeRADIUS clients (WISMs or testing servers)
define freeradius::client (
  $shortname,
  $secret,
  $ip             = undef,
  $ip6            = undef,
  $virtual_server = undef,
  $nastype        = undef,
  $redirect       = undef,
  $port           = undef,
  $srcip          = undef,
  $firewall       = false,
  $ensure         = present,
) {
  $fr_package  = $::freeradius::params::fr_package
  $fr_service  = $::freeradius::params::fr_service
  $fr_basepath = $::freeradius::params::fr_basepath
  $fr_group    = $::freeradius::params::fr_group

  file { "${fr_basepath}/clients.d/${shortname}.conf":
    ensure  => $ensure,
    mode    => '0640',
    owner   => 'root',
    group   => $fr_group,
    content => template('freeradius/client.conf.erb'),
    require => [File["${fr_basepath}/clients.d"], Group[$fr_group]],
    notify  => Service[$fr_service],
  }

  if ($firewall and $ensure == 'present') {
    if $port {
      if $ip {
        firewall { "100-${shortname}-${port}-v4":
          proto  => 'udp',
          dport  => $port,
          action => 'accept',
          source => $ip,
        }
      } elsif $ip6 {
        firewall { "100-${shortname}-${port}-v6":
          proto    => 'udp',
          dport    => $port,
          action   => 'accept',
          provider => 'ip6tables',
          source   => $ip6,
        }
      }
    } else {
      fail('Must specify $port if you specify $firewall')
    }
  }
}
