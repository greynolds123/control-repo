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
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
