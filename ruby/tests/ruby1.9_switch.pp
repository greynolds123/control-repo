<<<<<<< HEAD
class{'ruby':
=======
class { '::ruby':
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  version         => '1.9.3',
  latest_release  => true,
  rubygems_update => true,
}
<<<<<<< HEAD
include ruby::dev
=======
include ::ruby::dev
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
