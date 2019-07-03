class pe_repo::platform::solaris_10_sparc(
  $agent_version = $::aio_agent_version,
){
  include pe_repo

  pe_repo::sol10 { 'solaris-10-sparc':
    agent_version => $agent_version,
    pe_version => $pe_repo::default_pe_build,
  }
}

