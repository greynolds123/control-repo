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
# @param browser_ssl_private_key [String] For use with a custom CA, the path to a private
#        key for your public ca certificate.
# @param browser_ssl_cert_chain [String] For use with a custom CA, the path to the ca certificate.
# @param browser_ssl_ca_cert [String] For use with a custom CA, the path to the certificate.
# @param nginx_gzip [String] Set gzip compression in nginx to on or off
class puppet_enterprise::profile::console::proxy (
  $certname                                 = $::clientcert,
  $dhparam_file                             = '/etc/puppetlabs/nginx/dhparam_puppetproxy.pem',
  $proxy_read_timeout                       = 120,
  $trapperkeeper_proxy_listen_address       = $puppet_enterprise::params::plaintext_address,
  $trapperkeeper_proxy_listen_port          = $puppet_enterprise::params::console_services_listen_port,
  $ssl_ciphers                              = 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA',
  $ssl_listen_address                       = $puppet_enterprise::params::ssl_address,
  $ssl_listen_port                          = $puppet_enterprise::console_port,
  $ssl_prefer_server_ciphers                = 'on',
  $ssl_protocols                            = 'TLSv1 TLSv1.1 TLSv1.2',
  $ssl_session_cache                        = 'shared:SSL:50m',
  $ssl_session_timeout                      = '1d',
  $ssl_verify_client                        = 'off',
  $ssl_verify_depth                         = 1,
  Optional[String] $browser_ssl_cert        = undef,
  Optional[String] $browser_ssl_private_key = undef,
  $browser_ssl_cert_chain                   = undef,
  $browser_ssl_ca_cert                      = undef,
  Enum['on','off'] $nginx_gzip              = 'on'
) inherits puppet_enterprise {
  include pe_nginx

  pe_validate_re($ssl_verify_client, '^(on|off|optional|optional_no_ca)$')
  pe_validate_re($ssl_prefer_server_ciphers, '^(on|off)$')
  pe_validate_re($ssl_session_cache, '(^(off|none)$|(builtin:[0-9]+)|(shared:[a-zA-Z]+:[0-9]+[bkmg]?))')
  pe_validate_single_integer($proxy_read_timeout)

  if ($browser_ssl_cert_chain != undef) {
    warning('Please use the node classifier to remove the parameter browser_ssl_cert_chain from the puppet_enterprise::profile::console::proxy class.')
  }

  if ($browser_ssl_ca_cert != undef) {
    warning('Please use the node classifier to remove the parameter browser_ssl_ca_cert from the puppet_enterprise::profile::console::proxy class.')
  }

  if $browser_ssl_cert != undef and $browser_ssl_private_key == undef {
    fail("browser_ssl_private_key must also be set if setting browser_ssl_cert")
  }
  elsif $browser_ssl_cert == undef and $browser_ssl_private_key != undef {
    fail("browser_ssl_cert must also be set if setting browser_ssl_private_key")
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

  $puppetproxy_file = '/etc/puppetlabs/nginx/conf.d/proxy.conf'

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
    server_context   => $puppet_enterprise::console_host,
  }

  pe_nginx::directive { 'server_name':
    value => $puppet_enterprise::console_host,
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
    value => $ssl_ciphers,
  }

  pe_nginx::directive { 'ssl_protocols':
    value => $ssl_protocols,
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
}
