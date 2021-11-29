# PRIVATE CLASS: do not use directly
class pe_postgresql::server::reload {
  $ensure         = $pe_postgresql::server::ensure
  $service_name   = $pe_postgresql::server::service_name
  $service_status = $pe_postgresql::server::service_status

  if($ensure == 'present' or $ensure == true) {
    exec { 'postgresql_reload':
      path        => '/usr/bin:/usr/sbin:/bin:/sbin',
      command     => "service ${service_name} reload",
      onlyif      => $service_status,
      refreshonly => true,
      require     => Class['pe_postgresql::server::service'],
    }
  }
}
