# This class adds history.sh to /etc/profile

  class history::config {
  file { '/etc/profile.d/history.sh':
  ensure =>  present,
  owner  => 'root',
  group  => 'root',
  mode   =>  '0644',
  source =>  'file:///modules/history/history.sh',
  }
  }

  exec { 'history_edit':
  command => '/bin/sh /etc/profile.d/history.sh',
  path    => '/opt/puppet/bin:/usr/local/sbin:/usr/local/bin
  :/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
  onlyif  => 'grep -c /etc/profile.d/ /etc/profile.d/history.sh && 
  exit 1 || exit 0'
  }
