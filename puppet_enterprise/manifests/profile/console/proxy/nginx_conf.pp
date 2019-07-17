# Sub class for configuring nginx.conf for console service.
#
#
# @param nginx_config_file [String] Path to the nginx config file
# @param gzip Enum['on','off'] Wheter to enable gzip
# @param gzip_comp_level Integer[1,9] Sets a gzip compression level of a response.
#        Acceptable values are in the range from 1 to 9.
# @param gzip_min_length Integer Sets the minimum length of a response that will be gzipped.
# @param gzip_proxied [String] Enables or disables gzipping of responses for proxied
#        requests depending on the request and response.
# @param gzip_vary Enum['on','off'] Enables or disables inserting the
#        "Vary: Accept-Encoding" response header field
# @param gzip_types [String] Enables gzipping of responses for the specified MIME types

class puppet_enterprise::profile::console::proxy::nginx_conf (
  Enum['on','off'] $gzip,
  String           $nginx_config_file = "${puppet_enterprise::nginx_conf_dir}/nginx.conf",
  Integer[1,9]     $gzip_comp_level = 5,
  Integer          $gzip_min_length = 256,
  String           $gzip_proxied    = 'any',
  Enum['on','off'] $gzip_vary       = 'on',
  Array[String]    $gzip_types      = [
    'application/atom+xml',
    'application/javascript',
    'application/json',
    'application/ld+json',
    'application/manifest+json',
    'application/rss+xml',
    'application/vnd.geo+json',
    'application/vnd.ms-fontobject',
    'application/x-font-ttf',
    'application/x-web-app-manifest+json',
    'application/xhtml+xml',
    'application/xml',
    'font/opentype',
    'image/bmp',
    'image/svg+xml',
    'image/x-icon',
    'text/cache-manifest',
    'text/css',
    'text/plain',
    'text/vcard',
    'text/vnd.rim.location.xloc',
    'text/vtt',
    'text/x-component',
    'text/x-cross-domain-policy',
    'text/javascript'
  ],
) {

  Pe_nginx::Directive {
    target           => $nginx_config_file,
    server_context   => undef,
    location_context => undef,
    notify           => Service['pe-nginx'],
  }

  pe_nginx::directive { 'gzip' :
    directive_ensure => 'present',
    value            => $gzip,
  }

  $gzip_directive_ensure = $gzip ? {
    'on'  => 'present',
    'off' => 'absent'
  }

  pe_nginx::directive { 'gzip_comp_level' :
    directive_ensure => $gzip_directive_ensure,
    value            => $gzip_comp_level,
  }

  pe_nginx::directive { 'gzip_min_length' :
    directive_ensure => $gzip_directive_ensure,
    value            => $gzip_min_length,
  }

  pe_nginx::directive { 'gzip_proxied' :
    directive_ensure => $gzip_directive_ensure,
    value            => $gzip_proxied,
  }

  pe_nginx::directive { 'gzip_vary' :
    directive_ensure => $gzip_directive_ensure,
    value            => $gzip_vary,
  }

  $_joined_gzip_types_str = pe_join($gzip_types, "\n")

  pe_nginx::directive { 'gzip_types' :
    directive_ensure => $gzip_directive_ensure,
    value            => $_joined_gzip_types_str,
  }

}
