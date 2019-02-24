class { 'puppet_enterprise::profile::puppetdb':
  ca                => 'master.split.local.vm',
  certname          => $::fqdn,
  console           => 'master.split.local.vm',
  database_host     => 'master.split.local.vm',
  database_password => 'Kqv43JKKqY5tLFcH07l9',
  master            => 'master.split.local.vm',
}
