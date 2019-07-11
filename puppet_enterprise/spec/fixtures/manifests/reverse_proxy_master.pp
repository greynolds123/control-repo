node 'reverse_proxy_master' {
  class {'puppet_enterprise':
    certificate_authority_host   => 'ca.rspec',
    puppet_master_host           => 'master.rspec',
    console_host                 => 'console.rspec',
    puppetdb_host                => 'puppetdb.rspec',
    database_host                => 'database.rspec',
    mcollective_middleware_hosts => ['mco.rspec'],
    pcp_broker_host              => 'pcp_broker.rspec',
  }

  class { 'puppet_enterprise::profile::master':
    console_host            => 'console.rspec',
    puppetdb_host           => 'puppetdb.rspec',
    console_server_certname => 'console.rspec',
    ca_host                 => 'master.rspec',
    enable_ca_proxy         => true,
  }
}
