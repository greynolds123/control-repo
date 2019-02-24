# == Define cobbler::object
#
# Defines different cobbler's objects
define cobbler::object (
  $type = $name,
  $def  = {},
){
  include cobbler::params

  if $type == undef {
    fail('Object type must be defined')
  }

  validate_hash($def)
  validate_string($type)

  case $type {
    'distros': {
      create_resources(
        'cobbler::distro',
        $def,
        $params::default_disto_params
      )
    }
    'repos': {
      create_resources(
        'cobbler::repo',
        $def,
        $params::default_repo_params
      )
    }
    'profiles': {
      create_resources(
        'cobbler::profile',
        $def,
        $params::default_profile_params
      )
    }
    'systems': {
      create_resources(
        'cobbler::system',
        $def,
        $params::default_system_params
      )
    }
    default: { fail("Object type '${type}' not supported!") }
  }
}
