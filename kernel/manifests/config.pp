# This class is the configuration file for kernel updates.

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
    
