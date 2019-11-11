define puppet_enterprise::trapperkeeper::rbac (
  $certname,
  $container                                      = $title,
  $database_host                                  = 'localhost',
  $database_name                                  = $puppet_enterprise::params::rbac_database_name,
  $database_password                              = undef,
  $database_port                                  = $puppet_enterprise::database_port,
  $database_properties                            = '',
  $database_user                                  = $puppet_enterprise::rbac_service_regular_db_user,
  $database_migration_user                        = $puppet_enterprise::rbac_service_migration_db_user,
  $localcacert                                    = $puppet_enterprise::params::localcacert,
  Optional[String] $ds_trust_chain                = undef,
  Optional[Integer] $failed_attempts_lockout      = undef,
  Optional[Integer] $account_expiry_check_minutes = undef,
  Optional[Integer] $account_expiry_days          = undef,
  $group                                          = "pe-${title}",
  Optional[Integer] $password_reset_expiration    = undef,
  Optional[Integer] $session_timeout              = undef,
  Optional[String] $token_auth_lifetime           = undef,
  Optional[String] $token_maximum_lifetime        = '10y',
  $user                                           = "pe-${title}",
) {

  $cert_dir = "${puppet_enterprise::server_data_dir}/${container}/certs"
  $ssl_key = "${cert_dir}/${certname}.private_key.pem"
  $ssl_cert =  "${cert_dir}/${certname}.cert.pem"

  File {
    owner => $user,
    group => $group,
    mode  => '0640',
  }

  Pe_hocon_setting {
    ensure  => present,
    notify  => Service["pe-${container}"],
  }

  $cert_whitelist_path = "/etc/puppetlabs/${container}/rbac-certificate-whitelist"
  # Uses
  #   $ssl_key
  #   $ssl_cert
  #   $cert_whitelist_path
  file { "/etc/puppetlabs/${container}/conf.d/rbac.conf":
    ensure => present,
  }
  pe_hocon_setting { "${container}.rbac.certificate-whitelist":
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.certificate-whitelist',
    value   => $cert_whitelist_path,
  }
  pe_hocon_setting { "${container}.rbac.token-private-key":
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.token-private-key',
    value   => $ssl_key,
  }
  pe_hocon_setting { "${container}.rbac.token-public-key":
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.token-public-key',
    value   => $ssl_cert,
  }

  # Configure the SSL settings to enable SSL when communicating with the Puppet Master
  pe_hocon_setting { "${container}.rbac.ssl-key":
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.ssl-key',
    value   => $ssl_key,
  }
  pe_hocon_setting { "${container}.rbac.ssl-cert":
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.ssl-cert',
    value   => $ssl_cert,
  }
  pe_hocon_setting { "${container}.rbac.ssl-ca-cert":
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.ssl-ca-cert',
    value   => $localcacert,
  }

  pe_hocon_setting {"${container}.rbac.token-maximum-lifetime":
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.token-maximum-lifetime',
    value   => $token_maximum_lifetime,
  }

  if $password_reset_expiration {
    $password_reset_expiration_ensure = present
  } else {
    $password_reset_expiration_ensure = absent
  }

  pe_hocon_setting { "${container}.rbac.password-reset-expiration":
    ensure  => $password_reset_expiration_ensure,
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.password-reset-expiration',
    value   => $password_reset_expiration,
  }

  pe_hocon_setting { "${container}.rbac.session-timeout":
    ensure  => absent,
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.session-timeout',
  }

  if $token_auth_lifetime and ! pe_empty($token_auth_lifetime) {
    pe_validate_re($token_auth_lifetime, '^[0-9]+[smhdy]?$', '$token_auth_lifetime must either be an integer or a string of digits optionally followed by "s", "m", "h", "d", or "y".')
    $token_auth_lifetime_ensure = present
  } else {
    $token_auth_lifetime_ensure = absent
  }

  pe_hocon_setting { "${container}.rbac.token-auth-lifetime":
    ensure  => $token_auth_lifetime_ensure,
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.token-auth-lifetime',
    value   => $token_auth_lifetime,
  }

  if $ds_trust_chain and !pe_empty($ds_trust_chain) {
    $ds_trust_chain_ensure = present
  } else {
    $ds_trust_chain_ensure = absent
  }

  pe_hocon_setting { "${container}.rbac.ds-trust-chain":
    ensure  => $ds_trust_chain_ensure,
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.ds-trust-chain',
    value   => $ds_trust_chain,
  }

  if $failed_attempts_lockout {
    $failed_attempts_lockout_ensure = present
  } else {
    $failed_attempts_lockout_ensure = absent
  }

  pe_hocon_setting { "${container}.rbac.failed-attempts-lockout":
    ensure  => $failed_attempts_lockout_ensure,
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.failed-attempts-lockout',
    value   => $failed_attempts_lockout,
  }

  if $account_expiry_check_minutes {
    $account_expiry_check_minutes_ensure = present
  } else {
    $account_expiry_check_minutes_ensure = absent
  }

  pe_hocon_setting { "${container}.rbac.account-expiry-check-minutes":
    ensure  => $account_expiry_check_minutes_ensure,
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.account-expiry-check-minutes',
    value   => $account_expiry_check_minutes,
  }

  if $account_expiry_days {
    $account_expiry_days_ensure = present
  } else {
    $account_expiry_days_ensure = absent
  }

  pe_hocon_setting { "${container}.rbac.account-expiry-days":
    ensure  => $account_expiry_days_ensure,
    path    => "/etc/puppetlabs/${container}/conf.d/rbac.conf",
    setting => 'rbac.account-expiry-days',
    value   => $account_expiry_days,
  }

  puppet_enterprise::trapperkeeper::database_settings { 'rbac' :
    container           => $container,
    database_host       => $database_host,
    database_name       => $database_name,
    database_password   => $database_password,
    database_port       => Integer($database_port),
    database_properties => $database_properties,
    database_user       => $database_user,
    migration_user      => $database_migration_user,
    migration_password  => $database_password,
    group               => $group,
    user                => $user,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:rbac rbac-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.rbac',
    service   => 'rbac-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:rbac rbac-storage-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.storage.permissioned',
    service   => 'rbac-storage-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:rbac rbac-http-api-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.http.api',
    service   => 'rbac-http-api-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:rbac rbac-authn-middleware" :
    ensure    => absent,
    container => $container,
    namespace => 'puppetlabs.rbac.services.http.middleware',
    service   => 'rbac-authn-middleware',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:rbac activity-reporting-service" :
    container => $container,
    namespace => 'puppetlabs.activity.services',
    service   => 'activity-reporting-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:rbac jetty9-service" :
    container => $container,
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:rbac audit-service" :
    container => $container,
    namespace => 'puppetlabs.rbac.services.audit',
    service   => 'audit-service',
  }
}
