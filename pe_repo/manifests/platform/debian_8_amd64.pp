class pe_repo::platform::debian_8_amd64(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::debian { 'debian-8-amd64':
    agent_version => $agent_version,
    codename      => 'jessie',
    pe_version    => $pe_repo::default_pe_build,
  }
}
