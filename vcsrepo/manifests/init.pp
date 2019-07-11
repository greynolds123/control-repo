 # Configuration file for centos_7

 class vcsrepo {
  file { '/etc/yum.repos.d':
  ensure   => directory,
  }
  }
