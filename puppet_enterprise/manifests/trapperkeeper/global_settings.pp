define puppet_enterprise::trapperkeeper::global_settings(
  String $container                  = $title,
  String $certname                   = $facts['clientcert'],
  String $service_user               = "pe-${container}",
  String $service_group              = "pe-${container}",
  Optional[String] $hostname         = undef,
  Optional[String] $ssl_cert         = undef,
  Optional[String] $ssl_key          = undef,
  Optional[String] $localcacert      = undef,
  Optional[String] $version_path     = undef,
  Optional[String] $login_path       = undef,
  Optional[String] $replication_mode = undef,
) {
  $confdir           = "/etc/puppetlabs/${container}/conf.d"
  $log_config        = "/etc/puppetlabs/${container}/logback.xml"

  file { "${confdir}/global.conf":
    ensure => file,
    mode   => '0640',
    owner  => $service_user,
    group  => $service_group,
  }

  Pe_hocon_setting {
    ensure => present,
    path   => "${confdir}/global.conf",
    notify => Service["pe-${container}"],
  }

  pe_hocon_setting{ "${container}.global.logging-config":
    setting => 'global.logging-config',
    value   => $log_config,
  }

  $localcacert_ensure = pe_empty($localcacert) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting { "${container}.global.certs.ssl-ca-cert":
    ensure  => $localcacert_ensure,
    setting => 'global.certs.ssl-ca-cert',
    value   => $localcacert,
  }

  $ssl_cert_ensure = pe_empty($ssl_cert) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting { "${container}.global.certs.ssl-cert":
    ensure  => $ssl_cert_ensure,
    setting => 'global.certs.ssl-cert',
    value   => $ssl_cert,
  }

  $ssl_key_ensure = pe_empty($ssl_key) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting { "${container}.global.certs.ssl-key":
    ensure => $ssl_key_ensure,
    setting => 'global.certs.ssl-key',
    value   => $ssl_key,
  }

  $hostname_ensure = pe_empty($hostname) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting { "${container}.global.hostname":
    ensure  => $hostname_ensure,
    setting => 'global.hostname',
    value   => $hostname,
  }

  $version_path_ensure = pe_empty($version_path) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting{ "${container}.global.version-path":
    ensure  => $version_path_ensure,
    setting => 'global.version-path',
    value   => $version_path,
  }

  $login_path_ensure = pe_empty($login_path) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting{ "${container}.global.login-path":
    ensure  => $login_path_ensure,
    setting => 'global.login-path',
    value   => $login_path,
  }

  $replication_mode_ensure = pe_empty($replication_mode) ? {
    true  => absent,
    false => present,
  }

  pe_hocon_setting{ "${container}.global.replication-mode":
    ensure  => $replication_mode_ensure,
    setting => 'global.replication-mode',
    value   => $replication_mode,
  }

}
