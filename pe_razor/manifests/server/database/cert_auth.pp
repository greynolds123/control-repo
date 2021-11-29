define pe_razor::server::database::cert_auth(
  $pgsql_data_dir,
) {
  include pe_razor::params

  $openssl_days_valid = $pe_razor::params::openssl_days_valid

  $server_key  = $pe_razor::params::pgsql_server_key
  $server_cert = $pe_razor::params::pgsql_server_cert
  $fqdn = $facts['fqdn']

  # Generate server_key and server_cert. The server cert
  # is self-signed and will serve as the CA. In the future,
  # parametrize the CA, generate the server.cert from it, then
  # have Postgres use the passed-in CA as the ssl_ca_file
  pe_razor::ssl::private_key { $server_key :
  }

  pe_razor::generated_file { $server_cert :
    command => "openssl req -x509 -new -days ${openssl_days_valid} -key ${server_key} -out ${server_cert} -subj '/CN=${fqdn}'",
    require => Pe_razor::Ssl::Private_key[$server_key],
  }

  pe_postgresql::server::config_entry { 'ssl_ca_file' :
    value   => $server_cert,
  }

  # Create rules in pg_hba.conf to use hostssl with clientcert = 1
  # for our Razor DB
  $localhost = {
    'ipv4' => '127.0.0.1/32',
    'ipv6' => '::1/128',
  }
  $localhost.each |$protocol, $ip| {
    pe_postgresql::server::pg_hba_rule { "cert auth for localhost (${protocol})":
      type        => 'hostssl',
      user        => 'all',
      database    => 'all',
      address     => $ip,
      auth_method => 'cert',
      auth_option => 'clientcert=1',
    }
  }

  pe_postgresql::server::config_entry { 'ssl' :
    value => 'on',
  }
  pe_postgresql::server::config_entry { 'ssl_cert_file' :
    value => $pe_razor::params::pgsql_server_cert,
  }
  pe_postgresql::server::config_entry { 'ssl_key_file' :
    value => $pe_razor::params::pgsql_server_key,
  }

}
