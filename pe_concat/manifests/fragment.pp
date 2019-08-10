# == Define: pe_concat::fragment
#
# Puts a file fragment into a directory previous setup using pe_concat
#
# === Options:
#
# [*target*]
#   The file that these fragments belong to
# [*content*]
#   If present puts the content into the file
# [*source*]
#   If content was not specified, use the source
# [*order*]
#   By default all files gets a 10_ prefix in the directory you can set it to
#   anything else using this to influence the order of the content in the file
# [*ensure*]
#   Present/Absent or destination to a file to include another file
# [*mode*]
#   Deprecated
# [*owner*]
#   Deprecated
# [*group*]
#   Deprecated
# [*backup*]
#   Deprecated
#
define pe_concat::fragment(
    $target,
    $content = undef,
    $source  = undef,
    $order   = '10',
    $ensure  = undef,
    $mode    = undef,
    $owner   = undef,
    $group   = undef,
    $backup  = undef
) {
  pe_validate_string($target)
  pe_validate_string($content)
  if !(pe_is_string($source) or pe_is_array($source)) {
    fail('$source is not a string or an Array.')
  }
  if !(pe_is_string($order) or pe_is_integer($order)) {
    fail('$order is not a string or integer.')
  }
  if $mode {
    warning('The $mode parameter to pe_concat::fragment is deprecated and has no effect')
  }
  if $owner {
    warning('The $owner parameter to pe_concat::fragment is deprecated and has no effect')
  }
  if $group {
    warning('The $group parameter to pe_concat::fragment is deprecated and has no effect')
  }
  if $backup {
    warning('The $backup parameter to pe_concat::fragment is deprecated and has no effect')
  }
  if $ensure == undef {
    $my_ensure = pe_concat_getparam(Pe_concat[$target], 'ensure')
  } else {
    if ! ($ensure in [ 'present', 'absent' ]) {
      warning('Passing a value other than \'present\' or \'absent\' as the $ensure parameter to pe_concat::fragment is deprecated.  If you want to use the content of a file as a fragment please use the $source parameter.')
    }
    $my_ensure = $ensure
  }

  include pe_concat::setup

  $safe_name        = regsubst($name, '[/:\n]', '_', 'GM')
  $safe_target_name = regsubst($target, '[/:\n]', '_', 'GM')
  $concatdir        = $pe_concat::setup::concatdir
  $fragdir          = "${concatdir}/${safe_target_name}"
  $fragowner            = $pe_concat::setup::fragment_owner
  $fragmode             = $pe_concat::setup::fragment_mode

  # The file type's semantics are problematic in that ensure => present will
  # not over write a pre-existing symlink.  We are attempting to provide
  # backwards compatiblity with previous pe_concat::fragment versions that
  # supported the file type's ensure => /target syntax

  # be paranoid and only allow the fragment's file resource's ensure param to
  # be file, absent, or a file target
  $safe_ensure = $my_ensure ? {
    ''        => 'file',
    undef     => 'file',
    'file'    => 'file',
    'present' => 'file',
    'absent'  => 'absent',
    default   => $my_ensure,
  }

  # if it looks line ensure => /target syntax was used, fish that out
  if ! ($my_ensure in ['', 'present', 'absent', 'file' ]) {
    $ensure_target = $my_ensure
  } else {
    $ensure_target = undef
  }

  # the file type's semantics only allows one of: ensure => /target, content,
  # or source
  if ($ensure_target and $source) or
    ($ensure_target and $content) or
    ($source and $content) {
    fail('You cannot specify more than one of $content, $source, $ensure => /target')
  }

  if ! ($content or $source or $ensure_target) {
    crit('No content, source or symlink specified')
  }

  # punt on group ownership until some point in the distant future when $::gid
  # can be relied on to be present
  file { "${fragdir}/fragments/${order}_${safe_name}":
    ensure  => $safe_ensure,
    owner   => $fragowner,
    mode    => $fragmode,
    source  => $source,
    content => $content,
    backup  => false,
    replace => true,
    alias   => "pe_concat_fragment_${name}",
    notify  => Exec["pe_concat_${target}"]
  }
}
