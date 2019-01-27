# kernel

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with kernel](#setup)
    * [What kernel affects](#what-kernel-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kernel](#beginning-with-kernel)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This modules helps with the deployment for kernel upgrades. The kernel upgrade 
is for Rhhel7 x86_64.  This module updates the kernel to  version 3.10.0-229.1.2.el7.x86_64. This is needed for the vswitch.  This modules solves the distribution/deployment/scaling of upgrading multiple nodes.


## Module Description

This modules assumes the os is linux. This module solves the need to deploy/installs a specific kernel version.  This is needed for vswitch to work properly.
You will need to add the following repo.

 yumrepo    { 'Redhat_7_Updates':
  ensure   => 'present',
  baseurl  => 'http://wwwin-kickstart-dev.cisco.com/yum/channels/$baseos/rhel-x86_64-server-7',
  descr    => 'RHEL7 udpates channel',
  enabled  => '1',
  gpgcheck => '0',
  gpgkey   => 'http://wwwin-kickstart-dev.cisco.com/yum/keys/RPM-GPG-KEY-redhat-release
  http://wwwin-kickstart-dev.cisco.com/yum/keys/RPM-GPG-KEY-redhat-release7',
  priority => '1',
  }


## Setup

### What kernel affects

* kernel-3.10.0-229.1.2.el7 
* /lib/modules

### Setup Requirements **OPTIONAL**

[Redhat_7_Updates]
name=RHEL7 udpates channel
baseurl=http://wwwin-kickstart-dev.cisco.com/yum/channels/$baseos/rhel-x86_64-server-7
enabled=1
gpgcheck=0
gpgkey=http://wwwin-kickstart-dev.cisco.com/yum/keys/RPM-GPG-KEY-redhat-release
  http://wwwin-kickstart-dev.cisco.com/yum/keys/RPM-GPG-KEY-redhat-release7
priority=1


### Beginning with kernel

* This is a module build for kernel updates.

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

* class => config.pp
* spec  => config.rb

## Limitations

Rhel7 => specific

## Development

* This module will deploy/update your kernel to the requried module for vswitch.

## Release Notes/Contributors/Etc **Optional**

This module should always for your software development track before deployment.
