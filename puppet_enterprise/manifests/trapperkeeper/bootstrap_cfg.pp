define puppet_enterprise::trapperkeeper::bootstrap_cfg (
  $namespace,
  $container,
  $service = $title,
  $order   = undef,
) {
  $path = "/etc/puppetlabs/${container}/bootstrap.cfg"

  if ! defined(Pe_concat[$path]) {
    pe_concat { $path:
      notify => Service["pe-${container}"],
    }
  }

  if ! defined(Pe_concat::Fragment["${container} ${service}"]) {
    pe_concat::fragment { "${container} ${service}":
      target  => $path,
      content => "${namespace}/${service}\n",
      order   => $order,
    }
  }
}
