# This class will add git remote to the environment repo.

  class gitprod::remote {
  file { '$::envdir':
  ensure  => 'present',
  }

  if $::envdir == prod {
  require => User['pe-puppet'],
  require => Group['pe-puppet'],
  } elsif if $::envdir == dev {
  require => User['pe-puppet'],
  require => Group['pe-puppet'],
  } elsif if $::envdir == Dev_docker {
  require => User['pe-puppet'],
  require => Group['pe-puppet'],
  } elsif if $::envdir == stage {
  require => User['pe-puppet'],
  require => Group['pe-puppet'],
  } else {
  notice { 'This environment is not managed by this puppetmaster' }
  }
