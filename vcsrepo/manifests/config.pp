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
>>>>>>> 55815a4b3be1201c52469014673005159b0e39aa
