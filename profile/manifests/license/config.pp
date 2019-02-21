# This class ensure the location of the key is in a defind loation.

  class  profile::license::config  {
    file {  '/etc/puppetlabs/pe-license.key': 
    ensure => present,
    source => 'puppet:///modules/profile/master/license.key',
    notify => Service['pe-console-services'],
  }
  }
