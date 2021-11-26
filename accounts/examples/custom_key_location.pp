group { 'admin':
  gid => 3000,
}
group { 'sudo':
  gid => 3001,
}
group { 'sudonopw':
  gid => 3002,
}
group { 'developer':
  gid => 3003,
}
group { 'ops':
  gid => 3004,
}

file { '/var/lib/ssh/jeff':
  ensure => directory,
  owner  => 'jeff',
  group  => 'jeff',
}

accounts::user { 'jeff':
  sshkey_custom_path => '/var/lib/ssh/jeff/authorized_keys',
  shell              => '/bin/zsh',
  comment            => 'Jeff McCune',
  groups             => [
    'admin',
    'sudonopw',
  ],
  uid                => '1112',
  gid                => '1112',
  locked             => true,
  sshkeys            => [
    'ssh-rsa AAAAB3Nza...== jeff@puppetlabs.com',
    'ssh-dss AAAAB3Nza...== jeff@metamachine.net',
  ],
  password           => '!!',
}
accounts::user { 'dan':
  comment => 'Dan Bode',
  uid     => '1109',
  gid     => '1109',
}
