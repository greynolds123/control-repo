# Define: logrotate::file
#
# This define controls files in /etc/logrotate.d/
#
# Parameters:
#   log         => name of the logfiles logrotate should manage
#   options     => array containing 1 or more logrotate directives (e.g. missingok, compress)
#   postrotate  => array containing 1 or more postrotate commands to run
#   ensure      => present | absent
#
# Requires:
#   logrotate
#
# Sample Usage:
#   logrotate::file {
#     'puppet':
#       log         => '/var/log/puppet/*log',
#       options     => [ 'missingok', 'notifempty', 'create 0644 puppet puppet', 'sharedscripts', 'weekly' ],
#       postrotate  => [  '[ -e /etc/init.d/puppetmaster ] && /etc/init.d/puppetmaster condrestart >/dev/null 2>&1 || true',
#                         '[ -e /etc/init.d/puppet ] && /etc/init.d/puppet reload > /dev/null 2>&1 || true' ],
#       ensure      => 'present';
#   }
#
define logrotate::file(
  $log,
  $options,
  $ensure     = 'present',
  $postrotate = 'NONE',
  $template   = 'logrotate/logrotate.tpl',
  $source     = undef,
) {
  require logrotate

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $template ? {
    ''        => undef,
    default   => template($template),
  }

  file { "/etc/logrotate.d/${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => $manage_file_content,
    source  => $manage_file_source,
  }
}
