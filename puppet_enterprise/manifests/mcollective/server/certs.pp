# Responsible for copying certificates around for the proper
# configuration of a mcollective server.
#
# Because of the user that runs mcollective, the certs need to be copied
# into a place that the mcollective process can read them.
#
# An mcollective server needs the following certs and keypairs:
#   - All MCO clients public key's
#   - The shared MCO public key
#   - The CA cert that AMQ uses for encryption
#   - A Private key that has been signed by the above CA
#   - The corresponding certificate to that private key.
#
# For the last three, we will reuse the nodes agent certificate and the PE CA cert.
# This prevents us from having to manage yet another set of certificates.
#
# For the shared keypair and client's public keys, we load them via the file function, which
# will look for them on the compiling masters system instead of the agent. Because of that,
# this code assumes that the MCO Client's certificate has already been generated and is available on
# all masters. To help faciliate that task, @see puppet_enterprise::master::keypair
class puppet_enterprise::mcollective::server::certs {
  include puppet_enterprise::params
  include puppet_enterprise::mcollective::service

  $cert_dir             = $puppet_enterprise::params::mco_ssl_dir
  $mco_clients_cert_dir = $puppet_enterprise::params::mco_clients_cert_dir
  $ssl_dir              = $puppet_enterprise::params::ssl_dir

  File {
    owner   => $puppet_enterprise::params::root_user,
    group   => $puppet_enterprise::params::root_group,
    mode    => '0660',
    notify  => Service['mcollective'],
  }

  file { [$cert_dir, $mco_clients_cert_dir]:
    ensure => directory
  }

  file { "${cert_dir}/ca.cert.pem":
    source => $puppet_enterprise::params::localcacert,
  }

  file { "${cert_dir}/${::clientcert}.cert.pem":
    source => "${ssl_dir}/certs/${::clientcert}.pem",
  }

  file { "${cert_dir}/${::clientcert}.private_key.pem":
    source => "${ssl_dir}/private_keys/${::clientcert}.pem",
  }

  file { "${cert_dir}/${puppet_enterprise::params::mco_server_name}-private.pem":
    content => file("/etc/puppetlabs/puppet/ssl/private_keys/${puppet_enterprise::params::mco_server_keypair_name}.pem",
                    "${cert_dir}/${puppet_enterprise::params::mco_server_name}-private.pem",
                    '/dev/null'),
  }

  file { "${cert_dir}/${puppet_enterprise::params::mco_server_name}-public.pem":
    content => file("/etc/puppetlabs/puppet/ssl/public_keys/${puppet_enterprise::params::mco_server_keypair_name}.pem",
                    "${cert_dir}/${puppet_enterprise::params::mco_server_name}-public.pem",
                    '/dev/null'),
  }

  file { "${mco_clients_cert_dir}/${puppet_enterprise::params::mco_console_client_name}-public.pem":
    content => file("/etc/puppetlabs/puppet/ssl/public_keys/${puppet_enterprise::params::mco_console_keypair_name}.pem",
                    "${mco_clients_cert_dir}/${puppet_enterprise::params::mco_console_client_name}-public.pem",
                    '/dev/null'),
  }

  file { "${mco_clients_cert_dir}/${puppet_enterprise::params::mco_peadmin_client_name}-public.pem":
    content => file("/etc/puppetlabs/puppet/ssl/public_keys/${puppet_enterprise::params::mco_peadmin_keypair_name}.pem",
                    "${mco_clients_cert_dir}/${puppet_enterprise::params::mco_peadmin_client_name}-public.pem",
                    '/dev/null'),
  }
}
