# This class is for setting up the PuppetDB configuration file
#
# @param database_host [String] The hostname of the database that PuppetDB will
#        be running on
# @param confdir [String] The path to PuppetDB's confdir
# @param database_name [String] The name of the PuppetDB Database
# @param database_password [String] The password of the user
# @param database_port [Integer] The port that the database is running on
# @param database_properties [String] A url encoded string of JDBC options. This will replace the
#        default database property string which enables SSL connections.
# @param database_user [String] The user logging into the database
# @param gc_interval The interval, in minutes, at which garbage collection should occur
# @param node_purge_ttl [String] The amount of time that must elapse before a
#        deactivated node is purged from PuppetDB
# @param node_ttl [String] The amount of time that must elapse before a node is
#        deactivated from PuppetDB
# @param report_ttl [String] The amount of time that must elapse before a report is deleted
# @param write_maximum_pool_size [Integer] this value will determine the maximum number
#        of actual connections to the database backend for write connections
class puppet_enterprise::puppetdb::database_ini(
  $database_host,
  $database_port,
  Integer $write_maximum_pool_size,
  $confdir                    = $puppet_enterprise::params::puppetdb_confdir,
  $database_name              = $puppet_enterprise::params::puppetdb_database_name,
  Optional[String[1]] $database_password = undef,
  $database_properties        = '',
  $database_user              = $puppet_enterprise::params::puppetdb_database_user,
  Variant[Pattern[/^[0-9]+$/],Integer] $gc_interval = $puppet_enterprise::params::puppetdb_gc_interval,
  Optional[String] $node_purge_ttl = undef,
  $node_ttl                   = $puppet_enterprise::params::puppetdb_node_ttl,
  $report_ttl                 = $puppet_enterprise::params::puppetdb_report_ttl,
  Array[String] $facts_blacklist = [],
  Enum['literal','regex'] $facts_blacklist_type = 'literal',
) inherits puppet_enterprise::params {
  include puppet_enterprise::packages

  $section = 'database'
  $config_file = "${confdir}/${section}.ini"

  puppet_enterprise::puppetdb::shared_database_settings { $section :
    confdir             => $confdir,
    database_host       => $database_host,
    database_name       => $database_name,
    database_password   => $database_password,
    database_port       => 0 + $database_port,
    database_user       => $database_user,
    database_properties => $database_properties,
    maximum_pool_size   => $write_maximum_pool_size,
  }

  #Set the defaults
  Pe_ini_setting {
    path    => $config_file,
    ensure  => present,
    section => $section,
    require => File[$config_file]
  }

  #Write Database Only Settings
  pe_ini_setting {'puppetdb_gc_interval':
    setting => 'gc-interval',
    value   => $gc_interval,
  }

  pe_ini_setting {'puppetdb_node_ttl':
    setting => 'node-ttl',
    value   => $node_ttl,
  }

  $node_purge_ttl_ensure = pe_empty($node_purge_ttl) ? {
    false => 'present',
    true  => 'absent',
  }

  pe_ini_setting {'puppetdb_node_purge_ttl':
    ensure  => $node_purge_ttl_ensure,
    setting => 'node-purge-ttl',
    value   => $node_purge_ttl,
  }

  pe_ini_setting {'puppetdb_report_ttl':
    setting => 'report-ttl',
    value   => $report_ttl,
  }

  $joined_facts_blacklist = pe_join($facts_blacklist, ',')

  pe_ini_setting {'puppetdb_facts_blacklist':
    setting => 'facts-blacklist',
    value   => $joined_facts_blacklist,
  }

  pe_ini_setting {'puppetdb_facts_blacklist_type':
    setting => 'facts-blacklist-type',
    value   => $facts_blacklist_type,
  }
}
