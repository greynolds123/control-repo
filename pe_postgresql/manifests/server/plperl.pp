# This class installs the PL/Perl procedural language for postgresql. See
# README.md for more details.
class pe_postgresql::server::plperl(
  $package_ensure = 'present',
  $package_name   = $pe_postgresql::server::plperl_package_name
) {
  package { 'postgresql-plperl':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'postgresql',
  }

  if($package_ensure == 'present' or $package_ensure == true) {
    pe_anchor { 'pe_postgresql::server::plperl::start': }->
    Class['pe_postgresql::server::install']->
    Package['postgresql-plperl']->
    Class['pe_postgresql::server::service']->
    pe_anchor { 'pe_postgresql::server::plperl::end': }
  } else {
    pe_anchor { 'pe_postgresql::server::plperl::start': }->
    Class['pe_postgresql::server::service']->
    Package['postgresql-plperl']->
    Class['pe_postgresql::server::install']->
    pe_anchor { 'pe_postgresql::server::plperl::end': }
  }

}
