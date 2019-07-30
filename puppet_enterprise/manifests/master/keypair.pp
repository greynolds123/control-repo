# Generic define for copying puppet keypairs from the compiling master to an additional
# master.
#
# You can either pass in one keypair, or an array.
#
# @param keypair_name [String] The name of the keypair to copy.
#
# @example To copy multiple keypairs at once, you can pass in an array:
#
# $keypairs = ['test1', 'test2', 'test3']
# puppet_enterprise::master::keypair { $keypairs: }
#
# This will copy the cert and public/private keys for test1, test2 and test3
# from one compiling master to the new master.
#
define puppet_enterprise::master::keypair(
  $keypair_name = $title,
){
  File {
    owner   => $puppet_enterprise::params::puppet_user,
    group   => $puppet_enterprise::params::puppet_group,
    mode    => '0640',
  }

  $cert_dir = "${puppet_enterprise::params::ssl_dir}/certs"
  $private_key_dir = "${puppet_enterprise::params::ssl_dir}/private_keys"
  $public_key_dir = "${puppet_enterprise::params::ssl_dir}/public_keys"

  file { "${keypair_name}.cert.pem":
    path    => "${cert_dir}/${keypair_name}.pem",
    content => file("${cert_dir}/${keypair_name}.pem", '/dev/null'),
  }

  file { "${keypair_name}.private_key.pem":
    path    => "${private_key_dir}/${keypair_name}.pem",
    content => file("${private_key_dir}/${keypair_name}.pem", '/dev/null'),
  }

  file { "${keypair_name}.public_key.pem":
    path    => "${public_key_dir}/${keypair_name}.pem",
    content => file("${public_key_dir}/${keypair_name}.pem", '/dev/null'),
  }
}
