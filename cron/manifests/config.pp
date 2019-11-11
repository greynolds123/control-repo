# This class deploys the cron environment for your environment.

  class cron::config {
  cron { 'clearCache':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/clearCache2016.sh',
<<<<<<< HEAD
  hour    => '0',
  minute  => '15',
=======
  hour    => '1',
  minute  => '45',
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  }
 
  cron { 'TuneDatabase':
  ensure  => present,
  user    => 'root',
  command => '/bin/sh /root/TuneDatabase.sh',
<<<<<<< HEAD
  hour    => '1',
  minute  => '0',
  }
  }
=======
  hour    => '0',
  minute  => '45',
  }
  }


>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
