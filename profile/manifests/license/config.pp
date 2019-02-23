# This class ensure the location of the key is in a defind loation.
class { 'profile::license':(
  $source = 'puppet:///modules/profile/master/license.key',
) {
  file{ '/etc/puppetlabs/pe-license.key':
    ensure => present,
    source => $source,
    notify => Service['pe-console-services'],
  }
}
