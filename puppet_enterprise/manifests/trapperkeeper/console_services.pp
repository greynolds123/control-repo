define puppet_enterprise::trapperkeeper::console_services(
  $activity_host,
  $puppetdb_host,
  $master_host,
  $classifier_host,
  $rbac_host,
  $status_proxy_enabled,
  String $pcp_broker_host,
  Integer $pcp_broker_port,
  $service_alert_timeout,
  $activity_port         = $puppet_enterprise::params::console_services_api_listen_port,
  $activity_url_prefix   = $puppet_enterprise::params::activity_url_prefix,
  $classifier_port       = $puppet_enterprise::params::console_services_api_listen_port,
  $classifier_url_prefix = $puppet_enterprise::params::classifier_url_prefix,
  $client_certname       = $puppet_enterprise::console_host,
  $container             = $title,
  $group                 = "pe-${title}",
  $localcacert           = $puppet_enterprise::params::localcacert,
  $proxy_idle_timeout    = 60,
  $puppetdb_port         = $puppet_enterprise::params::puppetdb_ssl_listen_port,
  $rbac_port             = $puppet_enterprise::params::console_services_api_listen_port,
  $rbac_url_prefix       = $puppet_enterprise::params::rbac_url_prefix,
  $user                  = "pe-${title}",
  Integer $pcp_timeout   = 5,
  Boolean $display_local_time = false,
) {

  $cert_dir = "${puppet_enterprise::server_data_dir}/${container}/certs"
  $ssl_key = "${cert_dir}/${client_certname}.private_key.pem"
  $ssl_cert =  "${cert_dir}/${client_certname}.cert.pem"

  $license_key_path = $puppet_enterprise::license_key_path

  Pe_hocon_setting {
    ensure  => present,
    notify  => Service["pe-${container}"],
  }

  # Uses
  #   $ssl_key
  #   $ssl_cert
  #   $license_key_path
  #   $localcacert
  #   $puppetdb
  #   $puppetdb_port
  #   $master_host
  #   $rbac
  #   $rbac_port
  #   $rbac_url_prefix
  #   $classifier
  #   $classifier_port
  #   $classifier_url_prefix
  #   $activity
  #   $activity_port
  #   $activity_url_prefix
  #   $proxy_idle_timeout
  #   $display_local_time
  file { "/etc/puppetlabs/${container}/conf.d/console.conf":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  pe_hocon_setting { "${container}.console.assets-dir":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.assets-dir',
    value   => 'dist',
  }
  pe_hocon_setting { "${container}.console.puppet-master":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.puppet-master',
    value   => "https://${master_host}:8140",
  }
  pe_hocon_setting { "${container}.console.rbac-server":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.rbac-server',
    value   => "http://${rbac_host}:${rbac_port}${rbac_url_prefix}",
  }
  pe_hocon_setting { "${container}.console.classifier-server":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.classifier-server',
    value   => "http://${classifier_host}:${classifier_port}${classifier_url_prefix}",
  }
  pe_hocon_setting { "${container}.console.activity-server":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.activity-server',
    value   => "http://${activity_host}:${activity_port}${activity_url_prefix}",
  }
  pe_hocon_setting { "${container}.console.display-local-time":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.display-local-time',
    value   => $display_local_time,
  }

  # For PuppetDB HA, a user may pass in an Array to specify their PuppetDBs
  $first_puppetdb_host = pe_any2array($puppetdb_host)[0]
  $first_puppetdb_port = pe_any2array($puppetdb_port)[0]
  pe_hocon_setting { "${container}.console.puppetdb-server":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.puppetdb-server',
    value   => "https://${first_puppetdb_host}:${first_puppetdb_port}",
  }
  pe_hocon_setting { "${container}.console.certs.ssl-key":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.certs.ssl-key',
    value   => $ssl_key,
  }
  pe_hocon_setting { "${container}.console.certs.ssl-cert":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.certs.ssl-cert',
    value   => $ssl_cert,
  }
  pe_hocon_setting { "${container}.console.certs.ssl-ca-cert":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.certs.ssl-ca-cert',
    value   => $localcacert,
  }

  if $proxy_idle_timeout and $proxy_idle_timeout != '' {
    pe_validate_single_integer($proxy_idle_timeout)
    $proxy_idle_timeout_ensure = present
  } else {
    $proxy_idle_timeout_ensure = absent
  }

  pe_hocon_setting { "${container}.console.proxy-idle-timeout":
    ensure  => $proxy_idle_timeout_ensure,
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.proxy-idle-timeout',
    value   => $proxy_idle_timeout,
  }

  pe_hocon_setting { "${container}.console.license-key":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => 'console.license-key',
    value   => $license_key_path,
  }

  pe_hocon_setting { "${container}.console.pcp-broker-url":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.pcp-broker-url",
    value   => "wss://${pcp_broker_host}:${pcp_broker_port}/pcp/"
  }

  pe_hocon_setting { "${container}.console.certs.pcp-ssl-key":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.certs.pcp-ssl-key",
    value   => $ssl_key
  }

  pe_hocon_setting { "${container}.console.certs.pcp-ssl-cert":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.certs.pcp-ssl-cert",
    value   => $ssl_cert
  }

  pe_hocon_setting { "${container}.console.certs.pcp-ssl-ca-cert":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.certs.pcp-ssl-ca-cert",
    value   => $localcacert
  }

  pe_hocon_setting { "${container}.console.pcp-client-type":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.pcp-client-type",
    value   => "console"
  }

  pe_hocon_setting { "${container}.console.pcp-request-timeout":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.pcp-request-timeout",
    value   => $pcp_timeout,
  }

  # Service Alert configuration
  pe_hocon_setting { "${container}.console.service-alert":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.service-alert",
    value   => [],
    type    => 'array',
  }

  pe_hocon_setting { "${container}.console.service-alert.activity":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.service-alert",
    value   => {'url' => "http://${activity_host}:${activity_port}", 'type' => 'activity'},
    type    => 'array_element',
    require => Pe_hocon_setting["${container}.console.service-alert"],
  }

  pe_hocon_setting { "${container}.console.service-alert.classifier":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.service-alert",
    value   => {'url' => "http://${classifier_host}:${classifier_port}", 'type' => 'classifier'},
    type    => 'array_element',
    require => Pe_hocon_setting["${container}.console.service-alert"],
  }

  pe_hocon_setting { "${container}.console.service-alert.rbac":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.service-alert",
    value   => {'url' => "http://${rbac_host}:${rbac_port}", 'type' => 'rbac'},
    type    => 'array_element',
    require => Pe_hocon_setting["${container}.console.service-alert"],
  }

  if $settings::storeconfigs {
    $nodes_with_code_manager = puppetdb_query(['from', 'resources',
                                               ['extract', ['certname', 'parameters'],
                                                ['and', ['=', 'type', 'Class'],
                                                 ['=', 'title', 'Puppet_enterprise::Master::Code_manager'],
                                                 ["=", ["node","active"], true]]]])

    $code_managers = $nodes_with_code_manager.map |$code_manager| {
      {host => $code_manager['certname'],
     # TODO once CODEMGMT-633 is complete add this, delivered through master port 8140 for now
     # port => $code_manager['parameters']['webserver_ssl_port']
       port => 8140}
    }
  } else {
    $code_managers = []
  }

  each($code_managers) |$code_manager| {
    $host = $code_manager[host]
    $port = $code_manager[port]
    pe_hocon_setting { "${container}.console.service-alert.code-manager.${host}.${port}":
      path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
      setting => "console.service-alert",
      value   => {'url' => "https://${host}:${port}", 'type' => 'code-manager' },
      type    => 'array_element',
      require => Pe_hocon_setting["${container}.console.service-alert"],
    }
  }

  # For PuppetDB HA, a user may pass in an Array to specify their PuppetDBs
  $puppetdb_hosts = pe_any2array($puppetdb_host)
  $puppetdb_ports = pe_any2array($puppetdb_port)
  $puppetdb_servers = pe_zip($puppetdb_hosts, $puppetdb_ports)
  each($puppetdb_servers) |$pdb_server| {
    $pdb_host = $pdb_server[0]
    $pdb_port = $pdb_server[1]
    pe_hocon_setting { "${container}.console.service-alert.puppetdb.${pdb_host}.${pdb_port}":
      path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
      setting => "console.service-alert",
      value   => {'url' => "https://${pdb_host}:${pdb_port}", 'type' => 'puppetdb'},
      type    => 'array_element',
      require => Pe_hocon_setting["${container}.console.service-alert"],
    }
  }

  # For Multi-Master installation, it's assumed that master certnames from PuppetDB are reachable hostnames
  # "storeconfigs" being true is used here to determine if PuppetDB is ready
  # to accept queries. This only matters during a PE installation when
  # templates are applied. This setting is typically false then, since a
  # manifest might otherwise attempt to query PuppetDB before it was running.
  if $settings::storeconfigs {
    $masters_in_puppetdb = map(
      puppetdb_query(['from', 'resources',
                      ['extract', ['certname'],
                       ['and', ['=', 'type', 'Class'],
                        ['=', 'title', 'Puppet_enterprise::Profile::Master'],
                        ["=", ["node","active"], true]]]])) |$master| { $master['certname'] }
  } else {
    $masters_in_puppetdb = []
  }
  $masters = pe_union([$master_host], $masters_in_puppetdb)
  each($masters) |$master| {
    pe_hocon_setting { "${container}.console.service-alert.master.${master}":
      path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
      setting => "console.service-alert",
      value   => {'url' => "https://${master}:8140", 'type' => 'master'},
      type    => 'array_element',
      require => Pe_hocon_setting["${container}.console.service-alert"],
    }
  }

  pe_hocon_setting { "${container}.console.service-alert-timeout":
    path    => "/etc/puppetlabs/${container}/conf.d/console.conf",
    setting => "console.service-alert-timeout",
    value   => $service_alert_timeout,
  }

  $cookie_secret_key = cookie_secret_key()
  # Uses
  #   $cookie_secret_key
  file { "/etc/puppetlabs/${container}/conf.d/console_secret_key.conf":
    ensure  => present,
    owner   => $user,
    group   => $group,
    replace => false,
    mode    => '0640',
    content => "console: { cookie-secret-key: \"${cookie_secret_key}\" }",
  }

  # pe_hocon_setting doesn't have a no replace mode
  # pe_hocon_setting { "${container}.console.cookie-secret-key":
  #   path    => "/etc/puppetlabs/${container}/conf.d/console_secret_key.conf",
  #   setting => 'console.cookie-secret-key',
  #   value   => cookie_secret_key(),
  # }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console webrouting-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.webrouting.webrouting-service',
    service   => 'webrouting-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console rbac-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.rbac',
    service   => 'rbac-service',
  }
  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console rbac-authn-middleware" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.http.middleware',
    service   => 'rbac-authn-middleware',
  }
  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console rbac-consumer-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.consumer',
    service   => 'rbac-consumer-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console rbac-status-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.status',
    service   => 'rbac-status-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console rbac-storage-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.storage.permissioned',
    service   => 'rbac-storage-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console rbac-authn-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.authn',
    service   => 'rbac-authn-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console rbac-authz-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.authz',
    service   => 'rbac-authz-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console pe-console-ui-service" :
    container => $container,
    namespace => 'puppetlabs.pe-console-ui.service',
    service   => 'pe-console-ui-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console pe-console-auth-ui-service" :
    container => $container,
    namespace => 'puppetlabs.pe-console-auth-ui.service',
    service   => 'pe-console-auth-ui-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console jetty9-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console status-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.status.status-service',
    service   => 'status-service',
  }

  if $status_proxy_enabled {
    puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console status-proxy-service" :
      container => $container,
      namespace => 'puppetlabs.trapperkeeper.services.status.status-proxy-service',
      service   => 'status-proxy-service',
    }
  }
}
