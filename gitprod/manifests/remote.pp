# This class will add git remote to the environment repo.

  class gitprod::remote {
  file { '$::envdir':
  ensure  => 'present',
  }
  }
