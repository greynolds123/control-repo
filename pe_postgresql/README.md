pe_postgresql (PE fork of puppetlabs-postgresql)
==========

Table of Contents
-----------------

1. [Overview - What is the PostgreSQL module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with PostgreSQL module](#setup)
    * [PE 3.2 supported module](#pe-3.2-supported-module)
    * [Configuring the server](#configuring-the-server)
4. [Usage - How to use the module for various tasks](#usage)
5. [Upgrading - Guide for upgrading from older revisions of this module](#upgrading)
6. [Reference - The classes, defines,functions and facts available in this module](#reference)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Guide for contributing to the module](#development)
9. [Disclaimer - Licensing information](#disclaimer)
10. [Transfer Notice - Notice of authorship change](#transfer-notice)
11. [Contributors - List of module contributors](#contributors)

Overview
--------

The PostgreSQL module allows you to easily manage Puppet Enterprise's postgres databases with Puppet.
This module aims to be a direct fork of https://github.com/puppetlabs/puppetlabs-postgresql ,
but in a separate PE namespace in order to stop conflicts with that module.

Module Description
-------------------

PostgreSQL is a high-performance, free, open-source relational database server. The postgresql module allows you to manage PostgreSQL packages and services on several operating systems, while also supporting basic management of PostgreSQL databases and users.

Setup
-----

**What puppetlabs-PostgreSQL affects:**

* package/service/configuration files for PostgreSQL
* listened-to ports
* IP and mask (optional)

**Introductory Questions**

The postgresql module offers many security configuration settings. Before getting started, you will want to consider:

* Do you want/need to allow remote connections?
    * If yes, what about TCP connections?
* How restrictive do you want the database superuser's permissions to be?

Your answers to these questions will determine which of the module's parameters you'll want to specify values for.

### PE 3.2 supported module

PE 3.2 introduces Puppet Labs supported modules. The version of the postgresql module that ships within PE 3.2 is supported via normal [Puppet Enterprise support](http://puppetlabs.com/services/customer-support) channels. If you would like to access the [supported module](http://forge.puppetlabs.com/supported) version, you will need to uninstall the shipped module and install the supported version from the Puppet Forge. You can do this by first running

    # puppet module uninstall puppetlabs-postgresql
and then running

    # puppet module install puppetlabs/postgresql

### Configuring the server

The main configuration you'll need to do will be around the `pe_postgresql::server` class. The default parameters are reasonable, but fairly restrictive regarding permissions for who can connect and from where. To manage a PostgreSQL server with sane defaults:

    class { 'pe_postgresql::server': }

For a more customized configuration:

    class { 'pe_postgresql::server':
      ip_mask_deny_postgres_user => '0.0.0.0/32',
      ip_mask_allow_all_users    => '0.0.0.0/0',
      listen_addresses           => '*',
      ipv4acls                   => ['hostssl all johndoe 192.168.0.0/24 cert'],
      postgres_password          => 'TPSrep0rt!',
    }

Once you've completed your configuration of `pe_postgresql::server`, you can test out your settings from the command line:

    $ psql -h localhost -U postgres
    $ psql -h my.postgres.server -U

If you get an error message from these commands, it means that your permissions are set in a way that restricts access from where you're trying to connect. That might be a good thing or a bad thing, depending on your goals.

For more details about server configuration parameters, consult the [PostgreSQL Runtime Configuration docs](http://www.postgresql.org/docs/9.2/static/runtime-config.html).

Usage
-----

### Creating a database

There are many ways to set up a postgres database using the `pe_postgresql::server::db` class. For instance, to set up a database for PuppetDB:

    class { 'pe_postgresql::server': }

    pe_postgresql::server::db { 'mydatabasename':
      user     => 'mydatabaseuser',
      password => pe_postgresql_password('mydatabaseuser', 'mypassword'),
    }

### Managing users, roles and permissions

To manage users, roles and permissions:

    class { 'pe_postgresql::server': }

    pe_postgresql::server::role { 'marmot':
      password_hash => pe_postgresql_password('marmot', 'mypasswd'),
    }

    pe_postgresql::server::database_grant { 'test1':
      privilege => 'ALL',
      db        => 'test1',
      role      => 'marmot',
    }

    pe_postgresql::server::table_grant { 'my_table of test2':
      privilege => 'ALL',
      table     => 'my_table',
      db        => 'test2',
      role      => 'marmot',
    }

In this example, you would grant ALL privileges on the test1 database and on the `my_table` table of the test2 database to the user or group specified by dan.

At this point, you would just need to plunk these database name/username/password values into your PuppetDB config files, and you are good to go.

Upgrading
---------

### Upgrading from 2.x to version 3

*Note:* if you are upgrading for 2.x, you *must* read this, as just about everything has changed.

Version 3 was a major rewrite to fix some internal dependency issues, and to make the new Public API more clear. As a consequence a lot of things have changed for version 3 and older revisions that we will try to outline here.

#### Server specific objects now moved under `pe_postgresql::server::` namespace

To restructure server specific elements under the `pe_postgresql::server::` namespaces the following objects were renamed as such:

* `pe_postgresql::database`       -> `pe_postgresql::server::database`
* `pe_postgresql::database_grant` -> `pe_postgresql::server::database_grant`
* `pe_postgresql::db`             -> `pe_postgresql::server::db`
* `pe_postgresql::grant`          -> `pe_postgresql::server::grant`
* `pe_postgresql::pg_hba_rule`    -> `pe_postgresql::server::pg_hba_rule`
* `pe_postgresql::plperl`         -> `pe_postgresql::server::plperl`
* `pe_postgresql::contrib`        -> `pe_postgresql::server::contrib`
* `pe_postgresql::role`           -> `pe_postgresql::server::role`
* `pe_postgresql::table_grant`    -> `pe_postgresql::server::table_grant`
* `pe_postgresql::tablespace`     -> `pe_postgresql::server::tablespace`

#### New `pe_postgresql::server::config_entry` resource for managing configuration

Previously we used the `file_line` resource to modify `postgresql.conf`. This new revision now adds a new resource named `pe_postgresql::server::config_entry` for managing this file. For example:

    pe_postgresql::server::config_entry { 'check_function_bodies':
      value => 'off',
    }

If you were using `file_line` for this purpose, you should change to this new methodology.

#### `postgresql_puppet_extras.conf` has been removed

Now that we have a methodology for managing `postgresql.conf`, and due to concerns over the file management methodology using an `exec { 'touch ...': }` as a way to create an empty file the existing postgresql\_puppet\_extras.conf file is no longer managed by this module.

If you wish to recreate this methodology yourself, use this pattern:

    class { 'pe_postgresql::server': }

    $extras = "/tmp/include.conf"

    file { $extras:
      content => 'max_connections = 123',
      notify  => Class['pe_postgresql::server::service'],
    }->
    pe_postgresql::server::config_entry { 'include':
      value   => $extras,
    }

#### All uses of the parameter `charset` changed to `encoding`

Since PostgreSQL uses the terminology `encoding` not `charset` the parameter has been made consisent across all classes and resources.

#### The `postgresql` base class is no longer how you set globals

The old global override pattern was less then optimal so it has been fixed, however we decided to demark this properly by specifying these overrides in the class `pe_postgresql::globals`. Consult the documentation for this class now to see what options are available.

Also, some parameter elements have been moved between this and the `pe_postgresql::server` class where it made sense.

#### `config_hash` parameter collapsed for the `pe_postgresql::server` class

Because the `config_hash` was really passing data through to what was in effect an internal class (`pe_postgresql::config`). And since we don't want this kind of internal exposure the parameters were collapsed up into the `pe_postgresql::server` class directly.

#### Lots of changes to 'private' or 'undocumented' classes

If you were using these before, these have changed names. You should only use what is documented in this README.md, and if you don't have what you need you should raise a patch to add that feature to a public API. All internal classes now have a comment at the top indicating them as private to make sure the message is clear that they are not supported as Public API.

#### `pg_hba_conf_defaults` parameter included to turn off default pg\_hba rules

The defaults should be good enough for most cases (if not raise a bug) but if you simply need an escape hatch, this setting will turn off the defaults. If you want to do this, it may affect the rest of the module so make sure you replace the rules with something that continues operation.

#### `pe_postgresql::database_user` has now been removed

Use `pe_postgresql::server::role` instead.

#### `pe_postgresql::psql` resource has now been removed

Use `postgresql_psql` instead. In the future we may recreate this as a wrapper to add extra capability, but it will not match the old behaviour.

#### `postgresql_default_version` fact has now been removed

It didn't make sense to have this logic in a fact any more, the logic has been moved into `pe_postgresql::params`.

#### `ripienaar/concat` is no longer used, instead we use `puppetlabs/concat`

The older concat module is now deprecated and moved into the `puppetlabs/concat` namespace. Functionality is more or less identical, but you may need to intervene during the installing of this package - as both use the same `concat` namespace.

Reference
---------

The postgresql module comes with many options for configuring the server. While you are unlikely to use all of the below settings, they allow you a decent amount of control over your security settings.

Classes:

* [pe_postgresql::client](#class-postgresqlclient)
* [pe_postgresql::globals](#class-postgresqlglobals)
* [pe_postgresql::lib::devel](#class-postgresqllibdevel)
* [pe_postgresql::lib::java](#class-postgresqllibjava)
* [pe_postgresql::lib::perl](#class-postgresqllibperl)
* [pe_postgresql::lib::python](#class-postgresqllibpython)
* [pe_postgresql::server](#class-postgresqlserver)
* [pe_postgresql::server::plperl](#class-postgresqlserverplperl)
* [pe_postgresql::server::contrib](#class-postgresqlservercontrib)
* [pe_postgresql::server::postgis](#class-postgresqlserverpostgis)

Resources:

* [pe_postgresql::server::config_entry](#resource-postgresqlserverconfigentry)
* [pe_postgresql::server::db](#resource-postgresqlserverdb)
* [pe_postgresql::server::database](#resource-postgresqlserverdatabase)
* [pe_postgresql::server::database_grant](#resource-postgresqlserverdatabasegrant)
* [pe_postgresql::server::pg_hba_rule](#resource-postgresqlserverpghbarule)
* [pe_postgresql::server::role](#resource-postgresqlserverrole)
* [pe_postgresql::server::table_grant](#resource-postgresqlservertablegrant)
* [pe_postgresql::server::tablespace](#resource-postgresqlservertablespace)
* [pe_postgresql::validate_db_connection](#resource-postgresqlvalidatedbconnection)

Functions:

* [postgresql\_password](#function-postgresqlpassword)
* [postgresql\_acls\_to\_resources\_hash](#function-postgresqlaclstoresourceshashaclarray-id-orderoffset)


### Class: pe_postgresql::globals
*Note:* most server specific defaults should be overriden in the `pe_postgresql::server` class. This class should only be used if you are using a non-standard OS or if you are changing elements such as `version` or `manage_package_repo` that can only be changed here.

This class allows you to configure the main settings for this module in a global way, to be used by the other classes and defined resources. On its own it does nothing.

For example, if you wanted to overwrite the default `locale` and `encoding` for all classes you could use the following combination:

    class { 'pe_postgresql::globals':
      encoding => 'UTF8',
      locale   => 'en_NG',
    }->
    class { 'pe_postgresql::server':
    }

That would make the `encoding` and `locale` the default for all classes and defined resources in this module.

If you want to use the upstream PostgreSQL packaging, and be specific about the version you wish to download, you could use something like this:

    class { 'pe_postgresql::globals':
      manage_package_repo => true,
      version             => '9.2',
    }->
    class { 'pe_postgresql::server': }

#### `client_package_name`
This setting can be used to override the default postgresql client package name. If not specified, the module will use whatever package name is the default for your OS distro.

#### `server_package_name`
This setting can be used to override the default postgresql server package name. If not specified, the module will use whatever package name is the default for your OS distro.

#### `contrib_package_name`
This setting can be used to override the default postgresql contrib package name. If not specified, the module will use whatever package name is the default for your OS distro.

#### `devel_package_name`
This setting can be used to override the default postgresql devel package name. If not specified, the module will use whatever package name is the default for your OS distro.

#### `java_package_name`
This setting can be used to override the default postgresql java package name. If not specified, the module will use whatever package name is the default for your OS distro.

#### `perl_package_name`
This setting can be used to override the default postgresql Perl package name. If not specified, the module will use whatever package name is the default for your OS distro.

#### `plperl_package_name`
This setting can be used to override the default postgresql PL/perl package name. If not specified, the module will use whatever package name is the default for your OS distro.

#### `python_package_name`
This setting can be used to override the default postgresql Python package name. If not specified, the module will use whatever package name is the default for your OS distro.

#### `service_ensure`
This setting can be used to override the default postgresql service ensure status. If not specified, the module will use `ensure` instead.

#### `service_name`
This setting can be used to override the default postgresql service name. If not specified, the module will use whatever service name is the default for your OS distro.

#### `service_provider`
This setting can be used to override the default postgresql service provider. If not specified, the module will use whatever service provider is the default for your OS distro.

#### `service_status`
This setting can be used to override the default status check command for your PostgreSQL service. If not specified, the module will use whatever service status is the default for your OS distro.

#### `default_database`
This setting is used to specify the name of the default database to connect with. On most systems this will be "postgres".

#### `initdb_path`
Path to the `initdb` command.

#### `createdb_path`
Path to the `createdb` command.

#### `psql_path`
Path to the `psql` command.

#### `pg_hba_conf_path`
Path to your `pg\_hba.conf` file.

#### `postgresql_conf_path`
Path to your `postgresql.conf` file.

#### `pg_hba_conf_defaults`
If false, disables the defaults supplied with the module for `pg\_hba.conf`. This is useful if you disagree with the defaults and wish to override them yourself. Be sure that your changes of course align with the rest of the module, as some access is required to perform basic `psql` operations for example.

#### `datadir`
This setting can be used to override the default postgresql data directory for the target platform. If not specified, the module will use whatever directory is the default for your OS distro.

#### `confdir`
This setting can be used to override the default postgresql configuration directory for the target platform. If not specified, the module will use whatever directory is the default for your OS distro.

#### `bindir`
This setting can be used to override the default postgresql binaries directory for the target platform. If not specified, the module will use whatever directory is the default for your OS distro.

#### `xlogdir`
This setting can be used to override the default postgresql xlog directory. If not specified the module will use initdb's default path.

#### `user`
This setting can be used to override the default postgresql super user and owner of postgresql related files in the file system. If not specified, the module will use the user name 'postgres'.

#### `group`
This setting can be used to override the default postgresql user group to be used for related files in the file system. If not specified, the module will use the group name 'postgres'.

#### `version`
The version of PostgreSQL to install/manage. This is a simple way of providing a specific version such as '9.2' or '8.4' for example.

Defaults to your operating system default.

#### `postgis_version`
The version of PostGIS to install if you install PostGIS. Defaults to the lowest available with the version of PostgreSQL to be installed.

#### `needs_initdb`
This setting can be used to explicitly call the initdb operation after server package is installed and before the postgresql service is started. If not specified, the module will decide whether to call initdb or not depending on your OS distro.

#### `encoding`
This will set the default encoding encoding for all databases created with this module. On certain operating systems this will be used during the `template1` initialization as well so it becomes a default outside of the module as well. Defaults to the operating system default.

#### `locale`
This will set the default database locale for all databases created with this module. On certain operating systems this will be used during the `template1` initialization as well so it becomes a default outside of the module as well. Defaults to `undef` which is effectively `C`.

##### Debian

On Debian you'll need to ensure that the 'locales-all' package is installed for full functionality of Postgres.

#### `manage_package_repo`
If `true` this will setup the official PostgreSQL repositories on your host. Defaults to `false`.

###Class: pe_postgresql::server
The following list are options that you can set in the `config_hash` parameter of `pe_postgresql::server`.

#### `ensure`
This value default to `present`. When set to `absent` it will remove all packages, configuration and data so use this with extreme caution.

#### `postgres_password`
This value defaults to `undef`, meaning the super user account in the postgres database is a user called `postgres` and this account does not have a password. If you provide this setting, the module will set the password for the `postgres` user to your specified value.

#### `package_name`
The name of the package to use for installing the server software. Defaults to the default for your OS distro.

#### `package_ensure`
Value to pass through to the `package` resource when creating the server instance. Defaults to `undef`.

#### `plperl_package_name`
This sets the default package name for the PL/Perl extension. Defaults to utilising the operating system default.

#### `service_name`
This setting can be used to override the default postgresql service name. If not specified, the module will use whatever service name is the default for your OS distro.

#### `service_name`
This setting can be used to override the default postgresql service provider. If not specified, the module will use whatever service name is the default for your OS distro.

#### `service_status`
This setting can be used to override the default status check command for your PostgreSQL service. If not specified, the module will use whatever service name is the default for your OS distro.

#### `default_database`
This setting is used to specify the name of the default database to connect with. On most systems this will be "postgres".

#### `listen_addresses`
This value defaults to `localhost`, meaning the postgres server will only accept connections from localhost. If you'd like to be able to connect to postgres from remote machines, you can override this setting. A value of `*` will tell postgres to accept connections from any remote machine. Alternately, you can specify a comma-separated list of hostnames or IP addresses. (For more info, have a look at the `postgresql.conf` file from your system's postgres package).

#### `port`
This value defaults to `5432`, meaning the postgres server will listen on TCP port 5432. Note that the same port number is used for all IP addresses the server listens on.

#### `ip_mask_deny_postgres_user`
This value defaults to `0.0.0.0/0`. Sometimes it can be useful to block the superuser account from remote connections if you are allowing other database users to connect remotely. Set this to an IP and mask for which you want to deny connections by the postgres superuser account. So, e.g., the default value of `0.0.0.0/0` will match any remote IP and deny access, so the postgres user won't be able to connect remotely at all. Conversely, a value of `0.0.0.0/32` would not match any remote IP, and thus the deny rule will not be applied and the postgres user will be allowed to connect.

#### `ip_mask_allow_all_users`
This value defaults to `127.0.0.1/32`. By default, Postgres does not allow any database user accounts to connect via TCP from remote machines. If you'd like to allow them to, you can override this setting. You might set it to `0.0.0.0/0` to allow database users to connect from any remote machine, or `192.168.0.0/16` to allow connections from any machine on your local 192.168 subnet.

#### `ipv4acls`
List of strings for access control for connection method, users, databases, IPv4 addresses; see [postgresql documentation](http://www.postgresql.org/docs/9.2/static/auth-pg-hba-conf.html) about `pg_hba.conf` for information (please note that the link will take you to documentation for the most recent version of Postgres, however links for earlier versions can be found on that page).

#### `ipv6acls`
List of strings for access control for connection method, users, databases, IPv6 addresses; see [postgresql documentation](http://www.postgresql.org/docs/9.2/static/auth-pg-hba-conf.html) about `pg_hba.conf` for information (please note that the link will take you to documentation for the most recent version of Postgres, however links for earlier versions can be found on that page).

#### `initdb_path`
Path to the `initdb` command.

#### `createdb_path`
Path to the `createdb` command.

#### `psql_path`
Path to the `psql` command.

#### `pg_hba_conf_path`
Path to your `pg\_hba.conf` file.

#### `postgresql_conf_path`
Path to your `postgresql.conf` file.

#### `pg_hba_conf_defaults`
If false, disables the defaults supplied with the module for `pg\_hba.conf`. This is useful if you di
sagree with the defaults and wish to override them yourself. Be sure that your changes of course alig
n with the rest of the module, as some access is required to perform basic `psql` operations for exam
ple.

#### `user`
This setting can be used to override the default postgresql super user and owner of postgresql related files in the file system. If not specified, the module will use the user name 'postgres'.

#### `group`
This setting can be used to override the default postgresql user group to be used for related files in the file system. If not specified, the module will use the group name 'postgres'.

#### `needs_initdb`
This setting can be used to explicitly call the initdb operation after server package is installed and before the postgresql service is started. If not specified, the module will decide whether to call initdb or not depending on your OS distro.

#### `encoding`
This will set the default encoding encoding for all databases created with this module. On certain operating systems this will be used during the `template1` initialization as well so it becomes a default outside of the module as well. Defaults to the operating system default.

#### `locale`
This will set the default database locale for all databases created with this module. On certain operating systems this will be used during the `template1` initialization as well so it becomes a default outside of the module as well. Defaults to `undef` which is effectively `C`.

##### Debian

On Debian you'll need to ensure that the 'locales-all' package is installed for full functionality of Postgres.

#### `manage_pg_hba_conf`
This value defaults to `true`. Whether or not manage the pg_hba.conf. If set to `true`, puppet will overwrite this file. If set to `false`, puppet will not modify the file.


###Class: pe_postgresql::client

This class installs postgresql client software. Alter the following parameters if you have a custom version you would like to install (Note: don't forget to make sure to add any necessary yum or apt repositories if specifying a custom version):

#### `package_name`
The name of the postgresql client package.

#### `package_ensure`
The ensure parameter passed on to postgresql client package resource.


### Class: pe_postgresql::server::contrib
Installs the postgresql contrib package.

#### `package_name`
The name of the postgresql contrib package.

#### `package_ensure`
The ensure parameter passed on to postgresql contrib package resource.

### Class: pe_postgresql::server::postgis
Installs the postgresql postgis packages.

### Class: pe_postgresql::lib::devel
Installs the packages containing the development libraries for PostgreSQL.

#### `package_ensure`
Override for the `ensure` parameter during package installation. Defaults to `present`.

#### `package_name`
Overrides the default package name for the distribution you are installing to. Defaults to `postgresql-devel` or `postgresql<version>-devel` depending on your distro.


### Class: pe_postgresql::lib::java
This class installs postgresql bindings for Java (JDBC). Alter the following parameters if you have a custom version you would like to install (Note: don't forget to make sure to add any necessary yum or apt repositories if specifying a custom version):

#### `package_name`
The name of the postgresql java package.

#### `package_ensure`
The ensure parameter passed on to postgresql java package resource.


### Class: pe_postgresql::lib::perl
This class installs the postgresql Perl libraries. For customer requirements you can customise the following parameters:

#### `package_name`
The name of the postgresql perl package.

#### `package_ensure`
The ensure parameter passed on to postgresql perl package resource.


### Class: pe_postgresql::lib::python
This class installs the postgresql Python libraries. For customer requirements you can customise the following parameters:

#### `package_name`
The name of the postgresql python package.

#### `package_ensure`
The ensure parameter passed on to postgresql python package resource.


### Class: pe_postgresql::server::plperl
This class installs the PL/Perl procedural language for postgresql.

#### `package_name`
The name of the postgresql PL/Perl package.

#### `package_ensure`
The ensure parameter passed on to postgresql PL/Perl package resource.


### Resource: pe_postgresql::server::config\_entry
This resource can be used to modify your `postgresql.conf` configuration file.

Each resource maps to a line inside your `postgresql.conf` file, for example:

    pe_postgresql::server::config_entry { 'check_function_bodies':
      value => 'off',
    }

#### `namevar`
Name of the setting to change.

#### `ensure`
Set to `absent` to remove an entry.

#### `value`
Value for the setting.


### Resource: pe_postgresql::server::db
This is a convenience resource that creates a database, user and assigns necessary permissions in one go.

For example, to create a database called `test1` with a corresponding user of the same name, you can use:

    pe_postgresql::server::db { 'test1':
      user     => 'test1',
      password => 'test1',
    }

#### `namevar`
The namevar for the resource designates the name of the database.

#### `dbname`
The name of the database to be created. Defaults to `namevar`.

#### `user`
User to create and assign access to the database upon creation. Mandatory.

#### `password`
Password for the created user. Mandatory.

#### `encoding`
Override the character set during creation of the database. Defaults to the default defined during installation.

#### `locale`
Override the locale during creation of the database. Defaults to the default defined during installation.

#### `grant`
Grant permissions during creation. Defaults to `ALL`.

#### `tablespace`
The name of the tablespace to allocate this database to. If not specifies, it defaults to the PostgreSQL default.

#### `istemplate`
Define database as a template. Defaults to `false`.


### Resource: pe_postgresql::server::database
This defined type can be used to create a database with no users and no permissions, which is a rare use case.

#### `namevar`
The name of the database to create.

#### `dbname`
The name of the database, defaults to the namevar.

#### `owner`
Name of the database user who should be set as the owner of the database. Defaults to the $user variable set in `pe_postgresql::server` or `pe_postgresql::globals`.

#### `tablespace`
Tablespace for where to create this database. Defaults to the defaults defined during PostgreSQL installation.

#### `encoding`
Override the character set during creation of the database. Defaults to the default defined during installation.

#### `locale`
Override the locale during creation of the database. Defaults to the default defined during installation.

#### `istemplate`
Define database as a template. Defaults to `false`.


###Resource: pe_postgresql::server::database\_grant
This defined type manages grant based access privileges for users, wrapping the `pe_postgresql::server::database_grant` for database specific permissions. Consult the PostgreSQL documentation for `grant` for more information.

#### `namevar`
Used to uniquely identify this resource, but functionality not used during grant.

#### `privilege`
Can be one of `SELECT`, `TEMPORARY`, `TEMP`, `CONNECT`. `ALL` is used as a synonym for `CREATE`. If you need to add multiple privileges, a space delimited string can be used.

#### `db`
Database to grant access to.

#### `role`
Role or user whom you are granting access for.

#### `psql_db`
Database to execute the grant against. This should not ordinarily be changed from the default, which is `postgres`.

#### `psql_user`
OS user for running `psql`. Defaults to the default user for the module, usually `postgres`.


### Resource: pe_postgresql::server::pg\_hba\_rule
This defined type allows you to create an access rule for `pg_hba.conf`. For more details see the [PostgreSQL documentation](http://www.postgresql.org/docs/8.2/static/auth-pg-hba-conf.html).

For example:

    pe_postgresql::server::pg_hba_rule { 'allow application network to access app database':
      description => "Open up postgresql for access from 200.1.2.0/24",
      type => 'host',
      database => 'app',
      user => 'app',
      address => '200.1.2.0/24',
      auth_method => 'md5',
    }

This would create a ruleset in `pg_hba.conf` similar to:

    # Rule Name: allow application network to access app database
    # Description: Open up postgresql for access from 200.1.2.0/24
    # Order: 150
    host  app  app  200.1.2.0/24  md5

#### `namevar`
A unique identifier or short description for this rule. The namevar doesn't provide any functional usage, but it is stored in the comments of the produced `pg_hba.conf` so the originating resource can be identified.

#### `description`
A longer description for this rule if required. Defaults to `none`. This description is placed in the comments above the rule in `pg_hba.conf`.

#### `type`
The type of rule, this is usually one of: `local`, `host`, `hostssl` or `hostnossl`.

#### `database`
A comma separated list of databases that this rule matches.

#### `user`
A comma separated list of database users that this rule matches.

#### `address`
If the type is not 'local' you can provide a CIDR based address here for rule matching.

#### `auth_method`
The `auth_method` is described further in the `pg_hba.conf` documentation, but it provides the method that is used for authentication for the connection that this rule matches.

#### `auth_option`
For certain `auth_method` settings there are extra options that can be passed. Consult the PostgreSQL `pg_hba.conf` documentation for further details.

#### `order`
An order for placing the rule in `pg_hba.conf`. Defaults to `150`.

#### `target`
This provides the target for the rule, and is generally an internal only property. Use with caution.


### Resource: pe_postgresql::server::role
This resource creates a role or user in PostgreSQL.

#### `namevar`
The role name to create.

#### `password_hash`
The hash to use during password creation. If the password is not already pre-encrypted in a format that PostgreSQL supports, use the `pe_postgresql_password` function to provide an MD5 hash here, for example:

    pe_postgresql::role { "myusername":
      password_hash => pe_postgresql_password('myusername', 'mypassword'),
    }

#### `createdb`
Whether to grant the ability to create new databases with this role. Defaults to `false`.

#### `createrole`
Whether to grant the ability to create new roles with this role. Defaults to `false`.

#### `login`
Whether to grant login capability for the new role. Defaults to `false`.

#### `inherit`
Whether to grant inherit capability for the new role. Defaults to `true`.

#### `superuser`
Whether to grant super user capability for the new role. Defaults to `false`.

#### `replication`
If `true` provides replication capabilities for this role. Defaults to `false`.

#### `connection_limit`
Specifies how many concurrent connections the role can make. Defaults to `-1` meaning no limit.

#### `username`
The username of the role to create, defaults to `namevar`.


### Resource: pe_postgresql::server::table\_grant
This defined type manages grant based access privileges for users. Consult the PostgreSQL documentation for `grant` for more information.

#### `namevar`
Used to uniquely identify this resource, but functionality not used during grant.

#### `privilege`
Can be one of `SELECT`, `INSERT`, `UPDATE`, `REFERENCES`. `ALL` is used as a synonym for `CREATE`. If you need to add multiple privileges, a space delimited string can be used.

#### `table`
Table to grant access on.

#### `db`
Database of table.

#### `role`
Role or user whom you are granting access for.

#### `psql_db`
Database to execute the grant against. This should not ordinarily be changed from the default, which is `postgres`.

#### `psql_user`
OS user for running `psql`. Defaults to the default user for the module, usually `postgres`.


### Resource: pe_postgresql::server::tablespace
This defined type can be used to create a tablespace. For example:

    pe_postgresql::tablespace { 'tablespace1':
      location => '/srv/space1',
    }

It will create the location if necessary, assigning it the same permissions as your
PostgreSQL server.

#### `namevar`
The tablespace name to create.

#### `location`
The path to locate this tablespace.

#### `owner`
The default owner of the tablespace.

#### `spcname`
Name of the tablespace. Defaults to `namevar`.


### Resource: pe_postgresql::validate\_db\_connection
This resource can be utilised inside composite manifests to validate that a client has a valid connection with a remote PostgreSQL database. It can be ran from any node where the PostgreSQL client software is installed to validate connectivity before commencing other dependent tasks in your Puppet manifests, so it is often used when chained to other tasks such as: starting an application server, performing a database migration.

Example usage:

    pe_postgresql::validate_db_connection { 'validate my postgres connection':
      database_host           => 'my.postgres.host',
      database_username       => 'mydbuser',
      database_password       => 'mydbpassword',
      database_name           => 'mydbname',
    }->
    exec { 'rake db:migrate':
      cwd => '/opt/myrubyapp',
    }

#### `namevar`
Uniquely identify this resource, but functionally does nothing.

#### `database_host`
The hostname of the database you wish to test. Defaults to 'undef' which generally uses the designated local unix socket.

#### `database_port`
Port to use when connecting. Default to 'undef' which generally defaults to 5432 depending on your PostgreSQL packaging.

#### `database_name`
The name of the database you wish to test. Defaults to 'postgres'.

#### `database_username`
Username to connect with. Defaults to 'undef', which when using a unix socket and ident auth will be the user you are running as. If the host is remote you must provide a username.

#### `database_password`
Password to connect with. Can be left blank, but that is not recommended.

#### `run_as`
The user to run the `psql` command with for authenticiation. This is important when trying to connect to a database locally using Unix sockets and `ident` authentication. It is not needed for remote testing.

#### `sleep`
Upon failure, sets the number of seconds to sleep for before trying again.

#### `tries`
Upon failure, sets the number of attempts before giving up and failing the resource.

#### `create_db_first`
This will ensure the database is created before running the test. This only really works if your test is local. Defaults to `true`.


### Function: postgresql\_password
If you need to generate a postgres encrypted password, use `pe_postgresql_password`. You can call it from your production manifests if you don't mind them containing the clear text versions of your passwords, or you can call it from the command line and then copy and paste the encrypted password into your manifest:

    $ puppet apply --execute 'notify { "test": message => pe_postgresql_password("username", "password") }'

### Function: postgresql\_acls\_to\_resources\_hash(acl\_array, id, order\_offset)
This internal function converts a list of `pg_hba.conf` based acls (passed in as an array of strings) to a format compatible with the `pe_postgresql::pg_hba_rule` resource.

**This function should only be used internally by the module**.

Limitations
------------

Works with versions of PostgreSQL from 8.1 through 9.2.

Current it is only actively tested with the following operating systems:

* Debian 6.x and 7.x
* Centos 5.x, 6.x, and 7.x.
* Ubuntu 10.04 and 12.04, 14.04

Although patches are welcome for making it work with other OS distros, it is considered best effort.

### Postgis support

Postgis is currently considered an unsupported feature as it doesn't work on
all platforms correctly.

### All versions of RHEL/Centos

If you have selinux enabled you must add any custom ports you use to the postgresql_port_t context.  You can do this as follows:

```
# semanage port -a -t postgresql_port_t -p tcp $customport
```

Development
------------

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can't access the huge number of platforms and myriad of hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

You can read the complete module contribution guide [on the Puppet Labs wiki.](http://projects.puppetlabs.com/projects/module-site/wiki/Module_contributing)

### Tests

Please see the testing information in the top level [README](../../README.md) on how to use Frankenbuilder and RSpec on your changes.

The unit tests are ran in Travis-CI as well, if you want to see the results of your own tests regsiter the service hook through Travis-CI via the accounts section for your Github clone of this project.


Transfer Notice
----------------

This Puppet module was originally authored by Inkling Systems. The maintainer preferred that Puppet Labs take ownership of the module for future improvement and maintenance as Puppet Labs is using it in the PuppetDB module.  Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Inkling.

Previously: [https://github.com/inkling/puppet-postgresql](https://github.com/inkling/puppet-postgresql)

Contributors
------------

 * Andrew Moon
 * [Kenn Knowles](https://github.com/kennknowles) ([@kennknowles](https://twitter.com/KennKnowles))
 * Adrien Thebo
 * Albert Koch
 * Andreas Ntaflos
 * Bret Comnes
 * Brett Porter
 * Chris Price
 * dharwood
 * Etienne Pelletier
 * Florin Broasca
 * Henrik
 * Hunter Haugen
 * Jari Bakken
 * Jordi Boggiano
 * Ken Barber
 * nzakaria
 * Richard Arends
 * Spenser Gilliland
 * stormcrow
 * William Van Hevelingen
