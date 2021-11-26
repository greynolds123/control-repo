# This class is for setting up the PuppetDB config.ini configuration file
#
# @param command_processing_threads [Integer] This defines how many
#        command processing threads to use. Each thread can process
#        a single command at a time.
class puppet_enterprise::puppetdb::config_ini(
  String  $confdir,
  Integer $command_processing_threads,
) inherits puppet_enterprise::params {

  $config_ini = "${confdir}/config.ini"

  file { $config_ini :
    ensure  => present,
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb'],
  }

  #Set the defaults
  Pe_ini_setting {
    path    => $config_ini,
    ensure  => present,
    require => File[$config_ini],
  }

  pe_ini_setting { 'config.ini threads command-processing section' :
    section => 'command-processing',
    setting => 'threads',
    value   => pe_max($command_processing_threads, 1),
    notify  => Service['pe-puppetdb'],
  }
}
