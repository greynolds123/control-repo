class pe_repo::platform::ubuntu_1804_amd64(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::debian { 'ubuntu-18.04-amd64':
    agent_version => $agent_version,
    codename      => 'bionic',
    pe_version    => $pe_repo::default_pe_build,
  }
}
