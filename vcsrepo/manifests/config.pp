# Configuration file for centos_7

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  class vcsrepo::config  { 
  file {'/etc/yum.d/repos.d/*': 
=======
  class config:vcsrepo {'/etc/yum.d/repos.d/*': 
>>>>>>> 10432449b2e0e7e54ce051edd6c7db6946329fa9
=======
  class vcsrepo::config {
  file { '/etc/yum.d/repos.d/*':
>>>>>>> fb2f99b2f2043baacdb5d8b1cf516d2cbdc032ce
  ensure   => present,
  provider => git,
  }
  }
<<<<<<< HEAD
=======
  class vcsrepo::config {
  file { '/etc/yum.d/repos.d/*': 
  ensure   => present,
  provider => git,
}
}
>>>>>>> cd0651225b9de60c3a9ce2c0edbcdb51587cdbd7
=======
>>>>>>> fb2f99b2f2043baacdb5d8b1cf516d2cbdc032ce
