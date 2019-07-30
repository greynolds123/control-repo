class puppet_enterprise::profile::console::proxy::http_redirect (
  Integer $ssl_listen_port,
  Boolean $enable_http_redirect = true,
  String  $server_name          = $puppet_enterprise::console_host,
) {

  $http_redirect_file_ensure = $enable_http_redirect ? {
    true    => file,
    default => absent,
  }

  $redirect_return_base = '301 https://$server_name$request_uri'
  $redirect_return_port = $ssl_listen_port ? {
    443     => '',
    default => ":${ssl_listen_port}"
  }

  file { "${puppet_enterprise::nginx_conf_dir}/conf.d/http_redirect.conf":
    ensure  => $http_redirect_file_ensure,
    owner   => $puppet_enterprise::params::root_user,
    group   => $puppet_enterprise::params::root_group,
    mode    => '0644',
    content => epp('puppet_enterprise/console/http_redirect.conf.epp', {
      server_name  => $server_name,
      return_value => "${redirect_return_base}${redirect_return_port}",
    }),
    notify  => Service['pe-nginx'],
  }

}
