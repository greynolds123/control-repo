define puppet_enterprise::trapperkeeper::orchestrator(
  $master_url,
  $puppetdb_url,
  $classifier_url,
  $rbac_url,
  $console_url,
  $console_services_url,
  $pcp_broker_url,
  $client_certname                              = $puppet_enterprise::puppet_master_host,
  $container                                    = $title,
  $database_host                                = 'localhost',
  $database_port                                = $puppet_enterprise::params::database_port,
  $database_name                                = "pe-orchestrator",
  $database_user                                = "pe-orchestrator",
  $database_password                            = undef,
  $database_properties                          = '',
  $user                                         = "pe-${title}",
  $group                                        = "pe-${title}",
  Optional[Integer] $global_concurrent_compiles = undef,
  Optional[Integer] $job_prune_threshold        = undef,
  Optional[Integer] $pcp_timeout                = undef,
) {

  $confdir = "/etc/puppetlabs/${container}/conf.d"

  file { "${confdir}/orchestrator.conf":
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => '0640',
  }

  pe_hocon_setting { "${container}.orchestrator.master-url":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.master-url',
    value   => $master_url,
  }

  pe_hocon_setting { "${container}.orchestrator.puppetdb-url":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.puppetdb-url',
    value   => $puppetdb_url,
  }

  pe_hocon_setting { "${container}.orchestrator.classifier-service":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.classifier-service',
    value   => $classifier_url,
  }

  pe_hocon_setting { "${container}.orchestrator.console-services-url":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.console-services-url',
    value   => $console_services_url,
  }

  pe_hocon_setting { "${container}.rbac-consumer.api-url":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'rbac-consumer.api-url',
    value   => $rbac_url,
  }

  pe_hocon_setting { "${container}.orchestrator.pcp-broker-url":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.pcp-broker-url',
    value   => $pcp_broker_url,
  }

  pe_hocon_setting { "${container}.orchestrator.console-url":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.console-url',
    value   => $console_url,
  }

  pe_hocon_setting { "${container}.orchestrator.ssl-ca-cert":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.ssl-ca-cert',
    value   => $puppet_enterprise::params::localcacert,
  }

  pe_hocon_setting { "${container}.orchestrator.ssl-cert":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.ssl-cert',
    value   => "/etc/puppetlabs/${container}/ssl/${client_certname}.cert.pem",
  }

  pe_hocon_setting { "${container}.orchestrator.ssl-key":
    ensure  => present,
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

  $job_prune_threshold_ensure = $job_prune_threshold ? {
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

  pe_hocon_setting { "${container}.orchestrator.job-prune-threshold":
    ensure  => $job_prune_threshold_ensure,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.job-prune-threshold',
    value   => $job_prune_threshold,
  }

  pe_hocon_setting { "${container}.orchestrator.database.subname":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.database.subname',
    value   => "//${database_host}:${database_port}/${database_name}${database_properties}",
  }

  pe_hocon_setting { "${container}.orchestrator.database.user":
    ensure  => present,
    path    => "${confdir}/orchestrator.conf",
    setting => 'orchestrator.database.user',
    value   => $database_user,
  }

  if !pe_empty($database_password) {
    pe_hocon_setting { "${container}.orchestrator.database.password":
      path    => "${confdir}/orchestrator.conf",
      setting => 'orchestrator.database.password',
      value   => $database_password,
    }
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator orchestrator-service" :
    container => $container,
    namespace => 'puppetlabs.orchestrator.service',
    service   => 'orchestrator-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator status-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.status.status-service',
    service   => 'status-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator metrics-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.metrics.metrics-service',
    service   => 'metrics-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator jetty9-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:orchestrator remote-rbac-consumer-service" :
    container => $container,
    namespace => 'puppetlabs.rbac-client.services.rbac',
    service   => 'remote-rbac-consumer-service',
  }

}
