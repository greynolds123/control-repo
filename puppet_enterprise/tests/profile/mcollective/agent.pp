class { 'puppet_enterprise::profile::mcollective::agent':
  stomp_password   => 'CbrokdGDlC0rq4TkRHiz',
  activemq_brokers => ['master.split.local.vm', 'dev.local.vm']
}

