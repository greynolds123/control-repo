# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   puppet_enterprise::file_sync_directory { 'namevar': }
define puppet_enterprise::file_sync_directory(
  String  $live_dir,
  String  $staging_dir,
  String  $file_sync_config_file,
  String  $file_sync_repo_name,
  Puppet_enterprise::Replication_mode $replication_mode,
) {
  $is_source  = $replication_mode == 'source'
  $is_replica = $replication_mode == 'replica'

  Pe_hocon_setting {
    path => $file_sync_config_file,
  }

  #Note that a directory with the same name as $file_sync_repo_name should exist
  #in files/master/file_sync, with a gitignore file inside the directory
  $file_sync_repo_setting = "file-sync.repos.${file_sync_repo_name}"
  $present_if_is_source   = if $is_source { present } else { absent }

  if !$is_source and !$is_replica {
    pe_hocon_setting { $file_sync_repo_setting:
      ensure  => absent,
      setting => $file_sync_repo_setting,
    }
  }

  pe_hocon_setting { "${file_sync_repo_setting}.staging-dir":
    ensure  => $present_if_is_source,
    setting => "${file_sync_repo_setting}.staging-dir",
    value   => $staging_dir,
  }

  if $is_source {
    file { "${staging_dir}/.gitignore":
      ensure  => present,
      mode    => '0600',
      source  => "puppet:///modules/puppet_enterprise/master/file_sync/${file_sync_repo_name}/gitignore",
      # (PE-22527) We have to wait until the service is reloaded to lay down this
      # file, so that file-sync-storage-service will notice a change in the
      # directory and initialize the first commit.
      require => Service['pe-puppetserver'],
    }
  }

  pe_hocon_setting { "${file_sync_repo_setting}.client-active":
    ensure  => $present_if_is_source,
    setting => "${file_sync_repo_setting}.client-active",
    value   => false,
  }

  pe_hocon_setting { "${file_sync_repo_setting}.auto-commit":
    ensure  => $present_if_is_source,
    setting => "${file_sync_repo_setting}.auto-commit",
    value   => true,
  }

  pe_hocon_setting { "${file_sync_repo_setting}.honor-gitignore":
    ensure  => $present_if_is_source,
    setting => "${file_sync_repo_setting}.honor-gitignore",
    value   => true,
  }

  if $is_replica {
    file { $live_dir:
      ensure => 'directory',
      mode   => '0700',
    }

    pe_hocon_setting { "${file_sync_repo_setting}.live-dir":
      ensure  => present,
      setting => "${file_sync_repo_setting}.live-dir",
      value   => $live_dir,
      require => File[$live_dir]
    }
  } else {
    pe_hocon_setting { "${file_sync_repo_setting}.live-dir":
      ensure  => absent,
      setting => "${file_sync_repo_setting}.live-dir",
    }
  }
}
