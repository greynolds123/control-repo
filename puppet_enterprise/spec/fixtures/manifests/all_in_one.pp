node 'all_in_one' {
  class {'puppet_enterprise':
    certificate_authority_host   => 'ca.rspec',
    puppet_master_host           => 'master.rspec',
    console_host                 => 'console.rspec',
    puppetdb_host                => 'puppetdb.rspec',
    database_host                => 'database.rspec',
    mcollective_middleware_hosts => ['mco.rspec'],
    pcp_broker_host              => 'pcp_broker.rspec',
  }

  class { puppet_enterprise::profile::master: }
  class { puppet_enterprise::profile::amq::broker: }
  class { puppet_enterprise::profile::mcollective::peadmin: }
  class { puppet_enterprise::profile::orchestrator: }
  class { puppet_enterprise::profile::certificate_authority: }
  class { puppet_enterprise::profile::database: }
  class { puppet_enterprise::profile::puppetdb: }
  class { puppet_enterprise::profile::console: }
  class { puppet_enterprise::profile::agent: }
  class { puppet_enterprise::profile::mcollective::agent: }

}
