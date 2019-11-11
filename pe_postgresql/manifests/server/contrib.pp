# Install the contrib postgresql packaging. See README.md for more details.
class pe_postgresql::server::contrib (
  $package_name   = $pe_postgresql::params::contrib_package_name,
  $package_ensure = 'present'
) inherits pe_postgresql::params {
  pe_validate_string($package_name)

  package { 'postgresql-contrib':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'postgresql',
  }

  if($package_ensure == 'absent' or $package_ensure == 'purged' or $package_ensure == false) {
    pe_anchor { 'pe_postgresql::server::contrib::start': }->
    Class['pe_postgresql::server::service']->
    Package['postgresql-contrib']->
    Class['pe_postgresql::server::install']->
    pe_anchor { 'pe_postgresql::server::contrib::end': }
  } else {
    pe_anchor { 'pe_postgresql::server::contrib::start': }->
    Class['pe_postgresql::server::install']->
    Package['postgresql-contrib']->
    Class['pe_postgresql::server::service']->
    pe_anchor { 'pe_postgresql::server::contrib::end': }
  }
}
