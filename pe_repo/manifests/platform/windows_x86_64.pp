class pe_repo::platform::windows_x86_64(
  $agent_version = $::aio_agent_version,
){
  include pe_repo

  pe_repo::windows { 'windows-x86_64':
    arch          => 'x64',
    agent_version => $agent_version,
    pe_version    => $pe_repo::default_pe_build,
  }
}
