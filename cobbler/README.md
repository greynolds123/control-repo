# cobbler [![Build Status](https://travis-ci.org/spacedog/puppet-cobbler.svg)](https://travis-ci.org/spacedog/puppet-cobbler)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What cobbler affects](#what-cobbler-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cobbler](#beginning-with-cobbler)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)

## Overview

This module manages installation and configuration cobbler itself as well as
cobbler objects such as distros, profiles, systems and repos.

## Module Description

Module installs cobbler servers. Module performs cobbler configuration,
including main configuration file, and cobbler modules. Module provides  custom
types for cobbler objects:
  * cobbler_distro - cobbler distributions
  * cobbler_repo - cobbler repositories
  * cobbler_profile - cobbler profiles
  * cobbler_system - cobbler systems


## Setup

### What cobbler affects

+ Module installs (including dependencies):
  * cobbler
  * syslinux
  * syslinux-tftpboot

  This can be overwritten using *_package_* parameter of *_cobbler_* class
  
+ Modules manages files:
  * /etc/cobbler/settings
  * /etc/cobbler/modules.conf

+ Affected services:
  * cobblerd

### Setup Requirements

This module uses custom types and providers so pluginsync must be enabled.

### Beginning with cobbler

For a basic installation setup with a default configuration parameters it's just
enough to declare cobbler module inside the manifest
```puppet
class {'cobbler':}
```

## Usage

To pass any configuration parameters the *cobbler_config* parameter is used.
*cobbler_config* is merged with *default_cobbler_config* from _params.pp_ and
pushed to /etc/cobbler/settings file

*cobbler_config* must be a hash that contains cobbler configuration options:

```puppet
$cobbler_settings = {
    'server'        => '192.168.0.1',
    'next_server'   => '192.168.0.1',
    'pxe_just_once' => 1
}

class {'cobbler':
  cobbler_config => $cobbler_settings,
}
```

For cobbler mopdules configuration _cobbler_modules_config parameter is used.
As well as _cobbler_config_ modules configuration passed to the class is merged
with _default_modules_config_ from _params.pp_

```puppet
$modules_settings = {
  'dns'  => {'module' => 'manage_dnsmasq'},
}

class {'cobbler':
  cobbler_modules_config => $modules_settings,
}
```

Cobbler objects are managed using custom types. One of the ways to create
distributions, repositories, profiles and systems is to pass hash to
_create_resources_ function. For example:
+ Using hiera:
```yaml
cobbler::distros:
  centos7-x86_64:
    ensure: present
    comment: 'CentOS7 Distribution'
    arch: x86_64
    path: /mnt
    initrd: '/var/www/cobbler/ks_mirror/centos7-minimal-x86_64/images/pxeboot/initrd.img'
    kernel: '/var/www/cobbler/ks_mirror/centos7-minimal-x86_64/images/pxeboot/vmlinuz'
    owners:
      - admin

create_resources('cobbler_distro', hiera('cobbler::distros')
```
or

+ Using puppet hash
```puppet
$interfaces = {
  'eth0'       => {
    ip_address => '192.168.1.6',
    netmask    => '255.255.255.0',
    if_gateway => '192.168.1.1',
  },
  'eth1'       => {
    ip_address => '192.168.100.10',
    netmask    => '255.255.255.0',
    if_gateway => '192.168.100.1',
  },
  'eth2'       => {
    ip_address => '192.168.200.11',
    netmask    => '255.255.255.0',
    if_gateway => '192.168.200.1',
  }
}
$systems = {
  'testhost01' => {
    ensure     => 'present',
    profile    => 'cvo_mgmt_server',
    interfaces => $interfaces,
    hostname   => 'testhost01',
}

create_resources('cobble_system', $systems)
```

## Reference

That module contains:
 + Custom types:
    * cobbler_distro
    * cobbler_repo
    * cobbler_profile
    * cobbler_system

## Limitations

+ osfamily => RedHat
+ if getenforce == Enforcing
  * setsebool -P httpd_can_network_connect_cobbler 1
  * setsebool -P httpd_serve_cobbler_files 1
  * semanage fcontext -a -t cobbler_var_lib_t "/var/lib/tftpboot/boot(/.*)?"
