# This class deploys the cron environment for your environment.

  class cron::config {
  cron { 'clearCache':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/clearCache2016.sh',
  hour    => '0',
  minute  => '15',
  }
 
  cron { 'TuneDatabase':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/TuneDatabase.sh',
  hour    => '1',
  minute  => '0',
  }
  }
