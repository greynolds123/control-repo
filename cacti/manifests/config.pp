# == Class cacti::config
#
# This class is called from cacti for service config.
#
class cacti::config inherits cacti{

  file { '/etc/cacti/db.php':
    ensure  => present,
    content => template('cacti/etc/cacti/db.erb'),
    mode    => '0640',
    owner   => 'cacti',
    group   => 'apache',
  }

  augeas { 'cacti_perms':
    incl    => '/etc/httpd/conf.d/cacti.conf',
    lens    => 'Httpd.lns',
    context => '/files/etc/httpd/conf.d/cacti.conf',
    changes => [ 'set /files/etc/httpd/conf.d/cacti.conf/Directory[1]/IfModule[1]/directive/arg[1] all',
      'set /files/etc/httpd/conf.d/cacti.conf/Directory[1]/IfModule[1]/directive/arg[2] granted',
      'set /files/etc/httpd/conf.d/cacti.conf/Directory[1]/IfModule[2]/directive[3]/arg[2] all',
    ],
  }

  cron::job { 'cacti':
    minute  => '*/5',
    command => '/usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&1',
    user    => 'cacti',
  }


}
