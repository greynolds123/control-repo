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

  cron { 'R10k':
  ensure  => present,
  user    => 'root',
  command => '/opt/puppetlabs/bin/r10k  deploy environment -p',
  hour    => '0',
  minute  => '3',
  }

  cron { 'RsyncDev':
  ensure  => present,
  user    => 'root',
  command => '/bin/rsync -razP /etc/puppetlabs/r10k/Dev/  /etc/puppetlabs/code/environments/dev/modules',
  hour    => '0',
  minute  => '10',
  }

  cron { 'RsyncDev_docker':
  ensure  => present,
  user    => 'root',
  command => '/bin/rsync -razP /etc/puppetlabs/r10k/Dev_docker/  /etc/puppetlabs/code/environments/Dev_docker/modules',
  hour    => '0',
  minute  => '10',
  }

 cron { 'RsyncDevelopment':
  ensure  => present,
  user    => 'root',
  command => '/bin/rsync -razP /etc/puppetlabs/r10k/Development/  /etc/puppetlabs/code/environments/Development/modules',
  hour    => '0',
  minute  => '10',
  }

   cron { 'RsyncLinux_Server':
   ensure  => present,
   user    => 'root',
   command => '/bin/rsync -razP /etc/puppetlabs/r10k/Linux_Server/  /etc/puppetlabs/code/environments/Linux_Server/modules',
  hour     => '0',
  minute   => '10',
  }

 cron { 'Rsyncmaster':
  ensure  => present,
  user    => 'root',
  command => '/bin/rsync -razP /etc/puppetlabs/r10k/master/  /etc/puppetlabs/code/environments/master',
  hour    => '0',
  minute  => '10',
  }

 cron { 'Rsyncproduction':
  ensure  => present,
  user    => 'root',
  command => '/bin/rsync -razP /etc/puppetlabs/r10k/production/  /etc/puppetlabs/code/environments/production/modules',
  hour    => '0',
  minute  => '10',
  }

 cron { 'Rsyncstage':
  ensure  => present,
  user    => 'root',
  command => '/bin/rsync -razP /etc/puppetlabs/r10k/stage/  /etc/puppetlabs/code/environments/stage/modules',
  hour    => '0',
  minute  => '10',
  }
  }

