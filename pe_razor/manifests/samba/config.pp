# Credit to Adam Jahn:
# https://github.com/ajjahn/puppet-samba
#
# == Type pe_razor::samba::config
#
define pe_razor::samba::config {
  file { '/etc/samba':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/samba/smb.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [File['/etc/samba'], Pe_razor::Samba::Install['razor']],
    notify  => Pe_razor::Samba::Service['razor'],
  }
}
