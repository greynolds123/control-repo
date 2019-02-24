# == Class cacti::install
#
# This class is called from cacti for install.
#
class cacti::install inherits cacti{

  package { $::cacti::cacti_package:
    ensure => present,
  }
}
