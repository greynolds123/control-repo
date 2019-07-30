# This profile sets up the PE Bolt Server service.
# @param certname [String] The name of the service SSL certificate.
# @param run_service [Boolean] Should the service be running
# @param ssl_listen_port [Boolean] The port used for SSL connections.
# @param master_host [String] The hostname of the Puppet Master.
# @param master_port [Integer] The port of the Puppet Master.
# @param whitelist [Array[String]] Certificates that can be used to make requests to the service.
# @param ssl_cipher_suites [Array[String]] Cipher suites for TLS in preference order.
# @param loglevel [Enum[notice, debug, info, error, warn]] Set service log level.
# @param container [String] The name of the service to run
# @param settings [Hash] Any additional hocon settings to set in the service configuration

class puppet_enterprise::profile::bolt_server(
  Integer $ssl_listen_port = $puppet_enterprise::bolt_server_port,
  String $certname = $facts['clientcert'],
  String $master_host = $puppet_enterprise::puppet_master_host,
  Integer $master_port = $puppet_enterprise::puppet_master_port,
  Boolean $run_service = true,
  Array[String] $whitelist = [$certname],
  Array[String] $ssl_cipher_suites = $puppet_enterprise::params::secure_ciphers,
  Enum[notice, debug, info, error, warn] $service_loglevel = 'notice',
  Integer $concurrency = $puppet_enterprise::bolt_server_concurrency,
  Hash $settings = {},
) {
  $container = 'bolt-server'

  puppet_enterprise::orchestrator::ruby_service { $container:
    container => $container,
    ssl_listen_port => $ssl_listen_port,
    certname => $certname,
    run_service => $run_service,
    whitelist => $whitelist,
    ssl_cipher_suites => $ssl_cipher_suites,
    service_loglevel => $service_loglevel,
    settings => {'concurrency' => $concurrency,
                 'cache-dir' => "/opt/puppetlabs/server/data/${container}/cache",
                 'file-server-uri' => "https://${master_host}:${master_port}",
    } + $settings
  }
}
