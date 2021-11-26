class pe_repo::platform::fedora_26_x86_64(
  $agent_version = $::aio_agent_build,
){
  pe_repo::deprecation_warning { 'fedora-26-x86_64':
  }
}
