# This class is for managing the configuration file for PuppetDB's Replication
# services.
#
# @param confdir [String] The path to PuppetDB's confdir
# @param peers [Array[Puppet_enterprise::Puppetdb::Sync_peer]] The host, port,
# and sync interval to use for each peer. When this array is empty, sync-related
# settings will be removed from sync.ini.
class puppet_enterprise::puppetdb::sync_ini(
  Array[Puppet_enterprise::Puppetdb::Sync_peer] $peers,
  $confdir = $puppet_enterprise::params::puppetdb_confdir,
) inherits puppet_enterprise::params {
  file { "${confdir}/sync.ini":
    ensure  => present,
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb']
  }

  #Set the defaults
  Pe_ini_setting {
    ensure  => present,
    path    => "${confdir}/sync.ini",
    section => 'sync',
    require => File["${confdir}/sync.ini"],
    notify  => Service['pe-puppetdb']
  }

  $sync_urls = $peers.map |$peer| {
    "https://${peer[host]}:${peer[port]}"
  }

  $sync_intervals = $peers.map |$peer| {
    "${peer[sync_interval_minutes]}m"
  }

  if (pe_size($sync_urls) > 0) {
    pe_ini_setting {'puppetdb_sync_server_urls':
      setting => 'server_urls',
      value   => pe_join($sync_urls, ','),
    }

    pe_ini_setting {'puppetdb_sync_intervals':
      setting => 'intervals',
      value   => pe_join($sync_intervals, ','),
    }
  }
  else {
    pe_ini_setting {'puppetdb_sync_server_urls':
      ensure  => absent,
      setting => 'server_urls',
    }

    pe_ini_setting {'puppetdb_sync_intervals':
      ensure  => absent,
      setting => 'intervals',
    }
  }

}
