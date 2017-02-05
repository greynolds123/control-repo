# Definition: docker::container
#
# This class installs docker containers using a custom provider for service.
#
# Requires docker version >=1.3.1
#
# Parameters:
# Required parameters:
# - image - docker image name with optional tag "ubuntu:14.04"
# Option parameters:
# - See 'docker create' options:
#     http://docs.docker.com/reference/commandline/cli/#create
# - Accepts most options documented.
# - If an option is not avalible you can pass in additonal options with
#   extra_parameters => [ '--option=foo', '--other=bar' ]
#
# Yes this is a total cop out on the docs, but docker options are a fast
# moving target.
#
# Actions:
#
# Writes a "config" file to /etc/docker/$title.config with the various docker
# options, then creates a service with the provider "docker" to start, stop and
# maintain the container.
# The Service:
# enable => true - 'docker create $title'
# enable => false - 'docker rm $title'
# ensure => running - 'docker start $title'
# ensure => stopped - 'docker stop $title'
# refresh action - stop, rm, create, start
#
# Requires:
# - docker class
#
# Sample Usage:
#    require docker
#
#    docker::container { 'logspout':
#      image    => 'progrium/logspout',
#      command  => "syslog://logs.example.com:22000",
#      volume   => [ '/var/run/docker.sock:/tmp/docker.sock' ],
#      publish  => [ '127.0.0.1:8000:8000' ],
#      hostname => $::fqdn,
#      dns      => [ '8.8.8.8', '8.8.4.4' ],
#    }
#
define docker::container (
  $image,
  $ensure = 'present',
  $attach = [],
  $add_host = [],
  $blkio_weight = undef,
  $cap_add = [],
  $cap_drop = [],
  $cgroup_parent = undef,
  $command = undef,
  $cpu_period = undef,
  $cpu_quota = undef,
  $cpu_set = undef,
  $cpuset_cpus = undef,
  $cpuset_mems = undef,
  $cpu_shares = undef,
  $device = [],
  $disable_content_trust = true,
  $dns = [],
  $dns_opt = [],
  $dns_search = [],
  $env = [],
  $entrypoint = undef,
  $env_file = [],
  $expose = [],
  $extra_parameters = [],
  $hostname = undef,
  $interactive = false,
  $ipc = undef,
  $kernel_memory = undef,
  $label = [],
  $lable_file = [],
  $link = [],
  $log_driver = undef,
  $log_opt = [],
  $lxc_conf = [],
  $mac_address = undef,
  $memory = undef,
  $memory_limit = undef,
  $memory_reservation = undef,
  $memory_swap = undef,
  $memory_swappiness = undef,
  $net = undef,
  $oom_kill_disable = false,
  $pid = undef,
  $publish = [],
  $publish_all = false,
  $privileged = false,
  $read_only = false,
  $restart = 'always',
  $security_opt = [],
  $stop_signal = undef,
  $tty = false,
  $ulimit = [],
  $user = undef,
  $uts = undef,
  $volume = [],
  $volumes_from = [],
  $volume_driver = undef,
  $workdir = undef,
) {

  validate_array($attach)
  validate_array($add_host)
  validate_string($blkio_weight)   #new docker 1.7.0
  validate_array($cap_add)
  validate_array($cap_drop)
  validate_string($cgroup_parent)  #new docker 1.6.0
  #cidfile not needed
  validate_string($command)
  validate_string($cpu_set)        #deprecated 1.6.0
  validate_string($cpuset_cpus)    #new docker 1.6.0
  validate_string($cpuset_mems)    #new docker 1.9.0
  validate_string($cpu_period)     #new docker 1.7.0
  validate_string($cpu_quota)      #new docker 1.7.0
  validate_string($cpu_shares)
  validate_array($device)
  validate_bool($disable_content_trust) #new docker 1.9.0
  validate_array($dns)
  validate_array($dns_opt)         #new docker 1.9.0
  validate_array($dns_search)
  validate_array($env)
  validate_string($entrypoint)
  validate_array($env_file)
  validate_array($expose)
  validate_string($hostname)
  validate_bool($interactive)
  validate_string($ipc)            #new docker 1.6.0
  validate_string($kernel_memory)  #new docker 1.9.0
  validate_array($label)           #new docker 1.6.0
  validate_array($lable_file)      #new docker 1.6.0
  validate_string($image)
  validate_array($link)
  validate_string($log_driver)     #new docker 1.6.0
  validate_array($log_opt)         #new docker 1.7.0
  validate_array($lxc_conf)
  validate_string($mac_address)    #new docker 1.6.0
  validate_string($memory)         #new docker 1.6.0
  validate_string($memory_limit)   #deprecated 1.6.0
  validate_string($memory_reservation) #new docker 1.9.0
  validate_string($memory_swap)    #new docker 1.6.0
  validate_string($memory_swappiness) #new docker 1.9.0
  #name is always defined as title
  validate_string($net)
  validate_bool($oom_kill_disable) #new docker 1.7.0
  validate_string($pid)
  validate_array($publish)
  validate_bool($publish_all)
  validate_bool($privileged)
  validate_bool($read_only)        #new docker 1.6.0
  validate_string($restart)
  validate_array($security_opt)
  validate_string($stop_signal)    #new docker 1.9.0
  validate_bool($tty)
  validate_array($ulimit)          #new docker 1.6.0
  validate_string($user)
  validate_string($uts)            #new docker 1.7.0
  validate_array($volume)
  validate_string($volume_driver)  #new docker 1.9.0
  validate_array($volumes_from)
  validate_string($workdir)

  #Other params that docker create might add
  validate_array($extra_parameters)

  $config_dir = '/etc/docker'
  $config_file = "${config_dir}/${title}.config"

  if ($ensure == 'present'){
    if (! defined(File[$config_dir])) {
      file { $config_dir:
        ensure => directory,
      }
    }
    file { $config_file:
      ensure  => file,
      mode    => '0600',
      content => template('docker/etc/docker/docker.config.erb'),
      require => File[$config_dir],
      notify  => Service[$title],
    }
    service { $title:
      ensure   => running,
      enable   => true,
      provider => 'docker',
      manifest => $config_file,
      require  => File[$config_file],
    }
  }
  if ($ensure == 'absent') {
    file{ $config_file:
      ensure => absent
    }
    service { $title:
      enable   => false,
      provider => 'docker',
    }
  }
}
