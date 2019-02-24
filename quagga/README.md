[![Build Status](https://travis-ci.org/icann-dns/puppet-quagga.svg?branch=master)](https://travis-ci.org/icann-dns/puppet-quagga)
[![Puppet Forge](https://img.shields.io/puppetforge/v/icann/quagga.svg?maxAge=2592000)](https://forge.puppet.com/icann/quagga)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/icann/quagga.svg?maxAge=2592000)](https://forge.puppet.com/icann/quagga)
# Quagga

### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with quagga](#setup)
    * [What quagga affects](#what-quagga-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with quagga](#beginning-with-quagga)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Manage the installation and configuration of Quagga (Routing Daemons) .

## Module Description

This modules allows for the manging of the quagga BGP daemon. Other routing modules are currently unsupported however you should be able to configure them manuly

## Setup

### What quagga affects

* Manages the quagga configueration file 
* Manages the quagga bgpd configueration file 
* can export nagios\_service to test neighbours are Established and routes are being advertised

### Setup Requirements

* depends on stdlib 4.11.0 (may work with earlier versions)

### Beginning with quagga

Install the package an make sure it is enabled and running with default options, this will just configure zebra to run with no bgp config:

```puppet 
class { '::quagga': }
```

With some bgp peers

```puppet
class { '::quagga': }
class { '::quagga::bgpd':
  my_asn => 64496,
  router_id => '192.0.2.1',
  networks4 => [ '192.0.2.0/24'],
  peers => {
    '64497' => {
      'addr4' => ['192.0.2.2'],
      'desc'  => 'TEST Network'
    }
  }
}  
```

and in hiera

```yaml
my_asn: 64496,
router_id: 192.0.2.1
networks4:
- '192.0.2.0/24'
peers:
  64497:
    addr4:
    - '192.0.2.2'
    desc: TEST Network
```

## Usage

Add config but disable advertisments and add nagios checks

```puppet
class { '::quagga::bgpd':
  my_asn => 64496,
  router_id => '192.0.2.1',
  networks4 => [ '192.0.2.0/24'],
  enable_advertisements => false,
  peers => {
    '64497' => {
      'addr4' => ['192.0.2.2'],
      'desc'  => 'TEST Network'
    }
  }
}  
```

Full config

```puppet
class { '::quagga::bgpd':
  my_asn                   => 64496,
  router_id                => '192.0.2.1',
  networks4                => [ '192.0.2.0/24', '10.0.0.0/24'],
  failsafe_networks4       => ['10.0.0.0/23'],
  networks6                => ['2001:DB8::/48'],
  failsafe_networks6       => ['2001:DB8::/32'],
  enable_advertisements    => false,
  enable_advertisements_v4 => false,
  enable_advertisements_v6 => false,
  manage_nagios            => true,
  peers => {
    '64497' => {
      'addr4'          => ['192.0.2.2'],
      'addr6'          => ['2001:DB8::2'],
      'desc'           => 'TEST Network',
      'inbound_routes' => 'all',
      'communities'    => ['no-export', '64497:100' ],
      'multihop'       => 5,
      'password'       => 'password',
      'prepend'        => 3,
    }
  }
}  
```

## Reference


- [**Public Classes**](#public-classes)
    - [`quagga`](#class-quagga)
    - [`quagga::bgpd`](#class-quaggabgpd)
- [**Private Classes**](#private-classes)
    - [`quagga::params`](#class-quaggaparams)
- [**Private defined types**](#private-defined-types)
    - [`quagga::bgpd::peer`](#class-quaggabgpdpeer)
    - [`quagga::bgpd::peer::nagios`](#class-quaggabgpdpeernagios)

### Classes

### Public Classes

#### Class: `quagga`
  Guides the basic setup and installation of Quagga on your system
  
##### Parameters (all optional)

* `owner` (String, Default: quagga): User to use for permissions 
* `group` (String, Default: quagga): Group to use for permissions 
* `mode` (String /^\d+$/, Default: 0664): Mode to use for permissions 
* `quagga_content` (String, Default: 'hostname ${::fqdn}'): content of the quagga config
* `enable_zebra` (Bool, Default: true): determin if we should enable zebra
* `package` (String, Default: quagga): package to install

#### Class: `quagga::bgpd`
  configure BGP settings
  
##### Parameters (all optional)

* `my_asn` (Int, Default: undef): The local ASN to use
* `router_id` (IP Address, Default: undef): IP address for the router ID
* `networks4` (Array, Default: []): Array ip IPv4 networks in CIDR format to configure
* `failsafe_networks4` (Array, Default: []): Array ip IPv4 failsafe networks in CIDR format to configure.  Failsafe networks consist of covering prefixes for the IPv4 networks.  if the policy decided to disable advertising due to detected errors it will leave the failsafe network inplace.  This is a specific use case for anycast networks which effectivly disables an anycast node as all others will still be advertising a more specific network; however if something goes wrong and all nodes have the most specific route removed then we would still have this failsafe network in place.  
* `networks6` (Array, Default: []): Array ip IPv6 networks in CIDR format to configure
* `failsafe_networks4` (Array, Default: []): Array ip IPv6 failsafe networks in CIDR format to configure.  See failsafe_networks4 for a description
* `failsafe_server` (Bool, Default: false): If this is set to true then we will only ever advertise the failsafe networks.  i.e. the node will be effectivly ofline unless all other nodes are either out of commision or remove ther most specific networks (`networks4` and `networks6`)
* `enable_advertisements` (Bool, Default: true): If this is set to false then no networks, including the failsafe networks, will be advertised.
* `enable_advertisements_v4` (Bool, Default: true): If this is set to false then no IPv4 networks, including the failsafe IPv4 networks, will be advertised.
* `enable_advertisements_v6` (Bool, Default: true): If this is set to false then no IPv6 networks, including the failsafe IPv6 networks, will be advertised.
* `manage_nagios` (Bool, Default: false): If this is set to true the policy will create vertual resources to check each peer neighbor'
* `conf_file` (Absolute file path, Default: '/etc/quagga/bgpd.conf'): The fully qualified path to the managed config file

> Valid Debug Options as4, events, filters, fsm, keepalives, updates, zebra

* `debug_bgp` (Array of Valid OptionsEvents, Default: []): Enable BGP debugging foreach option in te array

> Valid Logging levels: emergencies, alerts, critical, errors, warnings, notifications, informational, debugging

* `log_stdout` (Bool, Default: false): if set to true enable logging to stdout
* `log_stdout_level` (Valid Logging level, Default: debugging): The logging level for stdout logging 
* `log_file` (Bool, Default: false): if set to true enable logging to file
* `log_file_path` (Valid path, Default: /var/log/quagga/bgpd.log): The path for file logging
* `log_file_level` (Valid Logging level, Default: debugging): The logging level for file logging 
* `logrotate_enable`: (Bool, Default: false): enable logrotate rules.  Only valid of log_file is also true
* `logrotate_rotate` (Integer, Default: 5): The number of rotated log files to keep on disk.
* `logrotate_size` (String, Default: 100M): The String size a log file has to reach before it will be rotated.  The default units are bytes, append k, M or G for kilobytes, megabytes or gigabytes respectively.
* `log_syslog` (Bool, Default: false): if set to true enable logging to syslog
* `log_syslog_facility` (String, Default: 'daemon') The syslog facilty to use
* `log_syslog_level` (Valid Logging level, Default: debugging): The logging level for syslog logging 
* `log_monitor` (Bool, Default: false): if set to true enable logging to monitor
* `log_monitor_level` (Valid Logging level, Default: debugging): The logging level for monitor logging 
* `log_record_priority` (Bool, Default: false): If true log the severity in all messages logged to a file, to stdout, or to a terminal monitor (i.e. anything except syslog)
* `log_timestamp_precision` (Integer <=6, Default: 1): This sets the precision of log message timestamps to the given number of digits after the decimal point.
* `peers` (Hash, Default: {}): A hash of peers to be used with create_resources(quagga::bgpd::peer, $peers)

### Private Classes

#### Class `quagga::params`

Set os specific parameters

### Private Defined Types

#### Defined `quagga::bgpd::peer`

Creat config for individual peers

##### Parameters 

* `namevar` (Int): ASN of the peer
* `addr4` (Array, Default: []): Array of IPv4 neighbor addresses
* `addr6` (Array, Default: []): Array of IPv6 neighbor addresses
* `desc` (String, Default: undef): Description of the peer
* `inbound_routes` (String /^(all|none|default|v4|default|v6default)$/, Default: 'none'): what ACL to apply for inbound routes.  
    * all: accept all but the default route
    * none: accept no routes
    * default: only accept default routes
    * v4default: only accept default routes over ipv4
    * v6default: accept a default v6 route
* `communities` (Array, Default: []): Array of comminuties to set on advertised routes.
* `multihop` (Int, Default: undef): Multihop setting to set on peers neighbor addresses
* `password` (String, Default: undef): Password setting to set on peers neighbor addresses
* `prepend` (Int, Default: undef): Number of times to prepend your own ASN on advertised routes


#### Defined `quagga::bgpd::peer::nagios`

configure exported nagios servies for specific neighbor addresses

##### Parameters 

* `namevar` (String): The IPv4 or IPv6 neighbor address
* `routes` (Array, Default: []): Array of routes we should be advertising to the neighbor


## Limitations

This module has been tested on:

* Ubuntu 12.04, 14.04

## Development

Pull requests welcome but please also update documentation and tests.
