# == Class: puppet_enterprise::symlinks
#
# This class contains virtual resources for all symlinks managed by PE.
#
# === Examples
#
# include puppet_enterprise::symlinks
#
# File <| tag == 'pe-master-symlinks' |>
#
# === Parameters
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
#
class puppet_enterprise::symlinks (
  Boolean $manage_symlinks = $puppet_enterprise::manage_symlinks,
) inherits puppet_enterprise {

  # The defaults for our convenience links
  $platform_symlink_target = '/usr/local/bin'
  $pe_bin_location = '/opt/puppetlabs/bin'
  $pe_gem_location = '/opt/puppetlabs/puppet/lib/ruby/vendor_gems/bin'

  File {
    owner => undef,
    group => undef,
    mode  => undef,
  }

  # This test covers the fact returning boolean on supported
  # platforms as well as undef on Windows to prevent declaration
  if $facts['platform_symlink_writable'] and $manage_symlinks {
    @file { [ '/usr/local', $platform_symlink_target ]:
      ensure  => 'directory',
      replace => false,
      tag     => ['pe-agent-symlinks', 'pe-master-symlinks'],
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
      tag    => 'pe-master-symlinks',
      require => File[$platform_symlink_target],
    }

    @file { "${platform_symlink_target}/hiera":
      ensure => 'link',
      target => "${pe_bin_location}/hiera",
      tag    => 'pe-agent-symlinks',
      require => File[$platform_symlink_target],
    }

    @file { "${platform_symlink_target}/r10k":
      ensure => 'link',
      target => "${pe_bin_location}/r10k",
      tag    => 'pe-master-symlinks',
      require => File[$platform_symlink_target],
    }

    @file { "${platform_symlink_target}/eyaml":
      ensure => 'link',
      target => "${pe_gem_location}/eyaml",
      tag    => 'pe-master-symlinks',
      require => File[$platform_symlink_target],
    }
  }
}
