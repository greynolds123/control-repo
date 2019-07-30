define puppet_enterprise::trapperkeeper::webserver_settings(
  String  $container,
  String  $ssl_listen_address,
  Integer $ssl_listen_port,
  String  $certname = $facts['clientcert'],
  String  $ssl_cert = "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
  String  $ssl_key  = "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
  String  $localcacert                                = $puppet_enterprise::params::localcacert,
  String  $hostcrl                                    = $puppet_enterprise::params::hostcrl,
  String  $container_service                          = $title,
  Optional[String]  $access_log_config                = undef,
  Optional[Integer] $tk_jetty_max_threads             = undef,
  Optional[Integer] $tk_jetty_request_header_max_size = undef,
  Optional[Boolean] $default_server                   = undef,
  Array[String]     $ssl_protocols                    = [],
  Enum['want','none'] $client_auth                    = 'want',
  Array[String] $ssl_cipher_suites                    = lookup( "puppet_enterprise::trapperkeeper::webserver_settings::${container_service}::ssl_cipher_suites",
                                                                {'default_value' => $puppet_enterprise::ssl_cipher_suites }),
) {
  $confdir  = "/etc/puppetlabs/${container}/conf.d"


  Pe_hocon_setting {
    ensure => present,
    path   => "${confdir}/webserver.conf",
    notify => Service["pe-${container}"],
  }

  pe_hocon_setting { "${container}.webserver.${$container_service}.client-auth":
    setting => "webserver.${container_service}.client-auth",
    value   => $client_auth,
  }

  pe_hocon_setting { "${container}.webserver.${$container_service}.ssl-host":
    setting => "webserver.${container_service}.ssl-host",
    value   => $ssl_listen_address,
  }

  pe_hocon_setting { "${container}.webserver.${$container_service}.ssl-port":
    setting => "webserver.${container_service}.ssl-port",
    value   => $ssl_listen_port,
  }

  pe_hocon_setting { "${container}.webserver.${$container_service}.ssl-ca-cert":
    setting => "webserver.${container_service}.ssl-ca-cert",
    value   => $localcacert,
  }

  pe_hocon_setting { "${container}.webserver.${$container_service}.ssl-cert":
    setting => "webserver.${container_service}.ssl-cert",
    value   => $ssl_cert,
  }

  pe_hocon_setting { "${container}.webserver.${$container_service}.ssl-key":
    setting => "webserver.${container_service}.ssl-key",
    value   => $ssl_key,
  }

  pe_hocon_setting{ "${container}.webserver.${$container_service}.ssl-crl-path":
    setting => "webserver.${container_service}.ssl-crl-path",
    value   => $hostcrl,
  }

  $access_log_config_ensure = pe_empty($access_log_config) ? {
    true    => absent,
    default => present,
  }

  pe_hocon_setting{ "${container}.webserver.${container_service}.access-log-config":
    ensure  => $access_log_config_ensure,
    setting => "webserver.${container_service}.access-log-config",
    value   => $access_log_config,
  }

  $tk_jetty_max_threads_ensure = pe_empty($tk_jetty_max_threads) ? {
    true    => absent,
    default => present,
  }

  pe_hocon_setting{ "${container}.webserver.${container_service}.max-threads":
    ensure  => $tk_jetty_max_threads_ensure,
    setting => "webserver.${container_service}.max-threads",
    value   => $tk_jetty_max_threads,
  }

  $tk_jetty_request_header_max_size_ensure = pe_empty($tk_jetty_request_header_max_size) ? {
    true    => absent,
    default => present,
  }

  pe_hocon_setting{ "${container}.webserver.${container_service}.request-header-max-size":
    ensure  => $tk_jetty_request_header_max_size_ensure,
    setting => "webserver.${container_service}.request-header-max-size",
    value   => $tk_jetty_request_header_max_size,
  }

  $default_server_ensure = $default_server ? {
    Undef   => absent,
    default => present,
  }

  pe_hocon_setting{ "${container}.webserver.${container_service}.default-server":
    ensure  => $default_server_ensure,
    setting => "webserver.${container_service}.default-server",
    value   => $default_server,
  }

  $ssl_protocols_ensure = pe_empty($ssl_protocols) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting{ "${container}.webserver.${container_service}.ssl-protocols":
    ensure  => $ssl_protocols_ensure,
    setting => "webserver.${container_service}.ssl-protocols",
    type    => 'array',
    value   => $ssl_protocols,
  }

  $ssl_cipher_suites_ensure = pe_empty($ssl_cipher_suites) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting{ "${container}.webserver.${container_service}.cipher-suites":
    ensure  => $ssl_cipher_suites_ensure,
    setting => "webserver.${container_service}.cipher-suites",
    type    => 'array',
    value   => $ssl_cipher_suites,
  }
}
