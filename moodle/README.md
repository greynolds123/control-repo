# moodle

#### Table of Contents

1. [Overview](#overview)
1. [Requirements](#requirements)
1. [Usage](#usage)
1. [Example Usage](#example_usage)
1. [Limitations](#limitations)
1. [Links](#links)

## Overview

This module installs and configures a Moodle instance.

## Requirements
This module have some external dependencies:

* PHP 5.4 or higher -- this is a Moodle 3.x requirement. Installing on Ubuntu 14.04 will have this dependency
* Apache Webserver
* MySQL Database

## Usage

To manage a Moodle instance, use the `moodle` class.

~~~
	class { 'moodle':
		<<params>>
	}
~~~

Available parameters are:

* `install_dir`    - directory where the Moodle distribution will be extracted. Since Moodle distributions contain the `moodle` root folder, this directory should end with /moodle. For example `/opt/www/moodle`. The parent directory must already exist on the node.
* `download_base`  - the base URL for downloading the Moodle distribution. Defaults to `https://download.moodle.org/download.php/direct/stable30`.
* `moodle_version` - the version of Moodle to download. Defaults to `3.0.1`.
* `default_lang`   - The default language setting for Moodle. Defaults to `en`.
* `wwwrooturl`     - The root URL for the Moodle web site. Defaults to `http://$::fqdn`.
* `www_owner`      - The OS user that will own the Moodle base directories (web and data).
* `www_group`      - The OS group that will own the Moodle base directories (web and data).
* `dataroot`       - The Moodle data directory. Defaults to `/opt/moodledata`.
* `create_db`      - A boolean indicating whether or not the module should manage the database. Defaults to `true`.
* `create_db_user` - A boolean indicating whether or not the module should manage the database user. Defaults to `true`.
* `dbtype`         - The database type to use. Currently, only MySQL databases are supported, so `mysqli` is the default (and only supported) value. This will change once PostgreSQL support is added.
* `dbhost`         - Hostname for the database server. Defaults to `localhost`.
* `dbname`         - The database name for the Moodle data. Defaults to `moodle`.
* `dbuser`         - The database username. Defaults to `root`.
* `dbpass`         - The database password. Defaults to empty string.
* `dbport`         - The TCP/IP port for the database server. Defaults to `3306` (the MySQL default)
* `dbsocket`       - 
* `prefix`         - Table prefix for Moodle-related tables. Defaults to `mdl_`.
* `fullname`       - The full name for the Moodle site.
* `shortname`      - The short name for the Moodle site.
* `summary`        - A summary description for the Moodle site.
* `adminuser`      - The Moodle administrative user. Defaults to `admin`.
* `adminpass`      - The Moodle administrator's password. Defaults to `adminpass`.
* `adminemail`     - The Moodle administrator's email address. Defaults to `admin@example.com`.
  
## Example Usage

Note: this module only manages moodle. It does not manage the underlying database server or web server.

For example, to install moodle into /opt/moodle and use Apache
and MySQL, you could create a profile such as:

~~~
$install_dir = '/opt/moodle'
class { 'apache':
  mpm_module => 'prefork',
}
class { 'apache::mod::php': }
class { 'mysql::server': }
class { 'mysql::bindings': php_enable => true, }
apache::vhost { $::fqdn:
  docroot        => $install_dir,
  manage_docroot => false,
  port           => '80',
}
class { 'moodle':
  install_dir => $install_dir,
  dbtype      => $dbtype,
  dbuser      => 'moodleuser',
  dbpass      => 'moodleP@ss',
  fullname    => 'Test Moodle Site',
  shortname   => 'Test',
  summary     => 'A moodle test site created via beaker',
  adminuser   => 'moodleadmin',
  adminpass   => 'adminP@ss',
  adminemail  => 'admin@host.com',
  require     => Class['mysql::server', 'apache::mod::php'],
}
~~~

This example assumes that one is using the puppetlabs/apache and puppetlabs/mysql modules.

## Limitations

Currently only MySQL is supported for a database. PHP 5.4 or higher is also required (a Moodle 3.x requirement).

## Links
For Moodle adminstration, please consult the official Moodle documentation:

[Moodle Install Guide](https://docs.moodle.org/30/en/Installation_quick_guide)

