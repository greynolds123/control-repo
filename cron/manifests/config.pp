# This class deploys the cron environment for your environment.

  class cron::config {
  cron { 'clearCache':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/clearCache2016.sh',
  hour    => '1',
  minute  => '45',
  }
 
  cron { 'TuneDatabase':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/TuneDatabase.sh',
  hour    => '0',
<<<<<<< HEAD
  minute  => '20',
=======
  minute  => '45',
>>>>>>> 0c0034f2ee3f3f278ef694aba1da0f2bfa8f8cb0
  }
  }
