# == Define: sys::apt::sources
#
# Sets up a `sources.list` file (the title of this resource) for apt
# repositories.
#
# === Parameters
#
# [*ensure*]
#  Ensure value for this resource, defaults to 'present'.  Set to 'absent'
#  to remove the sources list.
#
# [*repositories*]
#  Array of hashes that specify the repository options.  Each
#  hash must have a 'uri', 'distribution', and 'components' keys, defaults
#  to [].
#
# [*source*]
#  Whether to include source ('deb-src') repositories.  Defaults to true.
#
# [*template*]
#  Template to use to render the sources.list, defaults to
# 'sys/apt/sources.list.erb'.
#
# === Examples
#
# This resource declaration:
#
#    sys::apt::sources { '/etc/apt/sources.list':
#      repositories => [
#        { 'uri'          => 'http://us.archive.ubuntu.com/ubuntu/',
#          'distribution' => 'precise',
#          'components'   => ['main', 'restricted'],
#        }
#      ],
#      source       => false,
#    }
#
# Produces the following content at `/etc/apt/sources.list`:
#
#   # This file autogenerated by Puppet with sys::apt::sources.
#   deb http://us.archive.ubuntu.com/ubuntu/ precise main restricted
#
define sys::apt::sources(
  $ensure       = 'present',
  $repositories = [],
  $source       = true,
  $template     = 'sys/apt/sources.list.erb'
){
  validate_absolute_path($title)
  validate_array($repositories)
  validate_bool($source)

  case $ensure {
    'present': {
      $file_ensure = 'file'
    }
    'absent': {
      $file_ensure = 'absent'
    }
    default: {
      fail('Invalid sys::apt::sources ensure value.')
    }
  }

  # The title of the resource should be the path to the apt
  # sources list, e.g., '/etc/apt/sources.list'.
  file { $title:
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($template),
  }
}