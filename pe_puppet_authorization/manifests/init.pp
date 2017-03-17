define pe_puppet_authorization (
  Integer $version = 1,
  Boolean $allow_header_cert_info = false,
  Boolean $replace = false,
  String $path = $name,
){
  pe_validate_absolute_path($path)

  pe_concat { $name:
    path    => $path,
    replace => $replace,
  }

  pe_concat::fragment { "00_header_${name}":
    target  => $name,
    content => "authorization: {
  rules: []
",
  }

  pe_concat::fragment { "99_footer_${name}":
    target  => $name,
    content => "}
",
  }

  pe_hocon_setting { "authorization.version.${name}":
    path    => $path,
    setting => 'authorization.version',
    value   => $version,
    require => Pe_concat[$name],
  }

  pe_hocon_setting { "authorization.allow-header-cert-info.${name}":
    path    => $path,
    setting => 'authorization.allow-header-cert-info',
    value   => $allow_header_cert_info,
    require => Pe_concat[$name],
  }
}
