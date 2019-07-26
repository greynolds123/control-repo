define puppet_enterprise::trapperkeeper::pcp_broker(
  $accept_consumers    = 2,
  $delivery_consumers  = 2,
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
  }

  pe_hocon_setting { "${container}.pcp-broker.accept-consumers":
    ensure  => present,
    path    => "${confdir}/pcp-broker.conf",
    setting => 'pcp-broker.accept-consumers',
    value   => $accept_consumers,
  }

  pe_hocon_setting { "${container}.pcp-broker.delivery-consumers":
    ensure  => present,
    path    => "${confdir}/pcp-broker.conf",
    setting => 'pcp-broker.delivery-consumers',
    value   => $delivery_consumers,
  }

  file { "${confdir}/authorization.conf":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  $container_auth = "${confdir}/authorization.conf"
  pe_hocon_setting { "${container}.authorization.version":
    ensure  => present,
    path    => $container_auth,
    setting => 'authorization.version',
    value   => 1,
  }

  pe_puppet_authorization::rule { 'pxp commands':
    match_request_path         => '/pcp-broker/send',
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
    path                       => $container_auth,
  }

  # Restrict inventory requests to orchestrator and console
  pe_puppet_authorization::rule { 'inventory request':
    match_request_path         => '/pcp-broker/send',
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
    path                       => $container_auth,
  }

  # Deny multicast messages with destination_report; we currently don't
  # use them and they allow for inventory discovery
  pe_puppet_authorization::rule { 'multi-cast with destination_report':
    match_request_path         => '/pcp-broker/send',
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
    path                       => $container_auth,
  }

  # This is the rule laid down by packaging that we will replace
  pe_puppet_authorization::rule { 'pcp-broker message':
    match_request_path    => '/pcp-broker/send',
    match_request_type    => 'path',
    allow_unauthenticated => true,
    sort_order            => 420,
    path                  => $container_auth,
  }

  # This rule was set in pre-2015.3.1 versions of PE and needs to be cleaned
  pe_puppet_authorization::rule { 'pcp messages':
    ensure => absent,
    path   => $container_auth,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker broker-service":
    container => $container,
    namespace => 'puppetlabs.pcp.broker.service',
    service   => 'broker-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker authorization-service":
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.authorization.authorization-service',
    service   => 'authorization-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker jetty9-service":
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker webrouting-service":
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.webrouting.webrouting-service',
    service   => 'webrouting-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker metrics-service":
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.metrics.metrics-service',
    service   => 'metrics-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:pcp-broker status-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.status.status-service',
    service   => 'status-service',
  }

}
