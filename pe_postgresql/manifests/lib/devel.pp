# This class installs postgresql development libraries. See README.md for more
# details.
class pe_postgresql::lib::devel(
  $package_name   = $pe_postgresql::params::devel_package_name,
  $package_ensure = 'present'
) inherits pe_postgresql::params {

  pe_validate_string($package_name)

  package { 'postgresql-devel':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'postgresql',
  }
}
