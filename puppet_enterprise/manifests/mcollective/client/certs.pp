# Responsible for copying certificates around for the proper
# configuration of mcollective.
#
# Because the mcollective client runs as it's own user, we need to copy the certificates
# to their home directory since that user will not have access to the main puppetlabs ssl dir.
#
# An mcollective client needs the following certs and keypairs:
#   - The clients keypair
#   - The shared MCO public key
#   - The CA cert that AMQ uses for encryption
#   - A Private key that has been signed by the above CA
#   - The corresponding certificate to that private key.
#
# For the last three, we will reuse the nodes agent certificate and the PE CA cert.
# This prevents us from having to manage yet another set of certificates.

# This code assumes that the MCO Client's certificate has already been generated and is available on
# all masters. To help faciliate that task, @see puppet_enterprise::master::keypair
#
# @param client_name [String] The mcollective client's name. This is used to set the owner and group of
#           the certificates as well.
# @param destination_dir [String] The directory where the certificates and keypairs should go. This is
#           usually in a folder called `.mcollective.d` located in the client's home directory. Wherever
#           they go, the system user should be able to read them.
# @param keypair_name [String] The name of the clients keypair.
define puppet_enterprise::mcollective::client::certs(
  $client_name,
  $destination_dir,
  $keypair_name = $title,
){
  include puppet_enterprise::params

  $ssl_dir = $puppet_enterprise::params::ssl_dir

  File {
    owner   => $client_name,
    group   => $client_name,
    mode    => '0400',
  }

  file { $destination_dir:
    ensure => directory,
    mode    => '0700',
  }

  file { "${destination_dir}/ca.cert.pem":
    source => $puppet_enterprise::params::localcacert
  }

  file { "${destination_dir}/${::clientcert}.cert.pem":
    source => "${ssl_dir}/certs/${::clientcert}.pem",
  }

  file { "${destination_dir}/${::clientcert}.private_key.pem":
    source => "${ssl_dir}/private_keys/${::clientcert}.pem",
  }

  file { "${destination_dir}/${client_name}-private.pem":
    content => file("${ssl_dir}/private_keys/${keypair_name}.pem",
                    "${destination_dir}/${client_name}-private.pem",
                    '/dev/null'),
  }

  file { "${destination_dir}/${client_name}-public.pem":
    content => file("${ssl_dir}/public_keys/${keypair_name}.pem",
                    "${destination_dir}/${client_name}-public.pem",
                    '/dev/null'),
  }

  file { "${destination_dir}/${puppet_enterprise::params::mco_server_name}-public.pem":
    content => file("${ssl_dir}/public_keys/${puppet_enterprise::params::mco_server_keypair_name}.pem",
                    "${destination_dir}/${puppet_enterprise::params::mco_server_name}-public.pem",
                    '/dev/null'),
  }
}
