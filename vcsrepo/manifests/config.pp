# Configuration file for centos_7

  class vcsrepo::config {
  file { '/etc/yum.d/repos.d/*': 
  ensure   => present,
  provider => git,
}
}
