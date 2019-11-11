# === Class: pe_concat::setup
#
# Sets up the pe_concat system. This is a private class.
#
# [$concatdir]
#   is where the fragments live and is set on the fact pe_concat_basedir.
#   Since puppet should always manage files in $concatdir and they should
#   not be deleted ever, /tmp is not an option.
#
# It also copies out the concatfragments.{sh,rb} file to ${concatdir}/bin
#
class pe_concat::setup {
  if $caller_module_name != $module_name {
    warning("${name} is deprecated as a public API of the ${module_name} module and should no longer be directly included in the manifest.")
  }

  if $::pe_concat_basedir {
    $concatdir = $::pe_concat_basedir
  } else {
    fail ('$pe_concat_basedir not defined. Try running again with pluginsync=true on the [master] and/or [main] section of your node\'s \'/etc/puppet/puppet.conf\'.')
  }

  # owner and mode of fragment files (on windows owner and access rights should
  # be inherited from concatdir and not explicitly set to avoid problems)
  $fragment_owner = $::osfamily ? { 'windows' => undef, default => $::id }
  $fragment_mode  = $::osfamily ? { 'windows' => undef, default => '0640' }

  # PR #174 introduced changes to the concatfragments.sh script that are
  # incompatible with Solaris 10 but reportedly OK on Solaris 11.  As a work
  # around we are enable the .rb pe_concat script on all Solaris versions.  If
  # this goes smoothly, we should move towards completely eliminating the .sh
  # version.
  $script_name = $::osfamily? {
    /(?i:(Windows|Solaris))/ => 'concatfragments.rb',
    default                  => 'concatfragments.sh'
  }

  $script_path = "${concatdir}/bin/${script_name}"

  $script_owner = $::osfamily ? { 'windows' => undef, default => $::id }
  $script_group = $::osfamily ? { 'windows' => undef, default => $::gid }

  $script_mode = $::osfamily ? { 'windows' => undef, default => '0755' }

  $script_command = $::osfamily? {
    'windows' => "ruby.exe '${script_path}'",
    default   => $script_path
  }

  File {
    backup => false,
    owner  => $script_owner,
    group  => $script_group,
  }

  file { $script_path:
    ensure => file,
    mode   => $script_mode,
    source => "puppet:///modules/pe_concat/${script_name}",
  }

  file { [ $concatdir, "${concatdir}/bin" ]:
    ensure => directory,
    mode   => '0755',
  }
}
