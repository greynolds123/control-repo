class pe_repo::bulk_pluginsync(
  $compile_master_pool_address = pe_pick($pe_repo::compile_master_pool_address,
                                         $pe_repo::master)
){

  $jetty_packages_directory = '/opt/puppetlabs/server/data/packages/public'
  $tarball_location = "${jetty_packages_directory}/bulk_pluginsync.tar.gz"
  $command = "tar --directory /opt/puppetlabs/puppet/cache -czf ${tarball_location} lib; chmod 644 ${tarball_location}"

  cron { 'create tar.gz of pluginsync cache':
    command => $command,
    hour    => '*',
    minute  => fqdn_rand(60),
  }

  exec { 'create tar.gz of pluginsync cache - onetime':
    path    => $facts['path'],
    command => $command,
    creates => $tarball_location,
  }

  file { $tarball_location :
    mode => '0644',
  }
}
