# cacti

[![Build Status](https://travis-ci.org/garrettrowell/puppet-cacti.svg?branch=master)](https://travis-ci.org/cnwrinc/cnwr-cacti)
[![Coverage Status](https://coveralls.io/repos/garrettrowell/puppet-cacti/badge.svg?branch=master&service=github)](https://coveralls.io/github/cnwrinc/cnwr-cacti?branch=master)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with cacti](#setup)
    * [What cacti affects](#what-cacti-affects)
      * [Installed Packages](#installed-packages)
      * [Managed Services](#managed-services)
      * [Managed Files](#managed-files)
    * [Beginning with cacti](#beginning-with-cacti)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Release Notes - Changelog](#release-notes)

## Overview

Installs Cacti and manages all of its dependencies.

## Module Description

The Cacti module installs, configures, and manages all of Cacti's dependencies.

Uses the [puppetlabs-mysql](https://github.com/puppetlabs/puppetlabs-mysql) module to install, manage, and configure mariadb for use with cacti.

Uses [rmueller-cron](https://github.com/roman-mueller/rmueller-cron) to manage /etc/cron.d/cacti.


## Setup

### What cacti affects

#### Installed Packages

* httpd
* mariadb-server
* php-mysql
* php-pdo
* php-common
* php
* php-cli
* php-snmp
* net-snmp-utils
* net-snmp-libs
* rrdtool

#### Managed Services

* httpd
* mariadb
* snmpd

#### Managed Files
* `/etc/cacti/db.php`
* `/etc/httpd/conf.d/cacti.conf`
* `/etc/cron.d/cacti`

### Beginning with cacti
To get started using the cacti module with default settings use:

`include ::cacti`

However, the following NEED to be defined in hiera since no defaults are provided:

* `cacti::database_root_pass`

* `cacti::database_pass`

* `cacti::managed_services`

Alternatively, if hiera is not available you can pass in the parameters directly:
```puppet
class { '::cacti':
  database_root_pass => 'yourpass',
  database_pass => 'yourpass',
  managed_services => [ 'httpd', 'snmpd' ],
}
```
## Usage

The following can be changed from their defaults by specifying values either in hiera or by passing them in as parameters:

* `cacti::cacti_package` - Cacti's package name - DEFAULTS to "cacti"

* `cacti::database_root_pass` - The database password for the root user

* `cacti::database_type` - The type of database used - DEFAULTS to "mysql"

* `cacti::database_default` - The database used by cacti - DEFAULTS to "cacti"

* `cacti::database_host` - The hostname where the database in installed - DEFAULTS to "localhost"

* `cacti::database_user` - The database user that cacti uses - DEFAULTS to "cacti"

* `cacti::database_pass` - The database password for the cacti user

* `cacti::database_port` - The port that the database is listening on - DEFAULTS to "3306"

* `cacti::database_ssl` - Use SSL for database communication - DEFAULTS to "false"

* `cacti::managed_services` - The services that this module will manage. Unless being managed elsewhere, you should define this as => [ 'httpd, 'snmpd' ]

### Parameter example
```puppet
class { '::cacti':
  cacti_package => 'cacti',
  database_root_pass => 'yourpass',
  database_pass => 'yourpass',
  database_type => 'mysql',
  database_default => 'cacti',
  database_host => 'localhost',
  database_user => 'cacti',
  database_port => '3306',
  database_ssl => false,
  managed_services => [ 'httpd', 'snmpd' ],
}
```

## Limitations

Currently only the following Operating Systems are supported:

* RHEL 7
* CentOS 7

## Development

If you wish to contribute to this module please either add an [issue](https://github.com/cnwrinc/cnwr-cacti/issues) or better yet submit a [Pull Request](https://github.com/cnwrinc/cnwr-cacti/pulls)

## Release Notes

### Version 0.0.1
* create the module

### Version 0.0.2
* add testing and prepare for the forge
