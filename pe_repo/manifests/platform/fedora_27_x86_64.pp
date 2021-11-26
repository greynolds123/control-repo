class pe_repo::platform::fedora_27_x86_64(
  $agent_version = $::aio_agent_build,
){
  pe_repo::deprecation_warning { 'fedora-27-x86_64':
  }
}
