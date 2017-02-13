# This class is for managing the configuration file for PuppetDB's Trapperkeeper
# jetty instance.
#
# @param certname [String] Name of the clients certificate
# @param cert_whitelist_path [String] Path to the certificate-whitelist file
# @param confdir [String] The path to PuppetDB's confdir
# @param listen_address [String] The address which the database is listening on
#        for plain text connections
# @param listen_port [Integer] The port which PuppetDB Listens on for plain text connections
# @param localcacert [String] The path to the local CA certificate
# @param ssl_dir [String] The directory where Puppet's ssl directory
# @param ssl_listen_address [String] The address which the database is
#        listening on for SSL connections
# @param ssl_listen_port [Integer] The port which PuppetDB Listens on for SSL connections
# @param tk_jetty_max_threads [Integer] The maximum number of threads that
#        Trapperkeeper's Jetty server can spin up.
# @param tk_jetty_request-header_max_size [Integer] Sets the maximum size of an HTTP Request Header.
class puppet_enterprise::puppetdb::jetty_ini(
  $certname,
  $cert_whitelist_path,
  $confdir                          = $puppet_enterprise::params::puppetdb_confdir,
  $listen_address                   = $puppet_enterprise::params::plaintext_address,
  $listen_port                      = $puppet_enterprise::params::puppetdb_listen_port,
  $localcacert                      = $puppet_enterprise::params::localcacert,
  $ssl_dir                          = $puppet_enterprise::params::puppetdb_ssl_dir,
  $ssl_listen_address               = $puppet_enterprise::params::ssl_address,
  $ssl_listen_port                  = $puppet_enterprise::params::puppetdb_ssl_listen_port,
  $tk_jetty_max_threads             = undef,
  $tk_jetty_request_header_max_size = 65536,
) inherits puppet_enterprise::params {

  file { "${confdir}/jetty.ini":
    ensure  => present,
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb']
  }

  #Set the defaults
  Pe_ini_setting {
    ensure  => present,
    path    => "${confdir}/jetty.ini",
    section => 'jetty',
    require => File["${confdir}/jetty.ini"]
  }

  if pe_empty($listen_port) {
    pe_ini_setting {'puppetdb_host':
      ensure  => absent,
      setting => 'host',
    }
    pe_ini_setting {'puppetdb_port':
      ensure  => absent,
      setting => 'port',
    }
  } else {
    pe_ini_setting {'puppetdb_host':
      setting => 'host',
      value   => $listen_address,
    }

    pe_ini_setting {'puppetdb_port':
      setting => 'port',
      value   => $listen_port,
    }
  }

  pe_ini_setting {'puppetdb_sslhost':
    setting => 'ssl-host',
    value   => $ssl_listen_address,
  }

  pe_ini_setting {'puppetdb_sslport':
    setting => 'ssl-port',
    value   => $ssl_listen_port,
  }

  pe_ini_setting {'puppetdb_ssl_key':
    setting => 'ssl-key',
    value   => "${ssl_dir}/${certname}.private_key.pem",
  }

  pe_ini_setting {'puppetdb_ssl_cert':
    setting => 'ssl-cert',
    value   => "${ssl_dir}/${certname}.cert.pem",
  }

  pe_ini_setting {'puppetdb_ssl_ca_cert':
    setting => 'ssl-ca-cert',
    value   => $localcacert,
  }

  pe_ini_setting {'puppetdb_client_auth':
    setting => 'client-auth',
    value   => 'want',
  }

  pe_ini_setting { 'puppetdb-certificate-whitelist':
    section => 'puppetdb',
    setting => 'certificate-whitelist',
    value   => $cert_whitelist_path,
    require => File[$cert_whitelist_path],
  }

  if $tk_jetty_max_threads != undef {
    pe_ini_setting {'puppetdb_max-threads':
      setting => 'max-threads',
      value   => $tk_jetty_max_threads,
    }
  }

  pe_ini_setting {'puppetdb_request_header_max_size':
    setting => 'request-header-max-size',
    value   => $tk_jetty_request_header_max_size,
  }
}
