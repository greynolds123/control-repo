class puppet_enterprise::profile::console::cache (
  Hash              $cache_whitelist  = {},
  Optional[Integer] $cache_size_bytes = undef,
) {

  $container = 'console-services'
  $console_services_user  = "pe-${container}"
  $console_services_group = $console_services_user

  $cache_conf_path = "/etc/puppetlabs/${container}/conf.d/cache.conf"

  file { $cache_conf_path :
    ensure  => file,
    owner   => $console_services_user,
    group   => $console_services_group,
    mode    => '0640',
    require => Package["pe-${container}"],
    notify  => Service["pe-${container}"],
  }

  Pe_hocon_setting {
    ensure  => present,
    require => File[$cache_conf_path],
    notify  => Service["pe-${container}"],
  }

  $cache_size_bytes_ensure = pe_empty($cache_size_bytes) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting { "${container}.console.cache-size-bytes" :
    ensure  => $cache_size_bytes_ensure,
    path    => $cache_conf_path,
    setting => 'console.cache-size-bytes',
    value   => $cache_size_bytes,
  }

  pe_hocon_setting { "${container}.console.cache-whitelist" :
    path    => $cache_conf_path,
    setting => 'console.cache-whitelist',
    value   => $cache_whitelist,
    type    => 'hash',
  }
}
