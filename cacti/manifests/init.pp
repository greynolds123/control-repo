# == Class: cacti
#
# === Authors
#
# Garrett Rowell <garrett2@cnwr.com>
#
# === Description
#
# Class for installing cacti. This module should work if only
# the database_root_pass, database_pass, and managed_services
# are provided. However, if httpd or snmpd are being managed
# by another module, managed_services can be ommitted. All
# other parameters have sane defaults.
#
# === Parameters
#
# ==== Required
#
# [*database_root_pass*]
#   The database password for the root user.
#
# [*database_pass*]
#   The database password used by the cacti user.
#
# ==== Optional
#
# [*cacti_package*]
#   Name of the cacti package to install.
#   Defaults to 'cacti'
#
# [*database_user*]
#   The database user that cacti uses.
#   Defaults to 'cacti'
#
# [*database_host*]
#   The hostname where the database used by cacti is installed.
#   Defaults to 'localhost'
#
# [*database_type*]
#   The type of database used by cacti.
#   Defaults to 'mysql'
#
# [*database_default*]
#   The database used to store cacti information.
#   Defaults to 'cacti'
#
# [*database_port*]
#   The port that the database is listening on.
#   Defaults to '3306'
#
# [*database_ssl*]
#   Use SSL for database communication?
#   Defaults to false
#
# [*managed_services*]
#   The services that this module will nmanage. Unless httpd or snmpd
#     are being managed elsewhere, this should be set to [ 'httpd', 'snmpd' ].
#   Defaults to []
#
class cacti (
  $cacti_package = $::cacti::params::cacti_package,
  $database_root_pass = $::cacti::params::database_root_pass,
  $database_pass = $::cacti::params::database_pass,
  $database_user = $::cacti::params::database_user,
  $database_host = $::cacti::params::database_host,
  $database_type = $::cacti::params::database_type,
  $database_default = $::cacti::params::database_default,
  $database_port = $::cacti::params::database_port,
  $database_ssl = $::cacti::params::database_ssl,
  $managed_services = $::cacti::params::managed_services,

) inherits ::cacti::params {

  validate_string($cacti_package)

  validate_string($database_root_pass)
  if $database_root_pass == undef {
    fail('database_root_pass must be defined')
  }

  validate_string($database_pass)
  if $database_pass == undef {
    fail('database_pass must be defined')
  }

  validate_string($database_user)
  validate_string($database_host)
  validate_string($database_type)
  validate_string($database_default)
  validate_re($database_port,'\d')
  validate_bool($database_ssl)
  validate_array($managed_services)


  include ::cacti::install
  include ::cacti::mysql
  include ::cacti::config
  include ::cacti::service

  anchor { 'cacti::begin': } ->
  Class['cacti::install'] ->
  Class['cacti::mysql'] ->
  Class['cacti::config'] ->
  Class['cacti::service'] ->
  anchor { 'cacti::end': }

}
