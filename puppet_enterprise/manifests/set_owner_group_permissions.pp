define puppet_enterprise::set_owner_group_permissions (
  String $file_mode,
  String $owner,
  String $group,
  Enum['file','directory'] $target_type = 'directory',
  String $target                        = $title,
  Optional[String] $dir_mode            = undef,
){
  $_target = $target_type ? {
    'file'      => $target,
    'directory' => "${target}/",
  }

  Exec{
    path      => $::path,
    logoutput => true,
    loglevel  => 'notice',
  }

  if $target_type == 'directory' {
    if !pe_empty($dir_mode){
      exec { "Set perms of ${_target} directories to ${dir_mode}":
        command   => "find ${_target} -type d ! -perm ${dir_mode} -exec chmod -c ${dir_mode} {} \\;",
        onlyif    => "find ${_target} -type d ! -perm ${dir_mode} | grep '.*'",
      }
    } else {
      fail('puppet_enterprise::set_owner_group_permissions::dir_mode parameter is required when target_type is set to directory')
    }
  }

  exec { "Set perms of ${_target} contents to ${file_mode}":
    command   => "find ${_target} -type f ! -perm ${file_mode} -exec chmod -c ${file_mode} {} \\;",
    onlyif    => "find ${_target} -type f ! -perm ${file_mode} | grep '.*'",
  }

  exec { "Set user/group of ${_target} contents to ${owner}:${group}":
    command   => "find ${_target} \\( ! -user ${owner} -or ! -group ${group} \\) -exec chown ${owner}:${group} -c {} \\;",
    onlyif    => "find ${_target} \\( ! -user ${owner} -or ! -group ${group} \\) | grep '.*'",
  }
}
