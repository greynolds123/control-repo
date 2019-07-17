# This define type sets up ruby webservers that interact with the
# orchestrator.
#
# @param certname [String] The name of the service SSL certificate.
# @param run_service [Boolean] Should the service be running
# @param ssl_listen_port [Boolean] The port used for SSL connections.
# @param whitelist [Array[String]] Certificates that can be used to make requests to the service.
# @param ssl_cipher_suites [Array[String]] Cipher suites for TLS in preference order.
# @param loglevel [Enum[notice, debug, info, error, warn]] Set service log level.
# @param container [String] The name of the service to run
# @param settings [Hash] Any additional hocon settings to set in the service configuration

define puppet_enterprise::orchestrator::ruby_service(
  String $container,
  Integer $ssl_listen_port,
  String $certname = $facts['clientcert'],
  Boolean $run_service = true,
  Array[String] $whitelist = [$certname],
  Array[String] $ssl_cipher_suites = pe_pick_array($puppet_enterprise::ssl_cipher_suites, $puppet_enterprise::params::secure_ciphers),
  Array[String] $ssl_protocols = $puppet_enterprise::ssl_protocols,
  Enum[notice, debug, info, error, warn] $service_loglevel = 'notice',
  Hash $settings = {},
) {
  include puppet_enterprise::packages

  $conf_dir = "/etc/puppetlabs/${container}/conf.d"
  $ssl_dir =  "/etc/puppetlabs/${container}/ssl"
  $log_file = "/var/log/puppetlabs/${container}/${container}.log"

  $ssl_cert  =  "${ssl_dir}/${certname}.cert.pem"
  $ssl_key = "${ssl_dir}/${certname}.private_key.pem"
  $ssl_ca_cert = $puppet_enterprise::params::localcacert

  # Both bolt-server and plan-executor share the same user,
  # while the ace-server has a different user.
  $service = $container ? {
    'ace-server' => 'ace-server',
    default      => 'bolt-server',
  }
  $user = "pe-${service}"
  $group = "pe-${service}"

  Package <| tag == "pe-${service}-packages" |>

  $executor_conf = "${conf_dir}/${container}.conf"
  file { $executor_conf:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0640',
    require => Package["pe-${service}"],
  }

  Pe_hocon_setting {
    ensure      => present,
    path        => $executor_conf,
    require     => File[$executor_conf],
    notify      => Service["pe-${container}"],
  }

  pe_hocon_setting { "${container}.host":
    setting => "${container}.host",
    value   => '0.0.0.0',
  }

  pe_hocon_setting { "${container}.port":
    setting => "${container}.port",
    value   => $ssl_listen_port,
  }

  pe_hocon_setting { "${container}.ssl-cert":
    setting => "${container}.ssl-cert",
    value   => $ssl_cert,
  }

  pe_hocon_setting { "${container}.ssl-key":
    setting => "${container}.ssl-key",
    value   => $ssl_key,
  }

  pe_hocon_setting { "${container}.ssl-ca-cert":
    setting => "${container}.ssl-ca-cert",
    value   => $ssl_ca_cert,
  }

  pe_hocon_setting { "${container}.loglevel":
    setting => "${container}.loglevel",
    value   => $service_loglevel,
  }

  pe_hocon_setting { "${container}.logfile":
    setting => "${container}.logfile",
    value   => $log_file,
  }

  pe_hocon_setting { "${container}.whitelist":
    setting => "${container}.whitelist",
    type    => 'array',
    value   => $whitelist,
  }

  pe_hocon_setting { "${container}.ssl_cipher_suites":
    setting => "${container}.ssl_cipher_suites",
    type    => 'array',
    value   => $ssl_cipher_suites,
  }

  puppet_enterprise::certs { $container:
    certname      => $certname,
    cert_dir      => $ssl_dir,
    container     => $container,
    package_name  => "pe-${service}",
    full_restart  => [],
    owner         => $user,
    group         => $group,
  }

  $settings.each |String $key, $val| {
    pe_hocon_setting { "${container}.${key}":
      setting => "${container}.${key}",
      value   => $val
    }
  }

  $_service_ensure = $run_service ? { true => 'running', false => 'stopped'}
  service { "pe-${container}" :
    ensure      => $_service_ensure,
    enable      => $run_service,
  }
}
