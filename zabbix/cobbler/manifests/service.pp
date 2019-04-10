# == Class cobbler:service
#
# Manages cobbler service
#
# === Parameters
#
# [*service*]
#   Name of the service this modules is responsible to manage.
#
#   Type: String
#   Default: cobblerd
#
# [*service_ensure*]
#   The state of the serivce in the system
#
#   Type: String
#   Values: stopped, running
#   Default: running
#
# [*service_enable*]
#   Whether a service should be enabled to start at boot
#
#   Type: boolean or string
#   Values: true, false, manual, mask
#   Default: true
#
# == Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
class cobbler::service (
  $service,
  $service_ensure,
  $service_enable,
){
  # Validation
  validate_string(
    $service,
  )
  validate_re($service_ensure,['^stopped$', '^running$'])

  if is_string($service_enable) {
    validate_re($service_enable, [
      '^manual$',
      '^mask$'
    ])
  } else {
    validate_bool($service_enable)
  }
  service {$service:
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
