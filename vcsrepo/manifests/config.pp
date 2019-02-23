# Configuration file for centos_7

  class config:vcsrepo {'/etc/yum.d/repos.d/*': 
  ensure   => present,
  provider => git,
}
