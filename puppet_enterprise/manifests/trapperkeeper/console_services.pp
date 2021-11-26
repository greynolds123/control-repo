define puppet_enterprise::trapperkeeper::console_services(
  $activity_host,
  Array[String]  $puppetdb_host,
  Array[Integer] $puppetdb_port,
  $master_host,
  $classifier_host,
  $rbac_host,
  $status_proxy_enabled,
  String $session_maximum_lifetime,
  $service_alert_timeout,
  String $agent_installer_host,
  Integer $agent_installer_port,
  $orchestrator_host           = $master_host,
  $orchestrator_port           = $puppet_enterprise::orchestrator_port,
  $orchestrator_url_prefix     = $puppet_enterprise::orchestrator_url_prefix,
  String $inventory_host       = $master_host,
  Integer $inventory_port      = $puppet_enterprise::orchestrator_port,
  String $inventory_url_prefix = $puppet_enterprise::inventory_url_prefix,
  $activity_port               = $puppet_enterprise::params::console_services_api_listen_port,
  $activity_url_prefix         = $puppet_enterprise::params::activity_url_prefix,
  $classifier_port             = $puppet_enterprise::params::console_services_api_listen_port,
  $classifier_url_prefix       = $puppet_enterprise::params::classifier_url_prefix,
  $client_certname             = $puppet_enterprise::console_host,
  Integer $query_cache_ttl     = $puppet_enterprise::params::console_services_query_cache_ttl,
  $max_connections_per_route   = undef,
  $max_connections_total       = undef,
  $container                   = $title,
  $group                       = "pe-${title}",
  $localcacert                 = $puppet_enterprise::params::localcacert,
  $proxy_idle_timeout          = 60,
  $rbac_port                   = $puppet_enterprise::params::console_services_api_listen_port,
  $rbac_url_prefix             = $puppet_enterprise::params::rbac_url_prefix,
  $session_timeout             = undef,
  $user                        = "pe-${title}",
  Integer $pcp_timeout         = 5,
  Boolean $display_local_time  = false,
  Array[Struct[{type => String,
                url => String,
                replication_mode => Enum['source','replica','none']}]] $status_services = [],
  Puppet_enterprise::Replication_mode $replication_mode = 'none',
  Integer $master_port = $puppet_enterprise::puppet_master_port,
  Optional[Integer] $no_longer_reporting_cutoff = undef,
) {

  $cert_dir = "${puppet_enterprise::server_data_dir}/${container}/certs"
  $ssl_key = "${cert_dir}/${client_certname}.private_key.pem"
  $ssl_cert =  "${cert_dir}/${client_certname}.cert.pem"

  $license_key_path = $puppet_enterprise::params::dest_license_key_path

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
  #   $orchestrator_host
  #   $orchestrator_port
  #   $orchestrator_url_prefix
  #   $inventory_host
  #   $inventory_port
  #   $inventory_url_prefix
  #   $rbac
  #   $rbac_port
  #   $rbac_url_prefix
  #   $session_timeout
  #   $session_maximum_lifetime
  #   $classifier
  #   $classifier_port
  #   $classifier_url_prefix
  #   $activity
  #   $activity_port
  #   $activity_url_prefix
  #   $proxy_idle_timeout
  #   $query_cache_ttl
  #   $max_connections_per_route
  #   $max_connections_total
  #   $display_local_time

  $console_conf_path = "/etc/puppetlabs/${container}/conf.d/console.conf"
  file { $console_conf_path :
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  pe_hocon_setting { "${container}.console.assets-dir":
    path    => $console_conf_path,
    setting => 'console.assets-dir',
    value   => 'dist',
  }
  pe_hocon_setting { "${container}.console.puppet-master":
    path    => $console_conf_path,
    setting => 'console.puppet-master',
    value   => "https://${master_host}:${master_port}",
  }
  pe_hocon_setting { "${container}.console.agent-installer-url":
    path    => $console_conf_path,
    setting => 'console.agent-installer-url',
    value   => "https://${agent_installer_host}:${agent_installer_port}",
  }
  pe_hocon_setting { "${container}.console.rbac-server":
    path    => $console_conf_path,
    setting => 'console.rbac-server',
    value   => "http://${rbac_host}:${rbac_port}${rbac_url_prefix}",
  }
  pe_hocon_setting { "${container}.console.classifier-server":
    path    => $console_conf_path,
    setting => 'console.classifier-server',
    value   => "http://${classifier_host}:${classifier_port}${classifier_url_prefix}",
  }
  pe_hocon_setting { "${container}.console.activity-server":
    path    => $console_conf_path,
    setting => 'console.activity-server',
    value   => "http://${activity_host}:${activity_port}${activity_url_prefix}",
  }
  pe_hocon_setting { "${container}.console.orchestrator-server":
    path    => $console_conf_path,
    setting => 'console.orchestrator-server',
    value   => "https://${orchestrator_host}:${orchestrator_port}${orchestrator_url_prefix}",
  }
  pe_hocon_setting { "${container}.console.inventory-server":
    path    => $console_conf_path,
    setting => 'console.inventory-server',
    value   => "https://${inventory_host}:${inventory_port}${inventory_url_prefix}",
  }
  pe_hocon_setting { "${container}.console.display-local-time":
    path    => $console_conf_path,
    setting => 'console.display-local-time',
    value   => $display_local_time,
  }
  pe_hocon_setting { "${container}.console.query-cache-ttl":
    path    => $console_conf_path,
    setting => 'console.query-cache-ttl',
    value   => $query_cache_ttl,
  }

  if $max_connections_per_route {
    $max_connections_per_route_ensure = present
  } else {
    $max_connections_per_route_ensure = absent
  }

  pe_hocon_setting { "${container}.console.max-connections-per-route":
    ensure  => $max_connections_per_route_ensure,
    path    => $console_conf_path,
    setting => 'console.max-connections-per-route',
    value   => $max_connections_per_route,
  }

  if $max_connections_total {
    $max_connections_total_ensure = present
  } else {
    $max_connections_total_ensure = absent
  }

  pe_hocon_setting { "${container}.console.max-connections-total":
    ensure  => $max_connections_total_ensure,
    path    => $console_conf_path,
    setting => 'console.max-connections-total',
    value   => $max_connections_total,
  }

  if $session_timeout {
    $session_timeout_ensure = present
  } else {
    $session_timeout_ensure = absent
  }

  pe_hocon_setting { "${container}.console.session-timeout":
    ensure  => $session_timeout_ensure,
    path    => $console_conf_path,
    setting => 'console.session-timeout',
    value   => $session_timeout,
  }

  if $session_maximum_lifetime and $session_maximum_lifetime != '' {
    pe_validate_re($session_maximum_lifetime, '^[0-9]+[smhdy]?$', '$session_maximum_lifetime must either be an integer or a string of digits optionally followed by "s", "m", "h", "d", or "y".')
    $session_maximum_lifetime_ensure = present
  } else {
    $session_maximum_lifetime_ensure = absent
  }

  pe_hocon_setting { "${container}.console.session-maximum-lifetime":
    ensure  => $session_maximum_lifetime_ensure,
    path    => $console_conf_path,
    setting => 'console.session-maximum-lifetime',
    value   => $session_maximum_lifetime,
  }

  # For PuppetDB HA, a user may pass in an Array to specify their PuppetDBs
  $first_puppetdb_host = $puppetdb_host[0]
  $first_puppetdb_port = pe_any2array($puppetdb_port)[0]
  pe_hocon_setting { "${container}.console.puppetdb-server":
    path    => $console_conf_path,
    setting => 'console.puppetdb-server',
    value   => "https://${first_puppetdb_host}:${first_puppetdb_port}",
  }
  pe_hocon_setting { "${container}.console.certs.ssl-key":
    path    => $console_conf_path,
    setting => 'console.certs.ssl-key',
    value   => $ssl_key,
  }
  pe_hocon_setting { "${container}.console.certs.ssl-cert":
    path    => $console_conf_path,
    setting => 'console.certs.ssl-cert',
    value   => $ssl_cert,
  }
  pe_hocon_setting { "${container}.console.certs.ssl-ca-cert":
    path    => $console_conf_path,
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
    path    => $console_conf_path,
    setting => 'console.proxy-idle-timeout',
    value   => $proxy_idle_timeout,
  }

  pe_hocon_setting { "${container}.console.license-key":
    path    => $console_conf_path,
    setting => 'console.license-key',
    value   => $license_key_path,
  }

  pe_hocon_setting { "${container}.console.pcp-request-timeout":
    path    => $console_conf_path,
    setting => 'console.pcp-request-timeout',
    value   => $pcp_timeout,
  }

# Service Alert configuration
  if $settings::storeconfigs {
    $row = puppetdb_query(['from', 'resources',
                            ['extract', ['certname', 'parameters'],
                              ['and',
                                ['=', ['node','active'], true],
                                ['=', 'type', 'Class'],
                                ['=', 'title', 'Puppet_enterprise::Profile::Console']]]])

    $ha_nodes = $row.map |$row| {
      $node_certname = $row['certname']
      $replication_mode_param = $row['parameters']['replication_mode'];

      {$node_certname => $replication_mode_param}
    }

    $certname_replication_map = $ha_nodes.reduce({}) | $res, $value | {
      pe_merge($res, $value)
    }

    $classes_to_fetch = {
      'Puppet_enterprise::Master::Puppetserver'  => [
        { type           => 'master',
          port_param     => 'puppetserver_webserver_ssl_port' }],
      'Puppet_enterprise::Master::Code_manager'  => [
        { type           => 'code-manager',
          port_param     => 'puppet_master_port' }],
      'Puppet_enterprise::Profile::Puppetdb'     => [
        { type           => 'puppetdb',
          port_param     => 'ssl_listen_port' }],
      'Puppet_enterprise::Profile::Orchestrator' => [
        { type           => 'orchestrator',
          port_param     => 'ssl_listen_port' }],
      'Puppet_enterprise::Profile::Console'      => [
        { type           => 'classifier',
          port_param     => 'console_services_api_ssl_listen_port' },
        { type           => 'rbac',
          port_param     => 'console_services_api_ssl_listen_port' },
        { type           => 'activity',
          port_param     => 'console_services_api_ssl_listen_port' },
      ]
    }

    $query_or_clause = pe_concat(['or'],
                                 pe_keys($classes_to_fetch).map |$title| {
                                   ['=', 'title', $title]
                                 })

    $rows = puppetdb_query(['from', 'resources',
      ['extract', ['certname', 'title', 'parameters'],
        ['and',
          ['=', ['node','active'], true],
          ['=', 'type', 'Class'],
          $query_or_clause]]])

    $queried_services_nested = $rows.map |$row| {
      $resource_title = $row['title']
      $class_parameters = $row['parameters']
      $node_certname = $row['certname']

      $service_defs_for_class = $classes_to_fetch[$resource_title]
      $service_defs_for_class.map |$service_def| {
        $service_type = $service_def['type']
        $service_port_param = $service_def['port_param']
        $service_port = $class_parameters[$service_port_param]

        if $certname_replication_map[$node_certname] {
          $replication_mode = $certname_replication_map[$node_certname]
        }
        else {
          $replication_mode = 'none'
        };

        {
          type => $service_type,
          url => "https://${node_certname}:${service_port}",
          replication_mode => $replication_mode
        }
      }
    }

    $queried_services = pe_hash_array_sort(pe_flatten($queried_services_nested), ['type', 'url'])
  }
  else {
    $queried_services = []
  }

  pe_hocon_setting { "${container}.console.service-alert":
    path    => $console_conf_path,
    setting => 'console.service-alert',
    value   => pe_concat($queried_services, $status_services),
    type    => 'array',
  }

  pe_hocon_setting { "${container}.console.service-alert-timeout":
    path    => $console_conf_path,
    setting => 'console.service-alert-timeout',
    value   => $service_alert_timeout,
  }

  $no_longer_reporting_cutoff_ensure = pe_empty($no_longer_reporting_cutoff) ? {
    false   => present,
    default => absent,
  }

  pe_hocon_setting { "${container}.console.no-longer-reporting-cutoff":
    ensure  => $no_longer_reporting_cutoff_ensure,
    path    => $console_conf_path,
    setting => 'console.no-longer-reporting-cutoff',
    value   => $no_longer_reporting_cutoff,
  }

  puppet_enterprise::trapperkeeper::analytics_client_settings { $container:
    container => $container,
    owner     => $user,
  }

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
    ensure    => absent,
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

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console audit-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.audit',
    service   => 'audit-service',
  }

  $absent_on_replica = $replication_mode ? {
    'replica' => absent,
    default   => present,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console pe-console-ui-service" :
    ensure    => $absent_on_replica,
    container => $container,
    namespace => 'puppetlabs.pe-console-ui.service',
    service   => 'pe-console-ui-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console pe-console-auth-ui-service" :
    ensure    => $absent_on_replica,
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

  # This is a dependency of status-service with version 0.6.0
  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console scheduler-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.scheduler.scheduler-service',
    service   => 'scheduler-service',
  }

  if $status_proxy_enabled {
    puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console status-proxy-service" :
      container => $container,
      namespace => 'puppetlabs.trapperkeeper.services.status.status-proxy-service',
      service   => 'status-proxy-service',
    }
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console metrics-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.metrics.metrics-service',
    service   => 'metrics-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:console metrics-webservice" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.metrics.metrics-service',
    service   => 'metrics-webservice',
  }
}
