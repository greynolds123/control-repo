define puppet_enterprise::trapperkeeper::analytics_client_settings(
  String $container,
  Integer $analytics_port = $puppet_enterprise::analytics_port,
  String $analytics_host = $puppet_enterprise::analytics_host,
  String $owner = "pe-${container}",
  String $group = $owner,
) {
  $conf_file = "/etc/puppetlabs/${container}/conf.d/analytics.conf"

  file { $conf_file:
    ensure => present,
    owner  => $owner,
    group  => $group,
    mode   => '0640',
  }

  pe_hocon_setting { "${container}.analytics.url":
    path    => $conf_file,
    setting => 'analytics.url',
    value   => "https://${analytics_host}:${analytics_port}/analytics/v1",
  }
}
