class pe_repo::platform::el_4_x86_64(
  $agent_version = $::aio_agent_version,
) {
  pe_repo::deprecation_warning { 'el-4-x86_64':
  }
}
