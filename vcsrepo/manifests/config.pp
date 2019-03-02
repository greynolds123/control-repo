# Configuration file for centos_7

<<<<<<< HEAD
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
=======
  class vcsrepo::config {
  file { '/etc/yum.d/repos.d/*':
>>>>>>> 420d26fc4711d1cbca28d3032e57a69a49a122c7
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
<<<<<<< HEAD
>>>>>>> cd0651225b9de60c3a9ce2c0edbcdb51587cdbd7
=======
>>>>>>> fb2f99b2f2043baacdb5d8b1cf516d2cbdc032ce
=======
}
>>>>>>> 420d26fc4711d1cbca28d3032e57a69a49a122c7
