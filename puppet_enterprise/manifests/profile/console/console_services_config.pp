# Profile for configuring console services.
#
#
# @param certname [String] The certname the console will use to encrypt network traffic.
# @param listen_address [String] The network interface used by the console service.
# @param ssl_listen_address [String] The network interface used by console services for ssl connections.
# @param listen_port [Integer] The port that console services is listening on.
# @param ssl_listen_port [Integer] The port that console services is listening on for ssl
#        connections.
# @param api_listen_port [Integer] The port that the console services api is listening on.
# @param api_ssl_listen_port [Integer] The port that console services is listening on for ssl
#        connections.
# @param activity_url_prefix [String] The url prefix for the activity api.
# @param classifier_url_prefix [String] The url prefix for the classifier api.
# @param rbac_url_prefix [String] The url prefix for the rbac api.
# @param localcacert [String] The path to the local CA certificate. This will be used instead of the
#        CA that is in Puppet's ssl dir.
# @param tk_jetty_max_threads_api [Integer] Maximum number of threads that jetty will devote to the
#        console api. Default 100.
# @param tk_jetty_max_threads_console [Integer] Maximum number of threads that jetty will devote to
#        the console ui. Default 100.
# @param tk_jetty_request-header_max_size [Integer] Sets the maximum size of an HTTP Request Header.
# @param status_proxy_enabled [Boolean] Enabled the plaintext HTTP proxy for the status service
# @param status_proxy_port [Integer] The port that the plaintext HTTP status proxy listens on.
class puppet_enterprise::profile::console::console_services_config (
  $activity_url_prefix                            = $puppet_enterprise::activity_url_prefix,
  $api_listen_port                                = $puppet_enterprise::params::console_services_api_listen_port,
  $api_ssl_listen_port                            = $puppet_enterprise::api_port,
  $certname                                       = $::clientcert,
  $classifier_url_prefix                          = $puppet_enterprise::classifier_url_prefix,
  $listen_address                                 = $puppet_enterprise::params::plaintext_address,
  $listen_port                                    = $puppet_enterprise::params::console_services_listen_port,
  $localcacert                                    = $puppet_enterprise::params::localcacert,
  $rbac_url_prefix                                = $puppet_enterprise::rbac_url_prefix,
  $ssl_listen_address                             = $puppet_enterprise::params::ssl_address,
  $ssl_listen_port                                = $puppet_enterprise::params::console_services_ssl_listen_port,
  $status_proxy_enabled                           = false,
  $status_proxy_port                              = 8123,
  Optional[Integer] $tk_jetty_max_threads_api     = undef,
  Optional[Integer] $tk_jetty_max_threads_console = undef,
  $tk_jetty_request_header_max_size               = 65536,
) inherits puppet_enterprise {

  File {
    ensure => present,
    owner  => 'pe-console-services',
    group  => 'pe-console-services',
    mode   => '0640',
  }

  Pe_concat {
    owner  => 'pe-console-services',
    group  => 'pe-console-services',
    mode   => '0640',
  }

  Pe_hocon_setting {
    ensure  => present,
    notify  => Service["pe-console-services"],
  }

  $cert_dir = $puppet_enterprise::console_services_ssl_dir
  # puppet_enterprise::certs { 'pe-console-services' : ... } -> creates these files
  $ssl_key = "${cert_dir}/${certname}.private_key.pem"
  $ssl_cert =  "${cert_dir}/${certname}.cert.pem"

  $confdir = '/etc/puppetlabs/console-services'
  $access_log_config = "${confdir}/request-logging.xml"
  # Uses
  #   $listen_address
  #   $listen_port
  #   $ssl_listen_address
  #   $ssl_listen_port
  #   $ssl_key
  #   $ssl_cert
  #   $localcacert
  #   $access_log_config
  #   $api_listen_port
  #   $api_ssl_listen_port
  #   $classifier_url_prefix
  #   $rbac_url_prefix
  #   $activity_url_prefix
  #   $tk_jetty_max_threads_console
  #   $tk_jetty_max_threads_api
  #   $tk_jetty_request_header_max_size
  file { "${confdir}/conf.d/webserver.conf":
    ensure => present,
  }

  # pe-console-services package lays down default values, we need to clear them out.
  pe_hocon_setting{ 'console-services.webserver.host':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.host',
  }
  pe_hocon_setting{ 'console-services.webserver.port':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.port',
  }
  pe_hocon_setting{ 'console-services.webserver.ssl-host':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-host',
  }
  pe_hocon_setting{ 'console-services.webserver.ssl-port':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-port',
  }
  pe_hocon_setting{ 'console-services.webserver.ssl-cert':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-cert',
  }
  pe_hocon_setting{ 'console-services.webserver.ssl-key':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-key',
  }
  pe_hocon_setting{ 'console-services.webserver.ssl-ca-cert':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-ca-cert',
  }

  pe_hocon_setting{ 'webserver.console.access-log-config':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.access-log-config',
    value   => $access_log_config,
  }
  pe_hocon_setting{ 'webserver.console.host':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.host',
    value   => $listen_address,
  }
  pe_hocon_setting{ 'webserver.console.port':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.port',
    value   => $listen_port,
  }
  if $tk_jetty_max_threads_console {
    $tk_jetty_max_threads_console_ensure = present
  } else {
    $tk_jetty_max_threads_console_ensure = absent
  }

  pe_hocon_setting{ 'webserver.console.max-threads':
    ensure  => $tk_jetty_max_threads_console_ensure,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.max-threads',
    value   => $tk_jetty_max_threads_console,
  }

  pe_hocon_setting{ 'webserver.console.default-server':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.default-server',
    value   => true,
  }
  pe_hocon_setting{ 'webserver.console.request-header-max-size':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.request-header-max-size',
    value   => $tk_jetty_request_header_max_size,
  }

  pe_hocon_setting{ 'webserver.console.ssl-host':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.ssl-host',
    value   => $ssl_listen_address,
  }
  pe_hocon_setting{ 'webserver.console.ssl-port':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.ssl-port',
    value   => $ssl_listen_port,
  }
  pe_hocon_setting{ 'webserver.console.ssl-key':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.ssl-key',
    value   => $ssl_key,
  }
  pe_hocon_setting{ 'webserver.console.ssl-cert':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.ssl-cert',
    value   => $ssl_cert,
  }
  pe_hocon_setting{ 'webserver.console.ssl-ca-cert':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.ssl-ca-cert',
    value   => $localcacert,
  }
  pe_hocon_setting{ 'webserver.console.client-auth':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.console.client-auth',
    value   => 'none',
  }

  pe_hocon_setting{ 'webserver.api.access-log-config':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.access-log-config',
    value   => $access_log_config,
  }
  pe_hocon_setting{ 'webserver.api.host':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.host',
    value   => $listen_address,
  }
  pe_hocon_setting{ 'webserver.api.port':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.port',
    value   => $api_listen_port,
  }
  if $tk_jetty_max_threads_api {
    $tk_jetty_max_threads_api_ensure = present
  } else {
    $tk_jetty_max_threads_api_ensure = absent
  }

  pe_hocon_setting{ 'webserver.api.max-threads':
    ensure  => $tk_jetty_max_threads_api_ensure,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.max-threads',
    value   => $tk_jetty_max_threads_api,
  }

  pe_hocon_setting{ 'webserver.api.ssl-host':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.ssl-host',
    value   => $ssl_listen_address,
  }
  pe_hocon_setting{ 'webserver.api.ssl-port':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.ssl-port',
    value   => $api_ssl_listen_port,
  }
  pe_hocon_setting{ 'webserver.api.ssl-key':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.ssl-key',
    value   => $ssl_key,
  }
  pe_hocon_setting{ 'webserver.api.ssl-cert':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.ssl-cert',
    value   => $ssl_cert,
  }
  pe_hocon_setting{ 'webserver.api.ssl-ca-cert':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.ssl-ca-cert',
    value   => $localcacert,
  }
  pe_hocon_setting{ 'webserver.api.client-auth':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.api.client-auth',
    value   => 'want',
  }

  $_status_proxy_ensure = $status_proxy_enabled ? {
    true    => 'present',
    default => 'absent',
  }

  pe_hocon_setting { 'webserver.status-proxy':
    ensure  => $_status_proxy_ensure,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.status-proxy',
    value   => { host => '0.0.0.0', port => $status_proxy_port },
  }

  pe_hocon_setting{ 'web-router-service."puppetlabs.activity.services/activity-service"':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.activity.services/activity-service"',
    type    => 'hash',
    value   => { route => $activity_url_prefix, server => 'api' },
  }

  pe_hocon_setting{ 'web-router-service."puppetlabs.rbac.services.http.api/rbac-http-api-service"':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.rbac.services.http.api/rbac-http-api-service"',
    type    => 'hash',
    value   => { route => $rbac_url_prefix, server => 'api' },
  }

  pe_hocon_setting{ 'web-router-service."puppetlabs.pe-console-ui.service/pe-console-ui-service".pe-console-app':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.pe-console-ui.service/pe-console-ui-service".pe-console-app',
    type    => 'hash',
    value   => { route => '/', server => 'console' },
  }

  pe_hocon_setting{ 'web-router-service."puppetlabs.pe-console-auth-ui.service/pe-console-auth-ui-service".authn-app':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.pe-console-auth-ui.service/pe-console-auth-ui-service".authn-app',
    type    => 'hash',
    value   => { route => '/auth', server => 'console' },
  }

  pe_hocon_setting{ 'web-router-service."puppetlabs.classifier.main/classifier-service"':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.classifier.main/classifier-service"',
    type    => 'hash',
    value   => { route => $classifier_url_prefix, server => 'api' },
  }

  pe_hocon_setting{ 'web-router-service."puppetlabs.trapperkeeper.services.status.status-service/status-service"':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.trapperkeeper.services.status.status-service/status-service"',
    type    => 'hash',
    value   => { route => '/status', server => 'api' },
  }

  pe_hocon_setting { 'web-router-service."puppetlabs.trapperkeeper.services.status.status-proxy-service/status-proxy-service"':
    ensure  => $_status_proxy_ensure,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.trapperkeeper.services.status.status-proxy-service/status-proxy-service"',
    type    => 'hash',
    value   => { route => '/status', server => 'status-proxy' },
  }

  pe_hocon_setting { 'status-proxy':
    ensure  => $_status_proxy_ensure,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'status-proxy',
    type    => 'hash',
    value   => { 'proxy-target-url' => "https://${listen_address}:${api_ssl_listen_port}/status",
    'ssl-opts' => {'ssl-cert' => $ssl_cert, 'ssl-key' => $ssl_key, 'ssl-ca-cert' => $localcacert }},
  }

  #######################################################################################
  # There are several PE 3.8 console-services web routes which must be removed on upgrade
  pe_hocon_setting{ 'web-router-service.remove-rbac-ui-service':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.rbac-ui.service/rbac-ui-service"',
  }

  pe_hocon_setting{ 'web-router-service.remove-helpers-service':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.proxy.services.proxy/helpers-service"',
  }

  pe_hocon_setting{ 'web-router-service.remove-classifier-ui-service':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'web-router-service."puppetlabs.classifier-ui.service/classifier-ui-service"',
  }
  # End removal of PE 3.8 console-services web routes
  #######################################################################################

  $log_config = "${confdir}/logback.xml"
  $version_file = "${puppet_enterprise::puppet_server_dir}/pe_version"

  # Uses
  #   $log_config
  #   $version_file
  file { "${confdir}/conf.d/global.conf":
    ensure => present,
  }
  pe_hocon_setting{ 'global.logging-config':
    path    => "${confdir}/conf.d/global.conf",
    setting => 'global.logging-config',
    value   => $log_config,
  }
  pe_hocon_setting{ 'global.version-path':
    path    => "${confdir}/conf.d/global.conf",
    setting => 'global.version-path',
    value   => $version_file,
  }
  pe_hocon_setting{ 'global.login-path':
    path    => "${confdir}/conf.d/global.conf",
    setting => 'global.login-path',
    value   => '/auth/login',
  }

  pe_concat { "${confdir}/bootstrap.cfg" : }
}
