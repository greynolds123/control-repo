# This class sets up the agent. For more information, see the [README.md](./README.md)
#
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
class puppet_enterprise::profile::agent(
  Boolean $manage_symlinks = $puppet_enterprise::manage_symlinks,
  Boolean $pxp_enabled     = true,
  String $pcp_broker_host  = $puppet_enterprise::pcp_broker_host,
  Integer $pcp_broker_port = $puppet_enterprise::pcp_broker_port,
) inherits puppet_enterprise {

  $platform_symlink_target = '/usr/local/bin'
  $pe_bin_location = '/opt/puppetlabs/bin'

  File {
    owner => undef,
    group => undef,
    mode  => undef,
  }

  if $manage_symlinks {
    File <| tag == 'pe-agent-symlinks' |>
  }


  # contents of puppet_enterprise/manifests/symlinks.pp
  # 
  # since the real agent.pp file just includes puppet_enterprise::symlinks 
  # instead of declaring it, it will get a default value for the 
  # manage_symlinks variable from the base puppet_enterprise class instead of
  # the one passed in to *this* class - urgh/LOL
  if $::platform_symlink_writable and $puppet_enterprise::manage_symlinks {
    @file { [ '/usr/local', $platform_symlink_target ]:
      ensure  => 'directory',
      replace => false,
      tag     => ['pe-agent-symlinks', 'pe-mco-symlinks', 'pe-master-symlinks'],
    }

    @file { "${platform_symlink_target}/facter":
      ensure => 'link',
      target => "${pe_bin_location}/facter",
      tag    => 'pe-agent-symlinks',
      require => File[$platform_symlink_target],
    }

    @file { "${platform_symlink_target}/puppet":
      ensure => 'link',
      target => "${pe_bin_location}/puppet",
      tag    => 'pe-agent-symlinks',
      require => File[$platform_symlink_target],
    }

    @file { "${platform_symlink_target}/pe-man":
      ensure => 'link',
      target => "${pe_bin_location}/pe-man",
      tag    => 'pe-agent-symlinks',
      require => File[$platform_symlink_target],
    }

    @file { "${platform_symlink_target}/hiera":
      ensure => 'link',
      target => "${pe_bin_location}/hiera",
      tag    => 'pe-agent-symlinks',
      require => File[$platform_symlink_target],
    }

    @file { "${platform_symlink_target}/mco":
      ensure => 'link',
      target => "${pe_bin_location}/mco",
      tag    => 'pe-mco-symlinks',
      require => File[$platform_symlink_target],
    }

    @file { "${platform_symlink_target}/r10k":
      ensure => 'link',
      target => "${pe_bin_location}/r10k",
      tag    => 'pe-master-symlinks',
      require => File[$platform_symlink_target],
    }
  }

}
