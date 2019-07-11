# == Class cacti::mysql
#
# This class is called from cacti for database config.
# git@github.com:puppetlabs/puppetlabs-mysql.git
class cacti::mysql inherits ::cacti{

  class { '::mysql::server':
    root_password           => $::cacti::database_root_pass,
    remove_default_accounts => true,
  }

  mysql::db { 'cacti':
    user     => $::cacti::database_user,
    password => $::cacti::database_pass,
    host     => $::cacti::database_host,
    grant    => ['ALL'],
    sql      => '/usr/share/doc/cacti-0.8.8b/cacti.sql',
  }

}
