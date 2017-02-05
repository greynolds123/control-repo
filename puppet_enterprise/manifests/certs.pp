# This class configures how Puppet will manage ssl certificates.
#
#
# @param certname [String] The certname the master will use to encrypt network traffic.
# @param cert_dir [String] The path to the directory where Puppet managed certs will be stored. 
# @param group [String] The group assigned to Puppet managed certs.
# @param owner [String] The owner assigned to Puppet managed certs.
# @param ssl_dir [String] The path to the directory where Puppet managed keys will be stored.
define puppet_enterprise::certs(
  $certname,
  $cert_dir,
  $group      = $title,
  $owner      = $title,
  $ssl_dir    = $puppet_enterprise::params::ssl_dir,
  $append_ca  = false,
) {

  File {
    owner   => $owner,
    group   => $group,
    mode    => '0400',
  }

  if $append_ca {
    pe_concat { "${cert_dir}/${certname}.cert.pem":
      owner  => $owner,
      group  => $group,
      mode   => '0400',
      ensure => present,
    }
    pe_concat::fragment { "${cert_dir}/${certname}.cert.pem":
      target  => "${cert_dir}/${certname}.cert.pem",
      source  => "${ssl_dir}/certs/${certname}.pem",
      order   => 1,
    }
    pe_concat::fragment { "${ssl_dir}/certs/ca.pem":
      target  => "${cert_dir}/${certname}.cert.pem",
      source  => "${ssl_dir}/certs/ca.pem",
      order   => 2,
    }
  } else {
    file { "${cert_dir}/${certname}.cert.pem":
      source => "${ssl_dir}/certs/${certname}.pem",
    }
  }

  file { "${cert_dir}/${certname}.private_key.pem":
    source => "${ssl_dir}/private_keys/${certname}.pem",
  }

  file { "${cert_dir}/${certname}.public_key.pem":
    source => "${ssl_dir}/public_keys/${certname}.pem",
  }
}
