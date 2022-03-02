# Install the postgis postgresql packaging. See README.md for more details.
class pe_postgresql::server::postgis (
  $package_name   = $pe_postgresql::params::postgis_package_name,
  $package_ensure = 'present'
) inherits pe_postgresql::params {
  pe_validate_string($package_name)

  package { 'postgresql-postgis':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'postgresql',
  }

  if($package_ensure == 'present' or $package_ensure == true) {
    pe_anchor { 'pe_postgresql::server::postgis::start': }->
    Class['pe_postgresql::server::install']->
    Package['postgresql-postgis']->
    Class['pe_postgresql::server::service']->
    pe_anchor { 'pe_postgresql::server::postgis::end': }

    if $pe_postgresql::globals::manage_package_repo {
      Class['pe_postgresql::repo'] ->
      Package['postgresql-postgis']
    }
  } else {
    pe_anchor { 'pe_postgresql::server::postgis::start': }->
    Class['pe_postgresql::server::service']->
    Package['postgresql-postgis']->
    Class['pe_postgresql::server::install']->
    pe_anchor { 'pe_postgresql::server::postgis::end': }
  }
}
