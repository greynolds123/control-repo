# Configuration file for centos_7

  class vcsrepo::config  { '/etc/yum.d/repos.d/*': 
  ensure   => present,
  provider => git,
}
