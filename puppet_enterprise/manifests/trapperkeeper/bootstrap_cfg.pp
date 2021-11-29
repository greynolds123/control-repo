define puppet_enterprise::trapperkeeper::bootstrap_cfg (
  $namespace,
  $container,
  $service = $title,
  $order   = undef,
  $ensure  = present,
) {
  $path = "/etc/puppetlabs/${container}/bootstrap.cfg"
  $pe_container = "pe-${container}"

  #bootstrap.cfg changes require a full service restart in 2017.1
  #that comes from the exec resource and we don't want a merge up
  #to accidentally revert back to using the service resource
  #pe_build isn't populated on compile masters until after the first agent running
  #we use the version of the MoM to determine which resource to notify
  $notify_hup_or_full_restart = puppet_enterprise::on_the_lts() ? {
    true    => Service[$pe_container],
    default => Exec["${pe_container} service full restart"],
  }

  if ! defined(Pe_concat[$path]) {
    pe_concat { $path:
      notify => $notify_hup_or_full_restart,
    }
  }

  if ! defined(Pe_concat::Fragment["${container} ${service}"]) {
    pe_concat::fragment { "${container} ${service}":
      ensure  => $ensure,
      target  => $path,
      content => "${namespace}/${service}\n",
      order   => $order,
      notify  => $notify_hup_or_full_restart,
      require => Package["pe-${container}"]
    }
  }
}
