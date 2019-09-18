# This class installs the postgresql jdbc connector. See README.md for more
# details.
class pe_postgresql::lib::java (
  $package_name   = $pe_postgresql::params::java_package_name,
  $package_ensure = 'present'
) inherits pe_postgresql::params {

  pe_validate_string($package_name)

  package { 'postgresql-jdbc':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
