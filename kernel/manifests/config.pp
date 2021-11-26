# This class is the configuration file for kernel updates.
<<<<<<< HEAD

  class kernel::config (
  $ensure     = 'present',
  $allow_virtual = false,
  ) {


  yumrepo    { 'Redhat_7_Updates':
  ensure   => 'present',
  baseurl  => 'http://centos7.dev.localdomain/yum/channels/$baseos/rhel-x86_64-server-7',
  descr    => 'RHEL7 udpates channel',
  enabled  => '1',
  gpgcheck => '0',
  gpgkey   => 'http://centos7.prod.localdomain/yum/keys/RPM-GPG-KEY-redhat-release
  http://centos7.prod.localdomain/yum/keys/RPM-GPG-KEY-redhat-release7',
  priority => '1',
  }

  package { 'kernel-3.10.0-229.1.2.el7':
  ensure        => $ensure,
  provider      => 'yum',
  allow_virtual => $allow_virtual,
  }
  }
    
=======

  class kernel::config (
  $ensure     = 'present',
  $allow_virtual = false,
  ) {


  yumrepo    { 'Redhat_7_Updates':
  ensure   => 'present',
  baseurl  => 'http://centos7.dev.localdomain/yum/channels/$baseos/rhel-x86_64-server-7',
  descr    => 'RHEL7 udpates channel',
  enabled  => '1',
  gpgcheck => '0',
  gpgkey   => 'http://centos7.prod.localdomain/yum/keys/RPM-GPG-KEY-redhat-release
  http://centos7.prod.localdomain/yum/keys/RPM-GPG-KEY-redhat-release7',
  priority => '1',
  }

  package { 'kernel-3.10.0-229.1.2.el7':
  ensure        => $ensure,
  provider      => 'yum',
  allow_virtual => $allow_virtual,
  }
  }

>>>>>>> d6c2c1caca2803f4fe298827ccef2349352e491c
