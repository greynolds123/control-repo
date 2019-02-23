# This class ensure the location of the key is in a defind loation.
<<<<<<< HEAD
class { 'profile::license':(
  $source = 'puppet:///modules/profile/master/license.key',
) {
  file{ '/etc/puppetlabs/pe-license.key':
    ensure => present,
    source => $source,
    notify => Service['pe-console-services'],
  }
}
=======

  class  profile::license::config  {
    file {  '/etc/puppetlabs/pe-license.key': 
    ensure => present,
    source => 'puppet:///modules/profile/master/license.key',
    notify => Service['pe-console-services'],
  }
  }
>>>>>>> 55815a4b3be1201c52469014673005159b0e39aa
