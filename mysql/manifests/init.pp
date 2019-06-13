# This is the mysql class module

  class mysql {
  include mysql::bindings
  include mysql::client
  include mysql::db
  include mysql::params
  include mysql::server
  include mysql::backup::mysqlbackup
  include mysql::backup::mysqldump
  include mysql::backup::xtrabackup
  include mysql::bindings::client_dev
  include mysql::bindings::daemon_dev
  include mysql::bindings::java
  include mysql::bindings::perl
  include mysql::bindings::php
  include mysql::bindings::python
  include mysql::bindings::ruby
  include mysql::client::install
  include mysql::server::account_security
  include mysql::server::backup
  include mysql::server::binarylog
  include mysql::server::config
  include mysql::server::installdb
  include mysql::server::install
  include mysql::server::monitor
  include mysql::server::mysqltuner
  include mysql::server::providers
  include mysql::server::root_password
  include mysql::server::service
}
 
