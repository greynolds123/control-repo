# Defined type for downloading and configuring the simplified installer for OSX.
#
# The .dmg and .pkg file include the full dev version while the url only includes
# the os version and the agent_version without any git sha.
#
#   http://agent-downloads.delivery.puppetlabs.net/2015.2/puppet-agent/1.2.4.2/repos/puppet-agent-osx-10.9.tar.gz
#
# for example contains
#
#   repos/apple/pc1/puppet-agent-1.2.4.2.gabcd123-1.osx10.9.dmg
#
# which itself has
#
#   puppet-agent-1.2.4.2.gabcd123-1-installer.pkg
#
# Once released (as 1.2.5 for example) these will be the same but with
# 1.2.4.2-gabcd123 replaced with 1.2.5
define pe_repo::osx(
  $codename,
  $agent_version   = $::aio_agent_build,
  $installer_build = $title,
  $pe_version      = $pe_repo::default_pe_build,
) {
  include pe_repo

  File {
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  # installer_build is the platform tag, osx-10.9-x86_64
  $tags = split($installer_build, '-')
  $os_version = $tags[1]
  $dmg_file = "puppet-agent-${agent_version}-1.osx${os_version}.dmg"

  # These variables are needed by the templates
  $prefix = $pe_repo::prefix
  $master = $pe_repo::master
  $port   = $settings::masterport

  file { "${pe_repo::public_dir}/${pe_version}/${installer_build}.bash":
    content => template('pe_repo/osx.bash.erb'),
  }

  # If this is a dev version, trim the gitsha for use in the download url.
  $_agent_version = regsubst($agent_version, '^(\d+\.\d+\.\d+\.\d+)(.*)', '\1')

  pe_repo::repo { "${installer_build} ${pe_version}":
    agent_version   => $_agent_version,
    installer_build => $installer_build,
    pe_version      => $pe_version,
    tarball_creates => $dmg_file,
    tarball_name    => "puppet-agent-osx-${os_version}.tar.gz",
    tarball_strip   => '5',
  }
}
