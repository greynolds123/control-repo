# This class will provide the user account for a global git account.
  class gitprod::users {
  file { '/home/git':
  ensure  => 'directory',
  user    => 'git',
  group   => 'git',
  seltype => admin,
  uid     => 1111,
  group   => 1111,
  require => Group['group'],
  }
  }
