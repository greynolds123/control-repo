class puppet_enterprise(
  $certificate_authority_host,
  $certificate_authority_port      = 8140,

  String $pcp_broker_host          = $puppet_master_host,

  $puppet_master_host,
  $puppet_master_port              = undef,

  $console_host,
  $console_port                    = 443,

  # In PE 3.4, it is assumed that the services api and dashboard are running on
  # the same host as the console. At this time parameters are provided for
  # changing the service ports for the api and dashboard, but not for changing
  # either the composite api host or individual service host(s).

  $api_port                        = $puppet_enterprise::params::console_services_api_ssl_listen_port,
  $dashboard_port                  = 4435,

  $puppetdb_host,
  $puppetdb_port                   = 8081,

  $database_host,
  $database_port                   = 5432,

  $dashboard_database_name         = 'console',
  $dashboard_database_user         = 'console',
  $dashboard_database_password     = undef,

  $puppetdb_database_name          = 'pe-puppetdb',
  $puppetdb_database_user          = 'pe-puppetdb',
  $puppetdb_database_password      = undef,

  $classifier_database_name        = 'pe-classifier',
  $classifier_database_user        = 'pe-classifier',
  $classifier_database_password    = undef,
  $classifier_url_prefix           = $puppet_enterprise::params::classifier_url_prefix,

  $activity_database_name          = 'pe-activity',
  $activity_database_user          = 'pe-activity',
  $activity_database_password      = undef,
  $activity_url_prefix             = $puppet_enterprise::params::activity_url_prefix,

  $rbac_database_name              = 'pe-rbac',
  $rbac_database_user              = 'pe-rbac',
  $rbac_database_password          = undef,
  $rbac_url_prefix                 = $puppet_enterprise::params::rbac_url_prefix,

  $database_ssl                    = true,
  Boolean $database_cert_auth      = true,

  $license_key_path                = '/etc/puppetlabs/license.key',

  $send_analytics_data             = true,

  $mcollective_middleware_hosts,
  $mcollective_middleware_port     = 61613,
  $mcollective_middleware_user     = 'mcollective',
  $mcollective_middleware_password = $puppet_enterprise::params::stomp_password,
  $manage_symlinks                 = $::platform_symlink_writable,
  Integer $pcp_broker_port         = 8142,
) inherits puppet_enterprise::params {
  service { "pe-puppetserver":
    ensure => running,
    enable => true,
  }

}
