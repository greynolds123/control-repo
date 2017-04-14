# This class deploys the iptables and clearcache sripts.

  class tool::config {
  file { '/root/remoteIPtables.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/remoteIPtables.sh',
  }
  }

# Flush IPtables
  exec { 'Flush_IPtables':
  command => '/sbin/iptables --flush',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:
  /usr/sbin:/usr/bin:/root/bin',
  before  => Exec['remoteIPtables'],
  }

# Execute IPtables
  exec { 'remoteIPtables':
  command => '/bin/bash -x  /root/remoteIPtables.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:
  /usr/sbin:/usr/bin:/root/bin',
  onlyif  => '/bin/grep -c /root/ /root/remoteIPtables.sh && exit 1 || exit 0',
  before  => Exec['ClearCache'],
  }

# Network file listing
  file { '/root/networks.txt':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/networks.txt',
  }

# Check for IP for Primary services (ipscan)
  file { '/root/ipscan.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/ipscan.sh',
  }

# Execute ipscan
  exec { 'ipscan':
  command => '/bin/sh /root/ipscan.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin
  :/usr/sbin:/usr/bin:/root/bin',
  onlyif  => '/bin/grep -c /root/ /root/ipscan.sh && exit 1 || exit 0',
  }

### Copy IPtables for Ubuntu ###
  if $operatingsystem == '/[Ubuntu|Debian]/' {
  file { '/root/remoteIPtables-ubuntu.sh':,
  ensure  => present,
  content => 'puppet:///modules/tool/remoteIPtables-ubuntu.sh',
  }
  }

### Flush IPtables for Ubuntu ###
  if $operatingsystem == '/[Ubuntu|Debian]/' {
  exec { 'Flush_Ubuntu_IPtables':
  command => '/sbin/iptables --flush',
  path    => '/usr/local/sbin:/usr/local/bin/sbin:/bin:
  /usr/sbin:/usr/bin:/root/bin',
  before  => Exec['remoteIPtables-ubuntu'],
  }
  }

### Execute IPtables for Ubuntu ###
  if $operatingsystem == '/[Ubuntu|Debian]/' {
  exec { 'remoteIPtables-ubuntu':
  command => '/bin/sh /root/remoteIPtables-ubuntu.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
  onlyif  => '/bin/grep -c /root/ /root/remoteIPtables-ubuntu.sh && exit 1 || exit 0'
  }
  }

# Copy selinux scropt to root

  file { '/root/manageSelinux.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/manageSelinux.sh',
  }

# Clear IPtable cache
  file { '/root/clearCache2016.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/clearCache2016.sh',
  }

# Execute
  exec { 'ClearCache':
  command => '/bin/sh /root/clearCache2016.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin
  :/usr/sbin:/usr/bin:/root/bin',
  onlyif  => '/bin/grep -c /root/ /root/clearCache2016.sh && exit 1 || exit 0',
  before  => Exec['ipscan'],
  }


# Clear database cache
  file { '/root/TuneDatabase.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/TuneDatabase.sh',
  }

