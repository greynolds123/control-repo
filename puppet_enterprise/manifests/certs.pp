# This class configures how Puppet will manage ssl certificates.
#
#
# @param certname [String] The certname the master will use to encrypt network traffic.
# @param cert_dir [String] The path to the directory where Puppet managed certs will be stored.
# @param container [String] The name of the PE service without the pe- in front
# @param group [String] The group assigned to Puppet managed certs.
# @param owner [String] The owner assigned to Puppet managed certs.
# @param ssl_dir [String] The path to the directory where Puppet managed keys will be stored.
# @append_ca [Boolean] Whether to append the Root CA to the certificate used for console-services
define puppet_enterprise::certs(
  $certname,
  $cert_dir,
  String $container,
  $group      = "pe-${container}",
  $owner      = "pe-${container}",
  $ssl_dir    = $puppet_enterprise::params::ssl_dir,
  $append_ca  = false,
  Array $full_restart = [Exec["pe-${container} service full restart"]],
  Boolean $make_pk8_cert = false,
  $package_name = "pe-${container}",
) {

  $pe_container   = "pe-${container}"
  $client_pem_key = "${ssl_dir}/private_keys/${certname}.pem"
  $client_cert    = "${ssl_dir}/certs/${certname}.pem"

  File {
    owner   => $owner,
    group   => $group,
    mode    => '0400',
    before  => $full_restart,
    require => Package[$package_name],
    notify  => Service[$pe_container],
  }

  file { $cert_dir:
    ensure => directory,
    mode   => '0600',
  }

  if $append_ca {
    Pe_concat {
      before  => $full_restart,
      notify  => Service[$pe_container],
    }
    Pe_concat::Fragment {
      before  => $full_restart,
      notify  => Service[$pe_container],
    }
    pe_concat { "${cert_dir}/${certname}.cert.pem":
      ensure => present,
      owner  => $owner,
      group  => $group,
      mode   => '0400',
    }
    pe_concat::fragment { "${cert_dir}/${certname}.cert.pem":
      target  => "${cert_dir}/${certname}.cert.pem",
      source  => $client_cert,
      order   => 1,
    }
    pe_concat::fragment { "${ssl_dir}/certs/ca.pem":
      target  => "${cert_dir}/${certname}.cert.pem",
      source  => "${ssl_dir}/certs/ca.pem",
      order   => 2,
    }
  } else {
    file { "${cert_dir}/${certname}.cert.pem":
      source => $client_cert,
    }
  }

  file { "${cert_dir}/${certname}.private_key.pem":
    source => $client_pem_key,
  }

  if $make_pk8_cert {
    $client_pk8_key = "${cert_dir}/${certname}.private_key.pk8"

    puppet_enterprise::certs::pk8_cert { $client_pk8_key:
      pem_file  => $client_pem_key,
      owner     => $owner,
      group     => $group,
      mode      => '0400',
      container => $container,
      require   => File[$cert_dir],
    }
  }
}
