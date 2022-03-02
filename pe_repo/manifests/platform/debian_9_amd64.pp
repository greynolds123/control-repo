class pe_repo::platform::debian_9_amd64(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::debian { 'debian-9-amd64':
    agent_version => $agent_version,
    codename      => 'stretch',
    pe_version    => $pe_repo::default_pe_build,
  }
}
