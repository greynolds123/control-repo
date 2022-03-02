# Configuration file for centos_7

<<<<<<< HEAD
  class vcsrepo { '/etc/yum.d/repos.d/*': 
  ensure   => present,
  provider => git,
}
=======
  class vcsrepo::config {
  file { '/etc/yum.d/repos.d/*':
  ensure   => present,
  provider => git,
  }
  }
>>>>>>> 84f86b38d051023fc936c4e907a7ede0a9bd4066
