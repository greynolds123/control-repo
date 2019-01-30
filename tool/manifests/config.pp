<<<<<<< HEAD
# This class deploys the iptables and other utility sripts.

  class tool::config {
  case $::osfamily {
  'CentOS','RedHat': {
  file { '/root/remoteIPtables.sh':
  ensure  => present,
  owner   => root,
  mode    => '0655',
=======
# This class deploys the iptables and clearcache sripts.

  class tool::config {
  file { '/root/remoteIPtables.sh':
  ensure => present,
  owner   => root,
  mode   => '655',
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/remoteIPtables.sh',
  }
  }
<<<<<<< HEAD
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
=======
# Flush IPtables
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
  exec { 'Flush_IPtables':
  command => '/sbin/iptables --flush',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:
  /usr/sbin:/usr/bin:/root/bin',
  before  => Exec['remoteIPtables'],
  }
<<<<<<< HEAD
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
=======
# Execute IPtables
  exec { 'remoteIPtables':
  command => '/bin/bash -x  /root/remoteIPtables.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:
  /usr/sbin:/usr/bin:/root/bin',
  onlyif  => '/bin/grep -c /root/ /root/remoteIPtables.sh && exit 1 || exit 0',
  before  => Exec['ClearCache'],
  }

### Copy IPtables for Ubuntu ###
  if $operatingsystem == '/[Ubuntu|Debian]/' {
  file { '/root/remoteIPtables-ubuntu.sh':,
  ensure => present,
  content => 'puppet:///modules/tool/remoteIPtables-ubuntu.sh',
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
  }
  }

### Flush IPtables for Ubuntu ###
<<<<<<< HEAD
  case $::osfamily {
    'ubuntu','debian': {
=======
  if $operatingsystem == '/[Ubuntu|Debian]/' {
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
  exec { 'Flush_Ubuntu_IPtables':
  command => '/sbin/iptables --flush',
  path    => '/usr/local/sbin:/usr/local/bin/sbin:/bin:
  /usr/sbin:/usr/bin:/root/bin',
  before  => Exec['remoteIPtables-ubuntu']
  }
  }
<<<<<<< HEAD
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

=======
### Execute IPtables for Ubuntu ###
  if $operatingsystem == '/[Ubuntu|Debian]/' {
  exec { 'remoteIPtables-ubuntu':
  command => '/bin/sh /root/remoteIPtables-ubuntu.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
  onlyif  => '/bin/grep -c /root/
  /root/remoteIPtables-ubuntu.sh && exit 1 || exit 0'
  }
  }

# Copy selinux scropt to root

  file { '/root/manageSelinux.sh':
  ensure  => present,
  owner   => root,
  mode    => '655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/manageSelinux.sh',
  }


>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
# Clear IPtable cache
  file { '/root/clearCache2016.sh':
  ensure  => present,
  owner   => root,
<<<<<<< HEAD
  mode    => '0655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/clearCache2016.sh'
=======
  mode    => '655',
  seltype => 'admin_home_t',
  source  => 'puppet:///modules/tool/clearCache2016.sh',
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
  }

# Execute
  exec { 'ClearCache':
  command => '/bin/sh /root/clearCache2016.sh',
  path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin
  :/usr/sbin:/usr/bin:/root/bin',
<<<<<<< HEAD
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


=======
  onlyif  => '/bin/grep -c /root/ /root/clearCache2016.sh && exit 1 || exit 0'
  }
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
