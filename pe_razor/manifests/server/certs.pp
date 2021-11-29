# Class that generates the client key and cert
# for the razor-server
define pe_razor::server::certs(
  $ca_cert,
  $ca_key,
  $common_name = 'razor',
) {
  include pe_razor::params

  if $ca_cert == undef or $ca_key == undef {
    fail('Must pass in both the CA certificate and CA key file to generate the pe-razor-server client cert')
  }

  $openssl_days_valid = $pe_razor::params::openssl_days_valid

  # The pk8 key is necessary for JDBC to connect to our
  # DB
  $client_cert = $pe_razor::params::razor_client_cert
  $client_csr = $pe_razor::params::razor_client_csr
  $client_key = $pe_razor::params::razor_client_key
  $client_pk8_key = $pe_razor::params::razor_client_pk8_key

  file { $pe_razor::params::razor_ssl :
    ensure => directory,
  }

  pe_razor::ssl::private_key { $client_key :
    pk8_path => $client_pk8_key,
    require  =>  File[$pe_razor::params::razor_ssl],
  }

  pe_razor::generated_file { $client_csr :
    command => "openssl req -new -key ${client_key} -out ${client_csr} -subj '/CN=${common_name}'",
    require => Pe_razor::Ssl::Private_key[$client_key],
  }

  pe_razor::generated_file { $client_cert :
    command => "openssl x509 -req -days ${openssl_days_valid} -in ${client_csr} -CA ${ca_cert} -CAkey ${ca_key} -out ${client_cert} -CAcreateserial",
    require => Pe_razor::Generated_file[$client_csr],
  }
}
