# == Class: docker::repos
#
#
class docker::repos {

  ensure_packages($docker::prerequired_packages)

  case $::osfamily {
    'Debian': {
<<<<<<< HEAD
<<<<<<< HEAD
      include apt
      if $::operatingsystem == 'Debian' and $::lsbdistcodename == 'wheezy' {
        include apt::backports
      }
      if ($docker::docker_cs) {
        $location = $docker::package_cs_source_location
        $key_source = $docker::package_cs_key_source
        $package_key = $docker::package_cs_key
      } else {
        $location = $docker::package_source_location
        $key_source = $docker::package_key_source
        $package_key = $docker::package_key
      }
      Exec['apt_update'] -> Package[$docker::prerequired_packages]
      if ($docker::use_upstream_package_source) {
=======
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
      if ($docker::use_upstream_package_source) {
        if ($docker::docker_cs) {
          $location = $docker::package_cs_source_location
          $key_source = $docker::package_cs_key_source
          $package_key = $docker::package_cs_key
        } else {
          $location = $docker::package_source_location
          $key_source = $docker::package_key_source
          $package_key = $docker::package_key
        }
<<<<<<< HEAD
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
        apt::source { 'docker':
          location          => $location,
          release           => $docker::package_release,
          repos             => $docker::package_repos,
          key               => $package_key,
          key_source        => $key_source,
          required_packages => 'debian-keyring debian-archive-keyring',
          pin               => '10',
          include_src       => false,
        }
        if $docker::manage_package {
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
          include apt
          if $::operatingsystem == 'Debian' and $::lsbdistcodename == 'wheezy' {
            include apt::backports
          }
          Exec['apt_update'] -> Package[$docker::prerequired_packages]
<<<<<<< HEAD
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
          Apt::Source['docker'] -> Package['docker']
        }
      }

    }
    'RedHat': {
      if $docker::manage_package {
        if ($docker::docker_cs) {
          $baseurl = $docker::package_cs_source_location
          $gpgkey = $docker::package_cs_key_source
        } else {
          $baseurl = $docker::package_source_location
          $gpgkey = $docker::package_key_source
        }
        if ($docker::use_upstream_package_source) {
          yumrepo { 'docker':
            descr    => 'Docker',
            baseurl  => $baseurl,
            gpgkey   => $gpgkey,
            gpgcheck => true,
          }
          Yumrepo['docker'] -> Package['docker']
        }
        if ($::operatingsystem != 'Amazon') and ($::operatingsystem != 'Fedora') {
          if ($docker::manage_epel == true) {
            include 'epel'
            Class['epel'] -> Package['docker']
          }
        }
      }
    }
<<<<<<< HEAD
<<<<<<< HEAD
=======
    default: {}
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
    default: {}
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  }
}
