<<<<<<< HEAD
<<<<<<< HEAD
class{'ruby':
=======
class { '::ruby':
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
=======
class { '::ruby':
>>>>>>> b234704ac85e5944ab85d8a528657f7c75be3c6d
  version         => '2.0.0',
  latest_release  => true,
  rubygems_update => true,
}
<<<<<<< HEAD
<<<<<<< HEAD
include ruby::dev
=======
include ::ruby::dev
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
=======
include ::ruby::dev
>>>>>>> b234704ac85e5944ab85d8a528657f7c75be3c6d
