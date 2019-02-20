# Class: logrotate
#
# This module manages logrotate and logrotate.d files
#
# Sample Usage:
#   include logrotate
#
class logrotate (
  $rotate_every = 'weekly',
  $rotate       = 4,
  $compress     = 'compress',
  $options      = [],
  $template     = 'logrotate/logrotate.conf.erb',
  $source       = undef,
) {

  $manage_file_source = $logrotate::source ? {
    ''        => undef,
    default   => $logrotate::source,
  }

  $manage_file_content = $logrotate::template ? {
    ''        => undef,
    default   => template($logrotate::template),
  }

  package { 'logrotate':
    ensure  => 'installed';
  }

  # TODO - import all logrotate configs into puppet, add purge => true?
  file { '/etc/logrotate.d':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['logrotate'],
  }

  file { '/etc/logrotate.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => $manage_file_content,
    source  => $manage_file_source,
    require => Package['logrotate'],
  }
}
