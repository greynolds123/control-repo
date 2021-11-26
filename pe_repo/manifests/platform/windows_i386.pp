class pe_repo::platform::windows_i386(
  $agent_version = $::aio_agent_version,
){
  include pe_repo

  pe_repo::windows { 'windows-i386':
    arch          => 'x86',
    agent_version => $agent_version,
    pe_version    => $pe_repo::default_pe_build,
  }
}

