class { 'puppet_enterprise::profile::broker':
  activemq_brokername => $::fqdn,
  activemq_brokers    => ['master.split.local.vm'],
  stomp_password      => 'CbrokdGDlC0rq4TkRHiz',
}
