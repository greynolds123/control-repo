# This class will provide the file path to install git.

  class gitprod::config {
  file { '$::envdir':
  ensure   => 'directory',
  owner    => 'puppet',
  group    => 'puppet',
  seltype  => 'admin',
  subcribe => ['git::params'],
  }
  }
