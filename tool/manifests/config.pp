# This class deploys the iptables and other utility sripts.

  class tool::config {
  case $::osfamily {
  'CentOS','RedHat': {
  file { '/root/remoteIPtables.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/remoteIPtables.sh',
  }
  }
  }

# Network file listing
  file { '/root/networks.txt':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/networks.txt'
  }


# Flush IPtables
  case $::osfamily {
  'CentOS','RedHat': {
  exec { 'Flush_IPtables':
  command => '/sbin/iptables --flush',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:
  /usr/sbin:/usr/bin:/root/bin',
  before  => Exec['remoteIPtables'],
  }
  }
  }

# Execute IPtables
  case $::osfamily  {
  'Case', 'RedHat': {
  exec { 'remoteIPtables':
  command =>'/bin/bash -x /root/remoteIPtables.sh',
  path    =>'/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin/',
  onlyif  =>'/bin/grep -c /root/ /rot/remotIPtables.sh && exit 1 || exit 0',
  before  => Exec['ClearCache'],
  }
  }
  }

# Copy selinux scropt to root

  file { '/root/manageSelinux.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/manageSelinux.sh'
  }

# Check for IP for Primary services (ipscan)
  file { '/root/ipscan.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/ipscan.sh'
  }

# Execute ipscan
  exec { 'ipscan':
  command => '/bin/sh /root/ipscan.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin
  :/usr/sbin:/usr/bin:/root/bin',
  onlyif  => '/bin/grep -c /root/ /root/ipscan.sh && exit 1 || exit 0'
  }

### Copy IPtables for Ubuntu ###
  case $::osfamily {
     'ubuntu','debian': {
  file { '/root/remoteIPtables-ubuntu.sh':,
  ensure => present,
  owner  => root,
  mode   => '0655',
  source => 'puppet:///modules/tool/remoteIPtables-ubuntu.sh'
  }
  }
  }

### Flush IPtables for Ubuntu ###
  case $::osfamily {
    'ubuntu','debian': {
  exec { 'Flush_Ubuntu_IPtables':
  command => '/sbin/iptables --flush',
  path    => '/usr/local/sbin:/usr/local/bin/sbin:/bin:
  /usr/sbin:/usr/bin:/root/bin',
  before  => Exec['remoteIPtables-ubuntu']
  }
  }
  }

### Execute IPtables for Ubuntu ###
  case $::osfamily {
     'ubuntu','debian': {
  exec { 'remoteIPtables-ubuntu':
  command => '/bin/sh /root/remoteIPtables-ubuntu.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
  onlyif  => '/bin/grep -c /root/ /root/remoteIPtables-ubuntu.sh && exit 1 || exit 0'
  }
  }
  }

# Clear IPtable cache
  file { '/root/clearCache2016.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/clearCache2016.sh'
  }

# Execute
  exec { 'ClearCache':
  command => '/bin/sh /root/clearCache2016.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin
  :/usr/sbin:/usr/bin:/root/bin',
  onlyif  => '/bin/grep -c /root/ /root/clearCache2016.sh && exit 1 || exit 0',
  before  => Exec['ipscan']
  }


# Clear database cache
  file { '/root/TuneDatabase.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/TuneDatabase.sh'
  }

# A file use for adding databases to be tuned.
  file { '/root/Server_List':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/Server_List'
  }
  }


