define puppet_enterprise::trapperkeeper::java_args (
  Hash   $java_args,
  String $container   = $title,
  String $initconfdir = $puppet_enterprise::params::defaults_dir,
  Boolean $enable_gc_logging = true,
){

  $pe_container = "pe-${container}"
  $initconf = "${initconfdir}/${pe_container}"

  $gc_logging_args = puppet_enterprise::produce_gc_logging_args_hash($container)

  #java_args changes require a full service restart in 2017.1
  #that comes from the exec resource and we don't want a merge up
  #to accidentally revert back to using the service resource
  #pe_build isn't populated on compile masters until after the first agent running
  #we use the version of the MoM to determine which resource to notify
  $notify_hup_or_full_restart = puppet_enterprise::on_the_lts() ? {
    true    => Service[$pe_container],
    default => Exec["${pe_container} service full restart"],
  }

  Pe_ini_subsetting {
    path              => $initconf,
    key_val_separator => '=',
    section           => '',
    setting           => 'JAVA_ARGS',
    quote_char        => '"',
    require           => Package[$pe_container],
    notify            => $notify_hup_or_full_restart,
  }

  if !pe_empty($java_args) {
    $java_args.each | $java_arg, $java_arg_value | {
      pe_ini_subsetting { "${pe_container}_'${java_arg}'" :
        ensure     => 'present',
        subsetting => "-${java_arg}",
        value      => pe_pick_default( $java_arg_value, '' ),
      }
    }
  }

  $gc_logging_ensure = $enable_gc_logging ? {
    false   => absent,
    default => 'present',
  }

  $gc_logging_args.each | $java_arg, $java_arg_value | {
    pe_ini_subsetting { "${pe_container}_'${java_arg}'" :
      ensure     => $gc_logging_ensure,
      subsetting => "-${java_arg}",
      value      => pe_pick_default( $java_arg_value, '' ),
    }
  }

}
