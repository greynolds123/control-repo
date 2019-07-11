define puppet_enterprise::trapperkeeper::java_args (
  Hash   $java_args,
  String $container   = $title,
  String $initconfdir = $puppet_enterprise::params::defaults_dir,
){

  $pe_container = "pe-${container}"
  $initconf = "${initconfdir}/${pe_container}"

  if !pe_empty($java_args) {
    create_resources(
      'pe_ini_subsetting',
      create_java_args_subsettings_hash(
        $pe_container,
        $java_args,
        { path    => $initconf,
          require => Package[$pe_container],
          notify  => Service[$pe_container],
        }
      )
    )
  }
}
