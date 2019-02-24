# == Class cacti::service
#
# This class is meant to be called from cacti.
# It ensure the required services are running.
#
class cacti::service inherits ::cacti{

  if $::cacti::managed_services != [] {
    service { $::cacti::managed_services:
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
