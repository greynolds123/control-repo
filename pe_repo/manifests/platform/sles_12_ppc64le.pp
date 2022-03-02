class pe_repo::platform::sles_12_ppc64le(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::sles { 'sles-12-ppc64le':
    agent_version => $agent_version,
    pe_version => $pe_repo::default_pe_build,
  }
}
