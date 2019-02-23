<<<<<<< HEAD
class{'ruby':
=======
class { '::ruby':
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  version         => '2.0.0',
  latest_release  => true,
  rubygems_update => true,
}
<<<<<<< HEAD
include ruby::dev
=======
include ::ruby::dev
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
