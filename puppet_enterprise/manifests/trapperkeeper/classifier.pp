define puppet_enterprise::trapperkeeper::classifier (
  $client_certname               = $facts['clientcert'],
  $container                     = $title,
  $database_host                 = 'localhost',
  $database_name                 = $puppet_enterprise::params::classifier_database_name,
  $database_user                 = $puppet_enterprise::classifier_service_regular_db_user,
  $database_migration_user       = $puppet_enterprise::classifier_service_migration_db_user,
  $database_password             = undef,
  $database_port                 = $puppet_enterprise::database_port,
  $database_properties           = '',
  $allow_config_data             = $puppet_enterprise::params::classifier_allow_config_data,
  $group                         = "pe-${title}",
  $localcacert                   = $puppet_enterprise::params::localcacert,
  $master_host                   = $puppet_enterprise::puppet_master_host,
  Integer $master_port           = $puppet_enterprise::puppet_master_port,
  $prune_days_threshold          = $puppet_enterprise::params::classifier_prune_threshold,
  $synchronization_period        = $puppet_enterprise::params::classifier_synchronization_period,
  $user                          = "pe-${title}",
  Boolean $node_check_in_storage = false,
) {
  $cert_dir = "${puppet_enterprise::server_data_dir}/${container}/certs"
  $client_ssl_key  = "${cert_dir}/${client_certname}.private_key.pem"
  $client_ssl_cert = "${cert_dir}/${client_certname}.cert.pem"

  File {
    owner => $user,
    group => $group,
    mode  => '0640',
  }

  Pe_hocon_setting {
    ensure  => present,
    notify  => Service["pe-${container}"],
  }

  # Uses
  #   $master_host
  #   $client_ssl_key
  #   $client_ssl_cert
  #   $localcacert
  #   $synchronization_period
  #   $prune_days_threshold
  file { "/etc/puppetlabs/${container}/conf.d/classifier.conf":
    ensure => present,
  }

  # URL for the puppet master's rest interface
  pe_hocon_setting { "${container}.classifier.puppet-master":
    ensure  => present,
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.puppet-master',
    value   => "https://${master_host}:${master_port}",
  }

  pe_hocon_setting { "${container}.classifier.allow-config-data":
    ensure  => present,
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.allow-config-data',
    value   => $allow_config_data,
  }

  # Configure the SSL settings to enable SSL when communicating with the Puppet Master
  pe_hocon_setting { "${container}.classifier.ssl-key":
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.ssl-key',
    value   => $client_ssl_key,
  }
  pe_hocon_setting { "${container}.classifier.ssl-cert":
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.ssl-cert',
    value   => $client_ssl_cert,
  }
  pe_hocon_setting { "${container}.classifier.ssl-ca-cert":
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.ssl-ca-cert',
    value   => $localcacert,
  }
  # How often (in seconds) the classifier refreshes classes from the Master
  pe_hocon_setting { "${container}.classifier.synchronization-period":
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.synchronization-period',
    value   => $synchronization_period,
  }
  pe_hocon_setting { "${container}.classifier.prune-days-threshold":
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.prune-days-threshold',
    value   => $prune_days_threshold,
  }
  pe_hocon_setting { "${container}.classifier.node-check-in-storage":
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.node-check-in-storage',
    value   => $node_check_in_storage,
  }

  puppet_enterprise::trapperkeeper::database_settings { 'classifier' :
    container           => $container,
    database_host       => $database_host,
    database_name       => $database_name,
    database_password   => $database_password,
    database_port       => Integer($database_port),
    database_properties => $database_properties,
    database_user       => $database_user,
    migration_user      => $database_migration_user,
    migration_password  => $database_password,
    group               => $group,
    user                => $user,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:classifier classifier-service" :
    container => $container,
    namespace => 'puppetlabs.classifier.main',
    service   => 'classifier-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:classifier activity-reporting-service" :
    container => $container,
    namespace => 'puppetlabs.activity.services',
    service   => 'activity-reporting-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:classifier jetty9-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }

}
