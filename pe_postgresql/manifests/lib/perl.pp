# This class installs the perl libs for postgresql. See README.md for more
# details.
class pe_postgresql::lib::perl(
  $package_name   = $pe_postgresql::params::perl_package_name,
  $package_ensure = 'present'
) inherits pe_postgresql::params {

  package { 'perl-DBD-Pg':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
