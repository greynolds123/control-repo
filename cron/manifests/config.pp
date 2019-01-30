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
<<<<<<< HEAD
 
  cron { 'TuneDatabase':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/TuneDatabase.sh',
  hour    => '5',
  minute  => '15',
  }

=======
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
