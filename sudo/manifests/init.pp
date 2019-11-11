class sudo (
  $admins  = $sudo::params::admins,
  $content = $sudo::params::content,
  $source  = $sudo::params::source
) inherits sudo::params {

  validate_array(hiera('admin'))

  file { '/etc/sudoers':
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => $content,
    source  => $source,
    require => Package['sudo'],
  }

  if $::lsbdistcodename != 'lenny' {
    file { '/etc/sudoers.d':
      force   => true,
      purge   => true,
      recurse => true,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      require => Package['sudo'],
    }
  }

  file { '/usr/bin/sudo':
    owner   => 'root',
    group   => 'root',
    mode    => '4755',
  }

  file { '/usr/sbin/visudo':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  package { 'sudo':
    ensure => present,
  }
<<<<<<< HEAD
}
=======
  }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
