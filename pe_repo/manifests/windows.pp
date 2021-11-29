# Defined type that ensures correct folder structure,
# presence of the installer MSI, and an install.ps1 script
# for agent installation similar to install.bash.
#
# This is needed to support agent upgrades.
define pe_repo::windows(
  $arch,
  $agent_version   = $::aio_agent_version,
  $installer_build = $title,
  $pe_version      = $pe_repo::default_pe_build,
){
  include pe_repo

  File {
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  $msi_target = "${pe_repo::public_dir}/${pe_version}/${installer_build}-${agent_version}"

  # On a compile master sync from the primary once the primary has generated the agent directory.
  if pe_compile_master() and pe_directory_exists($msi_target) {
    file { $msi_target:
      ensure             => directory,
      owner              => root,
      group              => root,
      source             => "puppet:///pe_packages/${pe_version}/${installer_build}-${agent_version}",
      mode               => '644',
      recurse            => remote,
    }
  # On the primary generate the agent directory.
  } elsif !pe_compile_master() {
    $msi_name = "puppet-agent-${arch}.msi"

    if ! defined(File[$msi_target]) {
      file { $msi_target:
        ensure => directory,
        mode   => '755',
        owner  => root,
        group  => root,
      }
    }

    # Since the msi is not tarred up, we just want pe_staging::file, not deploy
    pe_staging::file { $msi_name:
      source      => "${pe_repo::base_path}/${pe_version}/${agent_version}/repos/windows/${msi_name}",
      target      => "${msi_target}/${msi_name}",
      require     => File[$pe_repo::public_dir, $msi_target],
      curl_option => $pe_repo::curl_option,
    }
  }

  puppet_enterprise::set_owner_group_permissions { $msi_target :
    file_mode => '0644',
    dir_mode  => '0755',
    owner     => 'root',
    group     => 'root',
  }

  $installer_build_link = "${pe_repo::public_dir}/${pe_version}/${installer_build}"

  if ! defined(File[$installer_build_link]) {
    file{ $installer_build_link:
      ensure => 'link',
      target => $msi_target,
    }
  }

  if ! defined(File["${pe_repo::public_dir}/${pe_version}/install.ps1"]) {
    file { "${pe_repo::public_dir}/${pe_version}/install.ps1":
      content => template('pe_repo/install.ps1.erb'),
    }
  }
}
