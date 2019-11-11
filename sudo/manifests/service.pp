define sudo::service() {
  file { "/etc/sudoers.d/${name}":
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => "puppet:///modules/sudo/common/etc/sudoers.d/${name}",
    require => Package['sudo'],
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
