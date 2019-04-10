define puppet_enterprise::trapperkeeper::classifier (
  $client_certname        = $::clientcert,
  $container              = $title,
  $database_host          = 'localhost',
  $database_name          = $puppet_enterprise::params::classifier_database_name,
  $database_user          = $puppet_enterprise::params::classifier_database_user,
  $database_password      = undef,
  $database_port          = $puppet_enterprise::params::database_port,
  $database_properties    = '',
  $group                  = "pe-${title}",
  $localcacert            = $puppet_enterprise::params::localcacert,
  $master_host            = undef,
  $prune_days_threshold   = $puppet_enterprise::params::classifier_prune_threshold,
  $synchronization_period = $puppet_enterprise::params::classifier_synchronization_period,
  $user                   = "pe-${title}",
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
  if $master_host and !pe_empty($master_host) {
    $master_host_ensure = present
  } else {
    $master_host_ensure = absent
  }

  # URL for the puppet master's rest interface
  pe_hocon_setting { "${container}.classifier.puppet-master":
    ensure  => $master_host_ensure,
    path    => "/etc/puppetlabs/${container}/conf.d/classifier.conf",
    setting => 'classifier.puppet-master',
    value   => "https://${master_host}:8140",
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

  # Uses
  #   $database_host
  #   $database_port
  #   $database_name
  #   $database_user
  #   $database_properties
  file { "/etc/puppetlabs/${container}/conf.d/classifier-database.conf":
    ensure => present,
  }
  pe_hocon_setting { 'classifier.database.subprotocol':
    path    => "/etc/puppetlabs/${container}/conf.d/classifier-database.conf",
    setting => 'classifier.database.subprotocol',
    value   => 'postgresql',
  }
  pe_hocon_setting { "${container}.classifier.database.subname":
    path    => "/etc/puppetlabs/${container}/conf.d/classifier-database.conf",
    setting => 'classifier.database.subname',
    value   => "//${database_host}:${database_port}/${database_name}${database_properties}",
  }
  pe_hocon_setting { "${container}.classifier.database.user":
    path    => "/etc/puppetlabs/${container}/conf.d/classifier-database.conf",
    setting => 'classifier.database.user',
    value   => $database_user,
  }

  if !pe_empty($database_password) {
    pe_hocon_setting { "${container}.classifier.database.password":
      path    => "/etc/puppetlabs/${container}/conf.d/classifier-database.conf",
      setting => 'classifier.database.password',
      value   => $database_password,
    }
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
