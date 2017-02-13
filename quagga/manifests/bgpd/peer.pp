# quagga::bgpd::peer
#
define quagga::bgpd::peer (
  $addr4             = [],
  $addr6             = [],
  $desc              = undef,
  $inbound_routes    = 'none',
  $communities       = [],
  $multihop          = undef,
  $password          = undef,
  $prepend           = undef,
  $default_originate = false,
) {
  validate_array($addr4)
  validate_array($addr6)
  validate_string($desc)
  validate_re($inbound_routes, '^(all|none|default|v6default|v4default)$')
  if $communities { validate_array($communities) }
  if $multihop { validate_integer($multihop) }
  if $password { validate_string($password) }
  if $prepend { validate_integer($prepend) }
  validate_bool($default_originate)
  $my_asn = $::quagga::bgpd::my_asn

  if count($addr4) > 0 or count($addr6) > 0 {
    concat::fragment{"bgpd_peer_${name}":
      target  => $::quagga::bgpd::conf_file,
      content => template('quagga/bgpd.conf.peer.erb'),
      order   => '10',
    }
  }
  if count($addr6) > 0 {
    concat::fragment{"bgpd_v6peer_${name}":
      target  => $::quagga::bgpd::conf_file,
      content => template('quagga/bgpd.conf.v6peer.erb'),
      order   => '40',
    }
  }
  concat::fragment{ "quagga_bgpd_routemap_${name}":
    target  => $::quagga::bgpd::conf_file,
    content => template('quagga/bgpd.conf.routemap.erb'),
    order   => '90',
  }
  if $::quagga::bgpd::manage_nagios {
    if $::quagga::bgpd::enable_advertisements {
      if $::quagga::bgpd::enable_advertisements_v4 and count($addr4) > 0 {
        quagga::bgpd::peer::nagios {$addr4:
          routes => concat($::quagga::bgpd::networks4, $::quagga::bgpd::failsafe_networks4),
        }
      }
      if $::quagga::bgpd::enable_advertisements_v6 and count($addr6) > 0 {
        quagga::bgpd::peer::nagios {$addr6:
          routes => concat($::quagga::bgpd::networks6, $::quagga::bgpd::failsafe_networks6),
        }
      }
    }
  }
}
