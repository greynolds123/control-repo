# Configuration file for centos_7

<<<<<<< HEAD
<<<<<<< HEAD
  class vcsrepo::config  { 
  file {'/etc/yum.d/repos.d/*': 
=======
  class config:vcsrepo {'/etc/yum.d/repos.d/*': 
>>>>>>> 10432449b2e0e7e54ce051edd6c7db6946329fa9
  ensure   => present,
  provider => git,
  }
  }
=======
  class vcsrepo::config {
  file { '/etc/yum.d/repos.d/*': 
  ensure   => present,
  provider => git,
}
}
>>>>>>> cd0651225b9de60c3a9ce2c0edbcdb51587cdbd7
