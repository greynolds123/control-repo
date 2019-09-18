# This class installs the python libs for postgresql. See README.md for more
# details.
class pe_postgresql::lib::python(
  $package_name   = $pe_postgresql::params::python_package_name,
  $package_ensure = 'present'
) inherits pe_postgresql::params {

  package { 'python-psycopg2':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
