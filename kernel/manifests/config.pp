# This class is the configuration file for kernel updates.

  class kernel::config (
  $ensure     = 'present',
  $allow_virtual = false,
  ) {


  yumrepo    { 'Redhat_7_Updates':
  ensure   => 'present',
<<<<<<< HEAD
  baseurl  => 'http://wwwin-kickstart-dev.cisco.com/yum/channels/$baseos/rhel-x86_64-server-7',
  descr    => 'RHEL7 udpates channel',
  enabled  => '1',
  gpgcheck => '0',
  gpgkey   => 'http://wwwin-kickstart-dev.cisco.com/yum/keys/RPM-GPG-KEY-redhat-release
  http://wwwin-kickstart-dev.cisco.com/yum/keys/RPM-GPG-KEY-redhat-release7',
=======
  baseurl  => 'http://centos7.prod.localdomain/yum/channels/$baseos/rhel-x86_64-server-7',
  descr    => 'RHEL7 udpates channel',
  enabled  => '1',
  gpgcheck => '0',
  gpgkey   => 'http://centos7.prod.localdomain/yum/keys/RPM-GPG-KEY-redhat-release
  http://centos7.prod.localdomain/yum/keys/RPM-GPG-KEY-redhat-release7',
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  priority => '1',
  }

  package { 'kernel-3.10.0-229.1.2.el7':
  ensure        => $ensure,
  provider      => 'yum',
  allow_virtual => $allow_virtual,
  }
  }
    
