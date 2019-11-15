# This class deploys the cron environment for your environment.

  class cron::config {
  cron { 'clearCache':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/clearCache2016.sh',
  hour    => '0',
  minute  => '15',
  hour    => '1',
  minute  => '45',
  }
 
  cron { 'TuneDatabase':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/TuneDatabase.sh',
  minute  => '0',
  }
  }
  hour    => '0',
  minute  => '45',
  }
  }
