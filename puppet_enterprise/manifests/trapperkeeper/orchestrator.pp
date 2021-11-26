define puppet_enterprise::trapperkeeper::orchestrator(
  $master_url,
  $puppetdb_url,
  $classifier_url,
  $rbac_url,
  $activity_url,
  $console_url,
  $console_services_url,
  $inventory_service_url,
  $allow_unauthenticated_status,
  $bolt_server_max_connections,
  $plan_executor_workers,
  $ace_server_max_connections,
  Integer $bolt_server_port                     = $puppet_enterprise::bolt_server_port,
  Integer $bolt_server_conn_timeout             = 10000,
  Integer $plan_executor_port                   = $puppet_enterprise::plan_executor_port,
  Integer $plan_executor_conn_timeout           = 10000,
  Integer $ace_server_port                      = $puppet_enterprise::ace_server_port,
  Integer $ace_server_conn_timeout              = 10000,
  $pcp_broker_url                               = undef,
  Array[String] $pcp_brokers                    = [],
  $client_certname                              = $puppet_enterprise::puppet_master_host,
  $container                                    = $title,
  $database_host                                = 'localhost',
  $database_port                                = $puppet_enterprise::database_port,
  $database_name                                = $puppet_enterprise::orchestrator_database_name,
  $database_user                                = $puppet_enterprise::orchestrator_service_regular_db_user,
  $database_migration_user                      = $puppet_enterprise::orchestrator_service_migration_db_user,
  $database_password                            = undef,
  $database_properties                          = '',
  $user                                         = "pe-${title}",
  $group                                        = "pe-${title}",
  Optional[Integer] $global_concurrent_compiles = undef,
  Optional[Integer] $task_concurrency           = undef,
  Optional[Integer] $job_prune_threshold        = undef,
  Optional[Integer] $pcp_timeout                = undef,
  Optional[Boolean] $app_management             = undef,
) {

  $confdir = "/etc/puppetlabs/${container}/conf.d"

  file { "${confdir}/orchestrator.conf":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  Pe_hocon_setting {
    ensure => present,
  }

  pe_hocon_setting { "${container}.orchestrator.master-url":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.master-url',
    value   => $master_url,
  }

  pe_hocon_setting { "${container}.orchestrator.puppetdb-url":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.puppetdb-url',
    value   => $puppetdb_url,
  }

  pe_hocon_setting { "${container}.orchestrator.classifier-service":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.classifier-service',
    value   => $classifier_url,
  }

  pe_hocon_setting { "${container}.orchestrator.console-services-url":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.console-services-url',
    value   => $console_services_url,
  }

  pe_hocon_setting { "${container}.orchestrator.inventory-service-url":
    path => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.inventory-service-url',
    value => $inventory_service_url,
  }

  pe_hocon_setting { "${container}.orchestrator.bolt-server-url":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.bolt-server-url',
    value => "https://${client_certname}:${bolt_server_port}"
  }

  pe_hocon_setting { "${container}.orchestrator.bolt-server-conn-timeout":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.bolt-server-conn-timeout',
    value => $bolt_server_conn_timeout,
  }

  pe_hocon_setting { "${container}.orchestrator.bolt-server-max-connections":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.bolt-server-max-connections',
    value => $bolt_server_max_connections,
  }

  pe_hocon_setting { "${container}.orchestrator.plan-executor-url":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.plan-executor-url',
    value => "https://${client_certname}:${plan_executor_port}"
  }

  pe_hocon_setting { "${container}.orchestrator.plan-executor-conn-timeout":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.plan-executor-conn-timeout',
    value => $plan_executor_conn_timeout,
  }

  pe_hocon_setting { "${container}.orchestrator.plan-executor-workers":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.plan-executor-workers',
    value => $plan_executor_workers,
  }

  pe_hocon_setting { "${container}.orchestrator.ace-server-url":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.ace-server-url',
    value => "https://${client_certname}:${ace_server_port}"
  }

  pe_hocon_setting { "${container}.orchestrator.ace-server-conn-timeout":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.ace-server-conn-timeout',
    value => $ace_server_conn_timeout,
  }

  pe_hocon_setting { "${container}.orchestrator.ace-server-max-connections":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.ace-server-max-connections',
    value => $ace_server_max_connections,
  }

  pe_hocon_setting { "${container}.rbac-consumer.api-url":
    path    => "${confdir}/orchestrator.conf",
    setting => 'rbac-consumer.api-url',
    value   => $rbac_url,
  }

  pe_hocon_setting { "${container}.activity-consumer.api-url":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'activity-consumer.api-url',
    value   => $activity_url,
  }

  pe_hocon_setting { "${container}.orchestrator.pcp-broker-url":
    ensure  => absent,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.pcp-broker-url',
  }

  pe_hocon_setting { "${container}.orchestrator.console-url":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.console-url',
    value   => $console_url,
  }

  pe_hocon_setting { "${container}.orchestrator.ssl-ca-cert":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.ssl-ca-cert',
    value   => $puppet_enterprise::params::localcacert,
  }

  pe_hocon_setting { "${container}.orchestrator.ssl-cert":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.ssl-cert',
    value   => "/etc/puppetlabs/${container}/ssl/${client_certname}.cert.pem",
  }

  pe_hocon_setting { "${container}.orchestrator.ssl-key":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.ssl-key',
    value   => "/etc/puppetlabs/${container}/ssl/${client_certname}.private_key.pem",
  }

  $pcp_timeout_ensure = $pcp_timeout ? {
    undef   => 'absent',
    default => 'present',
  }


  $global_concurrent_compiles_ensure = $global_concurrent_compiles ? {
    undef   => 'absent',
    default => 'present',
  }

  $task_concurrency_ensure = $task_concurrency ? {
    undef   => 'absent',
    default => 'present',
  }


  $job_prune_threshold_ensure = $job_prune_threshold ? {
    undef   => 'absent',
    default => 'present',
  }

  $app_management_ensure = $app_management ? {
    undef   => 'absent',
    default => 'present',
  }

  pe_hocon_setting { "${container}.orchestrator.pcp-timeout":
    ensure  => $pcp_timeout_ensure,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.pcp-timeout',
    value   => $pcp_timeout,
  }

  pe_hocon_setting { "${container}.orchestrator.global-concurrent-compiles":
    ensure  => $global_concurrent_compiles_ensure,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.global-concurrent-compiles',
    value   => $global_concurrent_compiles,
  }

  pe_hocon_setting { "${container}.orchestrator.task-concurrency":
    ensure  => $task_concurrency_ensure,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.task-concurrency',
    value   => $task_concurrency,
  }

  pe_hocon_setting { "${container}.orchestrator.job-prune-days-threshold":
    ensure  => $job_prune_threshold_ensure,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.job-prune-days-threshold',
    value   => $job_prune_threshold,
  }

  pe_hocon_setting { "${container}.orchestrator.app-management":
    ensure  => $app_management_ensure,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.app-management',
    value   => $app_management,
  }

  pe_hocon_setting { "${container}.orchestrator.database.subname":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.database.subname',
    value   => "//${database_host}:${database_port}/${database_name}${database_properties}",
  }

  pe_hocon_setting { "${container}.orchestrator.database.user":
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.database.user',
    value   => $database_user,
  }
  pe_hocon_setting { "${container}.orchestrator.database.migration-user":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.database.migration-user',
    value   => $database_migration_user,
  }

  if !pe_empty($database_password) {
    pe_hocon_setting { "${container}.orchestrator.database.password":
      path    => "${confdir}/orchestrator.conf",
      setting => 'orchestrator.database.password',
      value   => $database_password,
    }
    pe_hocon_setting { "${container}.orchestrator.database.migration-password":
      path    => "${confdir}/orchestrator.conf",
      setting => 'orchestrator.database.migration-password',
      value   => $database_password,
    }
  }

  pe_puppet_authorization::rule { 'dispatch: allow pcp-brokers':
    path               => "${confdir}/auth.conf",
    match_request_type => 'path',
    match_request_path => '/server',
    allow              => [$client_certname] + $pcp_brokers,
    sort_order         => 500,
  }

  $allow_status_service = $allow_unauthenticated_status ? {
                           false => '*',
                           default => undef,
                         }

  pe_puppet_authorization::rule { 'orchestrator simple status endpoint':
    path                  => "${confdir}/auth.conf",
    match_request_type    => 'path',
    match_request_method  => 'get',
    match_request_path    => '/status/v1/simple',
    allow_unauthenticated => true,
    sort_order            => 500,
  }

  pe_puppet_authorization::rule { 'orchestrator status service':
    path                  => "${confdir}/auth.conf",
    match_request_type    => 'path',
    match_request_method  => 'get',
    match_request_path    => '/status/v1/services',
    allow_unauthenticated => $allow_unauthenticated_status,
    allow                 => $allow_status_service,
    sort_order            => 500,
  }

  puppet_enterprise::trapperkeeper::analytics_client_settings { $container:
    container => $container,
    owner     => $user,
  }

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg {
    container => $container,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator orchestrator-service" :
    namespace => 'puppetlabs.orchestrator.service',
    service   => 'orchestrator-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator orchestrator-dispatch-service" :
    namespace => 'puppetlabs.orchestrator.dispatch',
    service   => 'orchestrator-dispatch-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator jetty9-service" :
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator remote-rbac-consumer-service" :
    namespace => 'puppetlabs.rbac-client.services.rbac',
    service   => 'remote-rbac-consumer-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator remote-activity-reporter" :
    container => $container,
    namespace => 'puppetlabs.rbac-client.services.activity',
    service   => 'remote-activity-reporter',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator jruby-pool-manager-service" :
    namespace => 'puppetlabs.services.jruby-pool-manager.jruby-pool-manager-service',
    service   => 'jruby-pool-manager-service'
  }
}
