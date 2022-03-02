class pe_repo::platform::osx_109_x86_64(
  $agent_version = $::aio_agent_build,
) {
  pe_repo::deprecation_warning { 'osx-10.9-x86_64':
  }
}
