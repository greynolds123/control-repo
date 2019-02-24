# == Class: cobbler
#
# Class manages cobbler installation and configuraiton
#
# === Parameters
#
# [*cobbler_config*]
#   Hash of cobbler settings options. This hash is merged with the
#   default_cobbler_config hash from params class. All this options go to the
#   file defined with config_file parameter. There are no checks (yet?) done to
#   verify options passed with that hash
#
#   Type: Hash
#   Default: {}
#
# [*cobbler_modules_config*]
#   Hash of cobbler modules configuration. This hash is
#   merged with the default_modules_config hash from params class.
#   Exapmple:
#     cobbler_modules_config => {
#       section1            => {
#         option1 => value1,
#         option2 => [ value1, value2],
#       },
#       section2.subsection => {
#         option3 => value3,
#       }
#     }
#
#   Type: Hash
#   Default: {}
#
# [*ensure*]
#   The state of puppet resources within the module.
#
#   Type: String
#   Values: 'present', 'absent'
#   Default: 'present'
#
# [*package*]
#   The package name or array of packages that provides cobbler.
#
#   Type: String or Array
#   Default: check cobbler::params::package
#
# [*package_ensure*]
#   The state of the package.
#
#   Type: String
#   Values: present, installed, absent, purged, held, latest
#   Default: installed
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
# [*config_path*]
#   The absolute path where cobbler configuration files reside. This to prepend
#   to config_file and config_modules options to build full paths to setttings
#   and modules.conf files.
#
#   Type: String
#   Default: /etc/cobbler
#
# [*config_file*]
#   The title of main cobbler configuration file. The full path to that file is
#   build by prepending config_file with config_path parameters
#
#   Type: String
#   Default: settings
#
# [*config_modules*]
#   The title of cobbler modules configuration file. The full path to that file
#   is build by prepending config_modules with config_path parameters
#
#   Type: String
#   Default: modules.conf
#
# [*default_cobbler_config*]
#   Hash that contains default configuration options for cobbler. No checks are
#   performed to validate these configuration options. This is a left side hash
#   to be merged with cobbler_config hash to build config_file for cobbler
#
#   Type: Hash
#   Default: check cobbler::params::default_cobbler_config
#
# [*default_modules_config*]
#   Hash that contains default configuration options for cobbler modules.
#   This is a left side hash  to be merged with cobbler_modules_config hash to
#   build config_modules file  for cobbler
#
#   Type: Hash
#   Default: check cobbler::params::default_modules_config
#
# === Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
class cobbler (
  $cobbler_config         = {},
  $cobbler_modules_config = {},
  $ensure                 = $::cobbler::params::ensure,
  $package                = $::cobbler::params::package,
  $package_ensure         = $::cobbler::params::package_ensure,
  $service                = $::cobbler::params::service,
  $service_ensure         = $::cobbler::params::service_ensure,
  $service_enable         = $::cobbler::params::service_enable,
  $config_path            = $::cobbler::params::config_path,
  $config_file            = $::cobbler::params::config_file,
  $config_modules         = $::cobbler::params::config_modules,
  $default_cobbler_config = $::cobbler::params::default_cobbler_config,
  $default_modules_config = $::cobbler::params::default_modules_config,
) inherits ::cobbler::params {

  # Validation
  validate_re($ensure, ['^present$','^absent$'])
  validate_re($service_ensure,['^stopped$', '^running$'])
  validate_re($package_ensure,[
    '^present$',
    '^installed$',
    '^absent$',
    '^purged$',
    '^held$',
    '^latest$',
  ])
  validate_string(
    $service,
    $config_file,
    $config_modules
  )
  validate_absolute_path(
    $config_path,
  )
  validate_hash(
    $default_cobbler_config,
    $cobbler_config,
    $cobbler_modules_config,
  )

  if is_string($service_enable) {
    validate_re($service_enable, [
      '^manual$',
      '^mask$'
    ])
  } else {
    validate_bool($service_enable)
  }

  if is_array($package) {
    validate_array($package)
  } else {
    validate_string($package)
  }

  anchor{'cobbler::begin':}
  anchor{'cobbler::end':}

  class{'cobbler::install':
    package        => $package,
    package_ensure => $package_ensure,
  }

  # Merging default cobbler config and cobbler config and pass to
  # cobbler::config class
  $_cobbler_config         = merge(
    $default_cobbler_config,
    $cobbler_config
  )
  $_cobbler_modules_config = merge(
    $default_modules_config,
    $cobbler_modules_config
  )

  class{'cobbler::config':
    ensure                 => $ensure,
    cobbler_config         => $_cobbler_config,
    cobbler_modules_config => $_cobbler_modules_config,
    config_path            => $config_path,
    config_file            => $config_file,
    config_modules         => $config_modules,
  }

  class{'cobbler::service':
    service        => $service,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }

  Anchor['cobbler::begin'] ->
  Class['cobbler::install'] ->
  Class['cobbler::config'] ~>
  Class['cobbler::service'] ->
  Anchor['cobbler::end']
}
