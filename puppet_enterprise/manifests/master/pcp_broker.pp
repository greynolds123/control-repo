class puppet_enterprise::master::pcp_broker(
  Array[String] $orchestrator_hosts,
  $orchestrator_port       = $puppet_enterprise::orchestrator_port,
  $ssl_listen_address      = $puppet_enterprise::params::ssl_address,
  Integer $ssl_listen_port = $puppet_enterprise::pcp_broker_port,
  Array[String] $ssl_protocols = $puppet_enterprise::ssl_protocols,
) inherits puppet_enterprise {
  $container = 'puppetserver'
  $confdir = "/etc/puppetlabs/${container}/conf.d"
  Pe_hocon_setting {
    ensure => present,
    path   => "${confdir}/webserver.conf",
    notify => Service["pe-${container}"],
  }

  puppet_enterprise::trapperkeeper::webserver_settings { 'pcp-broker' :
    container          => $container,
    ssl_listen_address => $ssl_listen_address,
    ssl_listen_port    => $ssl_listen_port,
    ssl_protocols      => $ssl_protocols,
  }

  pe_hocon_setting { "${container}.web-router-service.broker-service":
    path    => "/etc/puppetlabs/${container}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.pcp.broker.service/broker-service"',
    value   => {
      'v1'       => {
        'route'  => '/pcp',
        'server' => 'pcp-broker',
      },
      'v2'       => {
        'route'  => '/pcp2',
        'server' => 'pcp-broker',
      },
      'metrics'  => {
        'route'  => '/',
        'server' => 'pcp-broker',
      },
    },
  }

  puppet_enterprise::trapperkeeper::pcp_broker { $container:
    controller_uris    => $orchestrator_hosts.map |$host| { "wss://${host}:${orchestrator_port}/server" },
    user               => 'pe-puppet',
    group              => 'pe-puppet',
  }
}
