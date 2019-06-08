# This class will contain the actual location of the repo's used to deploy git.

  class gitprod::params {
  $envdir = '/etc/puppetlabs/code/environments/$<-% environment %>/modules'
  file { '$envdir':
  ensure  => 'directory',
  seltype => 'system',
  seluser => 'puppet',
  user    => 'pe-puppet',
  group   => 'pe-puppet',
  }
  }
