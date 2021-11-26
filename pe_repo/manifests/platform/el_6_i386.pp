class pe_repo::platform::el_6_i386(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::el { 'el-6-i386':
    agent_version => $agent_version,
    pe_version => $pe_repo::default_pe_build,
  }
}
