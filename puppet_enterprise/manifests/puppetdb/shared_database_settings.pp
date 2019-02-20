define puppet_enterprise::puppetdb::shared_database_settings (
  String           $confdir,
  String           $database_host,
  String           $database_name,
  Optional[String[1]] $database_password,
  Integer          $database_port,
  String           $database_user,
  String           $database_properties,
  Integer          $maximum_pool_size,
  Enum['database', 'read-database'] $section = $title,
){

  $_section_file_name = $section ? {
    'read-database' => 'read_database',
    default         => $section,
  }
  $config_file = "${confdir}/${_section_file_name}.ini"

  file { $config_file:
    ensure  => present,
    owner   => 'pe-puppetdb',
    group   => 'pe-puppetdb',
    mode    => '0640',
    require => Package['pe-puppetdb']
  }

  #Set the defaults
  Pe_ini_setting {
    path    => $config_file,
    ensure  => present,
    section => $section,
    require => File[$config_file]
  }

  pe_ini_setting {"[${section}]-puppetdb_psdatabase_username":
    setting => 'username',
    value   => $database_user,
    section => $section,
  }

  if !pe_empty($database_password)  {
    pe_ini_setting {"[${section}]-puppetdb_psdatabase_password":
      setting => 'password',
      value   => $database_password,
      section => $section,
    }
  }

  pe_ini_setting {"[${section}]-puppetdb_subname":
    setting => 'subname',
    value   => "//${database_host}:${database_port}/${database_name}${database_properties}",
    section => $section,
  }

  pe_ini_setting { "[${section}]-maximum-pool-size" :
    setting => 'maximum-pool-size',
    value   => $maximum_pool_size,
    section => $section,
  }
}
