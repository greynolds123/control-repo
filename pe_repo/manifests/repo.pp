# Defined type for downloaded a tar.gz repo and unpacking it.
#
# URL structure is https://pm.puppetlabs.com/puppet-agent/PE_VERSION/PUPPET_AGENT_VERSION/repos/buildname.tar.gz
# eg: https://pm.puppetlabs.com/puppet-agent/4.0.0/1.1.0.227/repos/puppet-agent-el-7-x86_64.tar.gz
#
# The unpacked tarbal dir structure is based on the repo type.
# EL, SLES and Fedora share the same type of layout:
# repos/<platform>/<os_version>/<puppet collection version>/<arch>
# eg: repos/el/7/pc1/x86_64
#
# Deb & ubuntu share the same:
# repos/apt/<codename>/{conf,db,dists,pool}
#
# OSX is:
# repos/apple/<puppet collection version>/*.dmg
#
# AIX and solaris are not currently built
# Windows is not currently supported
define pe_repo::repo (
  $agent_version    = $::aio_agent_version,
  $installer_build  = $title,
  $pe_version       = $pe_repo::default_pe_build,
  $postgres_version = $puppet_enterprise::params::postgres_version,
  $tarball_creates  = undef,
  $tarball_name     = undef,
  $tarball_strip    = undef,
  $tarball_unless   = undef,
){
  include pe_repo

  # Pretty much all tarballs will be named the same, except for OSX which is just the
  # version and does not include arch type.
  $_tarball_name = $tarball_name ? {
    undef   => "puppet-agent-${installer_build}.tar.gz",
    default => $tarball_name,
  }

  $_tarball_target = "${pe_repo::public_dir}/${pe_version}/${installer_build}-${agent_version}"

  $creates = $tarball_creates ? {
    undef   => undef,
    default => "${_tarball_target}/${tarball_creates}",
  }

  $download_url = "${pe_repo::base_path}/${pe_version}/${agent_version}/repos/${_tarball_name}"

  $staging_dir = "${::pe_repo::root_staging_dir}/pe_repo-puppet-agent-${agent_version}"
  if ! defined(File[$staging_dir]) {
    file { $staging_dir:
      ensure=>directory,
    }
  }

  # If this is a compile master and the master of masters has the repo files,
  # sync them via puppet. (If the files aren't present on the master yet, we skip
  # trying to sync them to the compile master until this is resolved. This situation
  # can happen when a pe_repo::platform class is applied to the PE Master node group
  # and a catalog is built for a compile master before the primary.)
  if pe_compile_master() and pe_directory_exists($_tarball_target) {
    file { $_tarball_target:
      ensure             => directory,
      owner              => root,
      group              => root,
      source             => "puppet:///pe_packages/${pe_version}/${installer_build}-${agent_version}",
      recurse            => remote,
    }

  # Otherwise this is the primary and we download from pm.puppetlabs.com if the agent
  # packages aren't already present as determeind by the given $creates, $tarball_unless
  # tests.
  } elsif !pe_compile_master() {
    file { $_tarball_target:
      ensure => directory,
      mode   => '0755',
      owner  => root,
      group  => root,
    }
    pe_staging::deploy { $_tarball_name:
      source       => $download_url,
      staging_path => "${staging_dir}/${_tarball_name}",
      target       => $_tarball_target,
      creates      => $creates,
      unless       => $tarball_unless,
      strip        => $tarball_strip,
      require      => File[$pe_repo::public_dir, $_tarball_target],
      mode         => '0755',
      curl_option  => $pe_repo::curl_option,
    }
  }

  puppet_enterprise::set_owner_group_permissions { $_tarball_target :
    file_mode => '0644',
    dir_mode  => '0755',
    owner     => 'root',
    group     => 'root',
  }

  if ! defined(File["${pe_repo::public_dir}/${pe_version}"]) {
    file { "${pe_repo::public_dir}/${pe_version}":
      ensure => directory,
      mode   => '0755',
      owner  => root,
      group  => root,
    }

    # These variables are needed by the templates
    $prefix = $pe_repo::prefix
    $master = $pe_repo::master
    $port = $settings::masterport
    $enable_bulk_pluginsync = $::pe_repo::enable_bulk_pluginsync

    file { "${pe_repo::public_dir}/${pe_version}/install.bash":
      ensure  => file,
      mode    => '0644',
      owner   => root,
      group   => root,
      content => template('pe_repo/install.erb'),
    }

    file { "${pe_repo::public_dir}/${pe_version}/upgrade.bash":
      ensure  => file,
      mode    => '0644',
      owner   => root,
      group   => root,
      content => template('pe_repo/upgrade.erb'),
    }
  }

  $installer_build_link = "${pe_repo::public_dir}/${pe_version}/${installer_build}"
  if ! defined(File[$installer_build_link]) {
    file { $installer_build_link:
      ensure => 'link',
      target => $_tarball_target,
    }
  }
}
