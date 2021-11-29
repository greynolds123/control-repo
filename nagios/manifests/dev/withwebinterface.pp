class nagios::dev::withwebinterface inherits nagios::dev {
  case $::osfamily {
    'Debian': {
      $group = 'www-data'
    }
    'RedHat': {
      $group = 'apache'
    }
    default: {
      fail "Unsupported osfamily: ${::osfamily}"
    }
  }
  File['nagios read-write dir'] {
    group => $group,
  }
}
