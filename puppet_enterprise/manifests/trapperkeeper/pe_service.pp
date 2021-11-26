define puppet_enterprise::trapperkeeper::pe_service (
  String                     $container           = $title,
  Enum['stopped', 'running'] $ensure              = running,
  Boolean                    $enable              = true,
  Optional[Array[Any]]       $service_subscribe   = undef,
){

  $pe_container = "pe-${container}"

  service { $pe_container:
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    restart    => "service ${pe_container} reload",
    require    => Package[$pe_container],
    subscribe  => $service_subscribe,
  }

  #Some configuration settings need a full restart to take effect, such as java_args
  exec { "${pe_container} service full restart" :
    command     => "service ${pe_container} restart",
    timeout     => 0,  # Wait for PDB migrations, which may take a *long* time
    path        => $facts['path'],
    refreshonly => true,
    before      => Service[$pe_container],
  }
}
