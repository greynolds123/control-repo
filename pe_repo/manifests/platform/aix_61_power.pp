class pe_repo::platform::aix_61_power(
  $agent_version = $::aio_agent_version,
){
  include pe_repo

  # All supported versions of AIX use the aix 6.1 agent package
  unless defined(Pe_repo::Aix['aix-6.1-power']){
    pe_repo::aix { 'aix-6.1-power':
      agent_version => $agent_version,
      pe_version    => $pe_repo::default_pe_build,
    }
  }
  warning 'AIX classes for a specific version are deprecated: please update configuration to classify all versions of AIX to use the aix_power class'
}
