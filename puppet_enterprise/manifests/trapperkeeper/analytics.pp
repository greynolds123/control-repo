class puppet_enterprise::trapperkeeper::analytics (
  String $container,
  String $datadir              = '/opt/puppetlabs/server/data/analytics/',
) inherits puppet_enterprise::params {
  include puppet_enterprise::packages

  $confdir = "/etc/puppetlabs/${container}"

  file { $datadir:
    ensure => directory,
    mode   => '0640',
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'analytics-service':
    container => $container,
    namespace => 'puppetlabs.analytics.service',
  }

  Pe_hocon_setting {
    ensure => present,
    require => Package["pe-${container}"],
    notify => Service["pe-${container}"],
  }

  pe_hocon_setting { "${container}.webserver.analytics":
    ensure => absent,
    path => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.analytics',
  }

  puppet_enterprise::trapperkeeper::analytics_client_settings { $container:
    container => $container,
    owner => 'pe-puppet',
  }

  $analytics_conf = "${confdir}/conf.d/analytics.conf"

  pe_hocon_setting { 'analytics.data-directory':
    path    => $analytics_conf,
    setting => 'analytics.data-directory',
    value   => $datadir,
  }

  $product_conf = "${confdir}/conf.d/product.conf"
  file { $product_conf:
    ensure => present,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
  }


  pe_hocon_setting { 'product.version-path':
    path => $product_conf,
    setting => 'product.version-path',
    value => "${puppet_enterprise::puppet_server_dir}/pe_version",
  }

  pe_hocon_setting { 'product.name':
    path => $product_conf,
    setting => 'product.name',
    value => { "artifact-id" => "pe-master",
               "group-id"    => "puppetlabs.packages" },
  }

  $web_routes_conf = "${confdir}/conf.d/web-routes.conf"
  $web_router_section = 'web-router-service."puppetlabs.analytics.service/analytics-service"'

  pe_hocon_setting { $web_router_section:
    path    => $web_routes_conf,
    setting => $web_router_section,
    value   => '/analytics/v1',
  }
}
