class cobbler::objects (
  $distros  = {},
  $repos    = {},
  $profiles = {},
  $systems  = {}
) {
  include cobbler::params

  validate_hash($distros)
  validate_hash($repos)
  validate_hash($profiles)
  validate_hash($systems)

  create_resources(
    'cobbler::distro',
    $distros,
    $::cobbler::params::default_disto_params
  )
  create_resources(
    'cobbler::repo',
    $repos,
    $::cobbler::params::default_repo_params
  )
  create_resources(
    'cobbler::profile',
    $profiles,
    $::cobbler::params::default_profile_params
  )
  create_resources(
    'cobbler::system',
    $systems,
    $::cobbler::params::default_system_params
  )
}
