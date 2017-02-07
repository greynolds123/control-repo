# == Class: docker
#
# Install and maintain the Docker Service. Support for Ubuntu OS.
# Uses latest packages from docker.com.
#
# === Parameters
# [*docker_opts*]
#   Array of options to be passed to the docker daemon.
#   docker_opts => [ '--dns=8.8.8.8', '--insecure-registry=myreg.example.com' ]
#
# [*version*]
# pass version to lxc-docker package.
# Default is installed. Can be version like '1.3.1' or 'latest'
# Older versions may not be avalible in the docker.com repo :(
# === Variables
#
# === Examples
#
#  class { 'docker':
#   docker_opts => [ '--dns=8.8.8.8', '--insecure-registry=myreg.example.com' ],
#  }
#
# === Authors
#
# Jason Greathouse <jgreat@jgreat.me>
#
# === Copyright
#
# Copyright 2014 Jason Greathouse
#
class docker (
  $docker_opts = [],
  $version = 'installed',
){

  validate_array($docker_opts)
  validate_string($version)
  $docker_options = join($docker_opts, ' ')

  case $::operatingsystem {
    Ubuntu: {
      package { 'apt-transport-https':
        ensure => installed,
      }
      # remove old docker apt repo
      apt::source { 'docker':
        ensure => absent,
      }
      # Use new dockerproject repo and docker-engine package.
      apt::source { 'dockerproject':
        location    => 'https://apt.dockerproject.org/repo',
        release     => "ubuntu-${::lsbdistcodename}",
        repos       => 'main',
        key         => 'F76221572C52609D',
        key_server  => 'hkp://p80.pool.sks-keyservers.net:80',
        include_src => false,
        require     => [
          Package['apt-transport-https'],
        ],
      }

      package { 'docker-engine':
        ensure  => $version,
        require => [
          Apt::Source['dockerproject'],
          Class[Apt::Update],
        ],
        notify  => Service['docker'],
      }

      file_line { 'default_docker':
        path    => '/etc/default/docker',
        line    => "DOCKER_OPTS=\"${docker_options}\"",
        match   => '^DOCKER_OPTS=.*',
        require => Package['docker-engine'],
        notify  => Service['docker'],
      }
    }
    RedHat: {
    }
    default: {
    }
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => [
      Package['docker-engine'],
      File_line['default_docker'],
    ],
  }
}
