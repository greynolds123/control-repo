# This class deploys the cron environment for your environment.

  class cron::config {
  cron { 'clearCache':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/clearCache2016.sh',
  hour    => '2',
  minute  => '45',
  }
  }
