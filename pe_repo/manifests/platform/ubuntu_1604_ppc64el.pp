class pe_repo::platform::ubuntu_1604_ppc64el(
  $agent_version = $::aio_agent_build,
){
  include pe_repo

  pe_repo::debian { 'ubuntu-16.04-ppc64el':
    agent_version => $agent_version,
    codename      => 'xenial',
    pe_version    => $pe_repo::default_pe_build,
  }
}
