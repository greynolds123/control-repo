# Set up proxy realms
define freeradius::realm (
  $virtual_server = '',
  $auth_pool = '',
  $acct_pool = '',
  $pool = '',
  $nostrip = false,
) {
  $fr_basepath = $::freeradius::params::fr_basepath

  # Validate bools
  unless is_bool($nostrip) {
    fail('nostrip must be true or false')
  }

  # Configure config fragment for this realm
  concat::fragment { "realm-${name}":
    target  => "${fr_basepath}/proxy.conf",
    content => template('freeradius/realm.erb'),
    order   => 30,
  }
}
