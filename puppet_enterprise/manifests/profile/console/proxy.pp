# Profile for configuring the pe-webserver to proxy requests for the console service.
#
#
# @param certname [String] The certname the console will use to encrypt network traffic.
# @param dhparam_file [String] The absolute path to the DH Param file to be used with the proxy.
# @param trapperkeeper_proxy_listen_address [String] The network interface used by the
#        trapperkeeper proxy.
# @param trapperkeeper_proxy_listen_port [Integer] The port that the trapperkeeper proxy
#        is listening on.
# @param ssl_listen_address [String] The network interface used for ssl connections.
# @param ssl_listen_port [Integer] The port used for ssl connections.
# @param browser_ssl_cert [String] Sets the path to the server certificate PEM file used
#        by the web service.
# @param Variant[String, Array[String]] ssl_protocols The list of SSL protocols to allow.
# @param browser_ssl_private_key [String] For use with a custom CA, the path to a private
#        key for your public ca certificate.
# @param nginx_gzip [String] Set gzip compression in nginx to on or off
class puppet_enterprise::profile::console::proxy (
  $certname                                 = $facts['clientcert'],
  String $server_name                       = $puppet_enterprise::console_host,
  $dhparam_file                             = '/etc/puppetlabs/nginx/dhparam_puppetproxy.pem',
  $proxy_read_timeout                       = 120,
  $trapperkeeper_proxy_listen_address       = $puppet_enterprise::params::plaintext_address,
  $trapperkeeper_proxy_listen_port          = $puppet_enterprise::params::console_services_listen_port,
  $ssl_ciphers                              = $puppet_enterprise::params::browser_ciphers,
  $ssl_listen_address                       = $puppet_enterprise::params::ssl_address,
  $ssl_listen_port                          = $puppet_enterprise::console_port,
  $ssl_prefer_server_ciphers                = 'on',
  Variant[String, Array[String]] $ssl_protocols = $puppet_enterprise::ssl_protocols,
  $ssl_session_cache                        = 'shared:SSL:50m',
  $ssl_session_timeout                      = '1d',
  $ssl_verify_client                        = 'off',
  $ssl_verify_depth                         = 1,
  Optional[String] $browser_ssl_cert        = undef,
  Optional[String] $browser_ssl_private_key = undef,
  Enum['on','off'] $nginx_gzip              = 'on',
  Puppet_enterprise::Replication_mode $replication_mode = 'none',
) inherits puppet_enterprise {

  # Don't enable the pe-nginx service on replicas
  if $replication_mode == 'replica' {
    class {'pe_nginx':
      ensure => stopped,
      enable => false,
    }
    } else {
      include pe_nginx
    }

  pe_validate_re($ssl_verify_client, '^(on|off|optional|optional_no_ca)$')
  pe_validate_re($ssl_prefer_server_ciphers, '^(on|off)$')
  pe_validate_re($ssl_session_cache, '(^(off|none)$|(builtin:[0-9]+)|(shared:[a-zA-Z]+:[0-9]+[bkmg]?))')
  pe_validate_single_integer($proxy_read_timeout)

  if $browser_ssl_cert != undef and $browser_ssl_private_key == undef {
    fail('browser_ssl_private_key must also be set if setting browser_ssl_cert')
  }
  elsif $browser_ssl_cert == undef and $browser_ssl_private_key != undef {
    fail('browser_ssl_cert must also be set if setting browser_ssl_private_key')
  }

  $console_cert_dir = $puppet_enterprise::console_services_ssl_dir

  $_browser_ssl_cert = $browser_ssl_cert ? {
    undef   => "${console_cert_dir}/${certname}.cert.pem",
    default => $browser_ssl_cert,
  }

  $_browser_ssl_private_key = $browser_ssl_private_key ? {
    undef   => "${console_cert_dir}/${certname}.private_key.pem",
    default => $browser_ssl_private_key,
  }

  $puppetproxy_file = "${puppet_enterprise::nginx_conf_dir}/conf.d/proxy.conf"

  file { $puppetproxy_file:
    ensure  => file,
    owner   => $puppet_enterprise::params::root_user,
    group   => $puppet_enterprise::params::root_group,
    mode    => '0644',
    notify  => Service['pe-nginx'],
    require => Puppet_enterprise::Certs['pe-console-services::server_cert'],
  }

  $default_dhparam_file = '/etc/puppetlabs/nginx/dhparam_puppetproxy.pem'
  file { $default_dhparam_file:
    ensure => file,
    source => 'puppet:///modules/puppet_enterprise/console/dhparam_puppetproxy.pem',
    owner  => $puppet_enterprise::params::root_user,
    group  => $puppet_enterprise::params::root_group,
    mode   => '0644',
    notify => Service['pe-nginx'],
  }

  class { 'puppet_enterprise::profile::console::proxy::nginx_conf' :
    gzip => $nginx_gzip,
  }

  Pe_nginx::Directive {
    directive_ensure => 'present',
    target           => $puppetproxy_file,
    server_context   => $server_name,
  }

  pe_nginx::directive { 'server_name':
    value => $server_name,
  }

  if ($ssl_listen_address and $ssl_listen_address != '0.0.0.0') {
    pe_nginx::directive { 'listen':
      value   => "${ssl_listen_address}:${ssl_listen_port} ssl",
    }
  } else {
    pe_nginx::directive { 'listen':
      value   => "${ssl_listen_port} ssl",
    }
  }

  # --BEGIN SSL CONFIG--
  pe_nginx::directive { 'ssl_certificate':
    value => $_browser_ssl_cert,
  }

  pe_nginx::directive { 'ssl_certificate_key':
    value => $_browser_ssl_private_key,
  }

  pe_nginx::directive { 'ssl_crl':
    value => $puppet_enterprise::params::hostcrl,
  }

  pe_nginx::directive { 'ssl_prefer_server_ciphers':
    value => $ssl_prefer_server_ciphers,
  }

  pe_nginx::directive { 'ssl_ciphers':
    value => pe_join(pe_any2array($ssl_ciphers), ':'),
  }

  pe_nginx::directive { 'ssl_protocols':
    value => pe_join(pe_any2array($ssl_protocols), ' '),
  }

  pe_nginx::directive { 'ssl_dhparam':
    value => $dhparam_file,
  }

  pe_nginx::directive { 'ssl_verify_client':
    value => $ssl_verify_client,
  }

  pe_nginx::directive { 'ssl_verify_depth':
    value => $ssl_verify_depth,
  }

  pe_nginx::directive { 'ssl_session_timeout':
    value => $ssl_session_timeout,
  }

  pe_nginx::directive { 'ssl_session_cache':
    value => $ssl_session_cache,
  }
  # --END SSL CONFIG--

  # --BEGIN LOCATION CONFIG--
  pe_nginx::directive { 'proxy_pass':
    value            => "http://${trapperkeeper_proxy_listen_address}:${trapperkeeper_proxy_listen_port}",
    location_context => '/',
  }

  pe_nginx::directive { 'proxy_redirect':
    value            => "http://${trapperkeeper_proxy_listen_address}:${trapperkeeper_proxy_listen_port} /",
    location_context => '/',
  }

  pe_nginx::directive { 'proxy_read_timeout':
    value            => $proxy_read_timeout,
    location_context => '/',
  }


  pe_nginx::directive { 'proxy_set_header x-ssl-subject':
    directive_name   => 'proxy_set_header',
    value            => 'X-SSL-Subject $ssl_client_s_dn',
    location_context => '/',
    replace_value    => false,
  }

  pe_nginx::directive { 'proxy_set_header x-client-dn':
    directive_name   => 'proxy_set_header',
    value            => 'X-Client-DN $ssl_client_s_dn',
    location_context => '/',
    replace_value    => false,
  }

  pe_nginx::directive { 'proxy_set_header x-client-verify':
    directive_name   => 'proxy_set_header',
    value            => 'X-Client-Verify $ssl_client_verify',
    location_context => '/',
    replace_value    => false,
  }

  pe_nginx::directive { 'proxy_set_header x-forwarded-for':
    directive_name   => 'proxy_set_header',
    value            => 'X-Forwarded-For $proxy_add_x_forwarded_for',
    location_context => '/',
    replace_value    => false,
  }
  # --END LOCATION CONFIG--

  class { 'puppet_enterprise::profile::console::proxy::http_redirect' :
    ssl_listen_port => Integer($ssl_listen_port),
  }

}
