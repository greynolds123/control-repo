define puppet_enterprise::trapperkeeper::pcp_broker(
  $accept_consumers    = 2,
  $delivery_consumers  = 2,
  $controller_uris     = [],
  $container           = $title,
  $user                = "pe-${title}",
  $group               = "pe-${title}",
) {

  $confdir = "/etc/puppetlabs/${container}/conf.d"

  file { "${confdir}/pcp-broker.conf":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
    notify => Service["pe-${container}"],
  }

  Pe_hocon_setting {
    ensure => present,
    notify => Service["pe-${container}"],
  }

  pe_hocon_setting { "${container}.pcp-broker.accept-consumers":
    ensure  => absent,
    path    => "${confdir}/pcp-broker.conf",
    setting => 'pcp-broker.accept-consumers',
  }

  pe_hocon_setting { "${container}.pcp-broker.delivery-consumers":
    ensure  => absent,
    path    => "${confdir}/pcp-broker.conf",
    setting => 'pcp-broker.delivery-consumers',
  }

  pe_hocon_setting { "${container}.pcp-broker.controller-uris":
    path    => "${confdir}/pcp-broker.conf",
    setting => 'pcp-broker.controller-uris',
    type    => 'array',
    value   => $controller_uris,
  }

  pe_hocon_setting { "${container}.pcp-broker.controller-whitelist":
    path    => "${confdir}/pcp-broker.conf",
    setting => 'pcp-broker.controller-whitelist',
    type    => 'array',
    value   => [
      'http://puppetlabs.com/inventory_request',
      'http://puppetlabs.com/rpc_blocking_request',
      'http://puppetlabs.com/rpc_non_blocking_request',
    ],
  }

  Pe_puppet_authorization::Rule {
    path               => "${confdir}/auth.conf",
    match_request_path => '/pcp-broker/send',
    notify             => Service["pe-${container}"],
  }

  pe_puppet_authorization::rule { 'pxp commands':
    match_request_type         => 'path',
    match_request_query_params => {
      'message_type' => [
        'http://puppetlabs.com/rpc_non_blocking_request',
        'http://puppetlabs.com/rpc_blocking_request',
      ],
    },
    allow                      => [
      $puppet_enterprise::console_host,
      $puppet_enterprise::puppet_master_host,
    ],
    sort_order                 => 400,
  }

  # Restrict inventory requests to orchestrator and console
  pe_puppet_authorization::rule { 'inventory request':
    match_request_type         => 'path',
    match_request_query_params => {
      'message_type' => [
        'http://puppetlabs.com/inventory_request',
      ],
    },
    allow                      => [
      $puppet_enterprise::console_host,
      $puppet_enterprise::puppet_master_host,
    ],
    sort_order                 => 400,
  }

  # Deny multicast messages with destination_report; we currently don't
  # use them and they allow for inventory discovery
  pe_puppet_authorization::rule { 'multi-cast with destination_report':
    match_request_type         => 'path',
    match_request_query_params => {
        'targets'              => [
            'pcp://*/agent',
            'pcp://*/*',
        ],
        'destination_report'   => 'true',
    },
    allow                      => [],
    sort_order                 => 399,
  }

  # This is the rule laid down by packaging that we will replace
  pe_puppet_authorization::rule { 'pcp-broker message':
    match_request_type         => 'path',
    match_request_query_params => {
      'message_type'           => [
        'http://puppetlabs.com/associate_request',
        'http://puppetlabs.com/rpc_provisional_response',
        'http://puppetlabs.com/rpc_blocking_response',
        'http://puppetlabs.com/rpc_non_blocking_response',
        'http://puppetlabs.com/rpc_error_message',
      ],
    },
    allow                      => '*',
    sort_order                 => 420,
  }

  # This rule was set in pre-2015.3.1 versions of PE and needs to be cleaned
  pe_puppet_authorization::rule { 'pcp messages':
    ensure => absent,
  }

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg {
    container => $container,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker broker-service":
    namespace => 'puppetlabs.pcp.broker.service',
    service   => 'broker-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker authorization-service":
    namespace => 'puppetlabs.trapperkeeper.services.authorization.authorization-service',
    service   => 'authorization-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker jetty9-service":
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker webrouting-service":
    namespace => 'puppetlabs.trapperkeeper.services.webrouting.webrouting-service',
    service   => 'webrouting-service',
  }

}
