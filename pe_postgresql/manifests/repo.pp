# PRIVATE CLASS: do not use directly
class pe_postgresql::repo (
  $ensure  = $pe_postgresql::params::ensure,
  $version = undef
) inherits pe_postgresql::params {
  case $::osfamily {
    'RedHat', 'Linux': {
      if $version == undef {
        fail("The parameter 'version' for 'pe_postgresql::repo' is undefined. You must always define it when osfamily == Redhat or Linux")
      }
      class { 'pe_postgresql::repo::yum_postgresql_org': }
    }

    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily RedHat and Debian")
    }
  }
}
