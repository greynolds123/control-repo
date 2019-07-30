class puppet_enterprise::console_services(
  $client_certname,
  $master_host,
  Array[String]  $puppetdb_host,
  Array[Integer] $puppetdb_port,
  $orchestrator_host                 = $master_host,
  $orchestrator_port                 = $puppet_enterprise::orchestrator_port,
  $orchestrator_url_prefix           = $puppet_enterprise::orchestrator_url_prefix,
  $inventory_host                    = $orchestrator_host,
  Integer $inventory_port            = $puppet_enterprise::orchestrator_port,
  String $inventory_url_prefix       = $puppet_enterprise::inventory_url_prefix,
  $proxy_idle_timeout                = 60,
  Integer $master_port               = $puppet_enterprise::puppet_master_port,
  $classifier_host                   = 'localhost',
  $classifier_port                   = $puppet_enterprise::params::console_services_api_listen_port,
  $classifier_url_prefix             = $puppet_enterprise::params::classifier_url_prefix,
  $rbac_host                         = 'localhost',
  $rbac_port                         = $puppet_enterprise::params::console_services_api_listen_port,
  $activity_host                     = 'localhost',
  $activity_port                     = $puppet_enterprise::params::console_services_api_listen_port,
  $activity_url_prefix               = $puppet_enterprise::params::activity_url_prefix,
  Integer $query_cache_ttl           = $puppet_enterprise::params::console_services_query_cache_ttl,
  $localcacert                       = $puppet_enterprise::params::localcacert,
  Hash $java_args                    = $puppet_enterprise::params::console_services_java_args,
  Optional[Boolean] $enable_gc_logging = undef,
  $status_proxy_enabled              = false,
  $service_stop_retries              = 60,
  $start_timeout                     = 300,
  String $pcp_broker_host            = $puppet_enterprise::pcp_broker_host,
  Integer $pcp_broker_port           = $puppet_enterprise::pcp_broker_port,
  Integer $pcp_timeout               = 5,
  $service_alert_timeout             = 5000,
  Boolean $display_local_time        = false,
  String $session_maximum_lifetime   = '',
  Optional[Integer] $session_timeout = undef,
  Puppet_enterprise::Replication_mode $replication_mode = 'none',
  Optional[Integer] $no_longer_reporting_cutoff = undef,
  String $agent_installer_host       = lookup('pe_repo::compile_master_pool_address', {default_value => $master_host}),
  Integer $agent_installer_port      = $master_port,
  Optional[Integer] $max_connections_per_route = undef,
  Optional[Integer] $max_connections_total     = undef,
) inherits puppet_enterprise::params {
  include puppet_enterprise::packages

  pe_validate_single_integer($service_stop_retries)
  pe_validate_single_integer($start_timeout)

  $container = 'console-services'

  $confdir = '/etc/puppetlabs/console-services'

  puppet_enterprise::trapperkeeper::console_services { $container:
    client_certname            => $client_certname,
    proxy_idle_timeout         => $proxy_idle_timeout,
    master_host                => $master_host,
    master_port                => $master_port,
    orchestrator_host          => $orchestrator_host,
    orchestrator_port          => $orchestrator_port,
    orchestrator_url_prefix    => $orchestrator_url_prefix,
    inventory_host             => $inventory_host,
    inventory_port             => $inventory_port,
    inventory_url_prefix       => $inventory_url_prefix,
    classifier_host            => $classifier_host,
    classifier_port            => $classifier_port,
    classifier_url_prefix      => $classifier_url_prefix,
    puppetdb_host              => $puppetdb_host,
    puppetdb_port              => $puppetdb_port,
    rbac_host                  => $rbac_host,
    rbac_port                  => $rbac_port,
    activity_host              => $activity_host,
    activity_port              => $activity_port,
    activity_url_prefix        => $activity_url_prefix,
    localcacert                => $localcacert,
    status_proxy_enabled       => $status_proxy_enabled,
    pcp_timeout                => $pcp_timeout,
    service_alert_timeout      => $service_alert_timeout,
    display_local_time         => $display_local_time,
    session_timeout            => $session_timeout,
    session_maximum_lifetime   => $session_maximum_lifetime,
    replication_mode           => $replication_mode,
    query_cache_ttl            => $query_cache_ttl,
    no_longer_reporting_cutoff => $no_longer_reporting_cutoff,
    agent_installer_host       => $agent_installer_host,
    agent_installer_port       => $agent_installer_port,
    max_connections_per_route  => $max_connections_per_route,
    max_connections_total      => $max_connections_total,
    require                    => Package['pe-console-services'],
    notify                     => Service['pe-console-services'],
  }

  puppet_enterprise::trapperkeeper::java_args { $container :
    java_args => $java_args,
    enable_gc_logging => $enable_gc_logging,
  }

  puppet_enterprise::trapperkeeper::init_defaults { $container :
    service_stop_retries => $service_stop_retries,
    start_timeout        => $start_timeout,
  }

  puppet_enterprise::trapperkeeper::pe_service { $container : }
}
