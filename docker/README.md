# docker

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview
* Updated for Docker 1.9.0
* Updated to use newer apt.dockerproject.org repo and docker-engine package.

The goal of this module is to provide support for Docker containers by extending
the puppet service type with a 'docker' provider.

Why?  

With the introduction of Docker 1.2 docker containers can be configured to restart automatically on docker service start or on failure. This makes Docker pretty good at maintaining its own processes. Instead of using Upstart, Supervisord or some other external service to monitor docker containers, this module queries the docker process for status and starts, stops and maintains docker containers "natively".  

## Setup

This module requires docker version >=1.3.1. This will be installed for you if you
include the docker class.

## Usage
### Install docker-engine package from apt.dockerproject.org:
This is optional, currently only supports Ubuntu.
```
class { 'docker': }
```

You can also specify a version (older versions may not be available on the docker.com apt repo).
```
class { 'docker':
  version => 'installed' #passes version to package. 'installed', 'latest' or version like "1.8.1-0~${::lsbdistcodename}"
}
```

### Add options to the docker daemon:
This is optional, currently only supports Ubuntu.
See docker documentation for possible options.
https://docs.docker.com/reference/commandline/cli/daemon/  
Under Ubuntu this adds options to `/etc/default/docker`
```
class { 'docker':
  docker_opts => [ '--dns=8.8.8.8', '--insecure-registry=myreg.example.com' ]
}
```

### Manage an image:
Docker >= 1.3.1 is required.  
You can pull an image before refreshing the docker container service.  
```
docker::container { 'repo:port/project/image':
    tag => 'tag', #optional will use 'latest' as default.
}
```

### Manage a container:
Containers will be named on creation.  
Most `docker create` options are supported. See docker documentation for more detail.  
https://docs.docker.com/reference/commandline/cli/create/
```
docker::container { 'name':
      image                 => 'repo:port/project/image:tag', #required
      attach                => [],
      add_host              => [],
      cap_add               => [],
      cap_drop              => [],
      cgroup_parent         => undef,
      command               => undef,
      cpu_set               => undef,
      cpuset_cpus           => undef,
      cpuset_mems           => undef,
      cpu_shares            => undef,
      device                => [],
      disable_content_trust => true,
      dns                   => [],
      dns_opt               => [],
      dns_search            => [],
      env                   => [],
      entrypoint            => undef,
      env_file              => [],
      expose                => [],
      hostname              => undef,
      interactive           => false,
      ipc                   => undef,
      kernel_memory         => undef,
      label                 => [],
      lable_file            => [],
      link                  => [],
      log_driver            => undef,
      lxc_conf              => [],
      mac_address           => undef,
      memory                => undef,
      memory_limit          => undef,
      memory_reservation    => undef,
      memory_swap           => undef,
      memory_swappiness     => '-1',
      net                   => undef,
      pid                   => undef,
      publish               => [],
      publish_all           => false,
      privileged            => false,
      read_only             => false,
      restart               => 'always',
      security_opt          => [],
      stop_signal           => 'SIGTERM',
      tty                   => false,
      ulimit                => [],
      user                  => undef,
      volume                => [],
      volume_driver         => undef,
      volumes_from          => [],
      workdir               => undef,
      extra_parameters      => [], #This passes directly to the docker create command
}
```

## Example
Here's a basic example.  
`puppet/manifest/site.pp`
```
# call the docker class and pass in any daemon options it needs
class { 'docker':
  docker_opts => ['--dns=8.8.8.8']
}

#call in our module class
class { 'myredisdocker': }
```
`puppet/modules/myredisdocker/manifests/init.pp`
```
class myredisdocker {

  #Require the docker class. This makes sure docker is installed and the
  #daemon is started.
  require docker

  #pull the redis:2.8.17 image from docker.com public repo
  docker::image { 'redis':
    tag => '2.8.17'
  }

  #Start a container.
  # We will use a volume for persistent data and publish to redis default port
  docker::container { 'redis':
    image   => 'redis:2.8.17',
    volume  => [ '/docker/redis/data:/data' ],
    publish => [ '6373:6373' ],
    require => Docker::Image['redis']
  }
}
```

## Reference

This module extends the `service` type with a 'docker' provider to directly interface with the docker daemon though the command line tools. In my opinion this is cleaner then wrapping docker commands in Upstart or Supervisord.

There are a few states a docker container will be in.
  * disabled - no docker container installed (not listed in docker ps -a)
  * enabled and stopped - docker container installed but not started(listed in docker ps -a)
  * enabled and started - docker container installed and running (listed in docker ps)

On resource create the provider will:
  * docker create
  * docker start

On resource refresh (i.e. some option has been changed)
  * docker stop
  * docker rm
  * docker create
  * docker start

So I suggest:
  * Log your docker container output remotely. Use `log_driver => syslog` or check out gliderlabs/logspout docker image.
  * Use volumes option for persistent data.

## Limitations

Using this module to maintain containers/images:
 * Docker >=1.3.1

If you want to use this module to maintain the docker service:
 * Ubuntu 14.04, 12.04

## Development
Please Help.

Have something awesome to add, want to improve my crappy ruby code (this is my
 first attempt at ruby so be gentle) fork the github repo and submit a pull request.

## TODO
  * Add package install and docker daemon config for other OS types (RedHat/CentOS, Debian). I want to use the latest packages from docker.com.
