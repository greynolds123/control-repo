# Profile for configuring the puppet enterprise console.
#
#
# @param ca_host [String] The certificate authority host name.
# @param certname [String] The certname the console will use to encrypt network traffic.
# @param database_host [String] The hostname running PostgreSQL.
# @param database_port [Integer] The port that PostgreSQL is listening on.
# @param database_properties [String] A url encoded string of JDBC options.
# @param master_host [String] The hostname of the Puppet Master.
# @param master_port [Integer] The port of the Puppet Master.
# @param master_certname [String] The master certificate name.
# @param puppetdb_host Array[String] The hostname running puppetdb.
# @param puppetdb_port Array[Integer] The port that puppetdb is listening on.
# @param listen_address [String] The network interface used by the console.
# @param ssl_listen_address [String] The network interface used by the console for ssl connections.
# @param dashboard_listen_port [Integer] *Deprecated* The port that the dashboard is listening on.
# @param dashboard_ssl_listen_port [Integer] *Deprecated* The port that the dashboard is listening on for ssl
#        connections.
# @param dashboard_database_name [String] *Deprecated* The name of the dashboard database.
# @param dashboard_database_user [String] *Deprecated* The user account for the dashboard DB.
# @param dashboard_database_password [String] *Deprecated* The password for the user set by
#        dashboard_database_user.
# @param console_ssl_listen_port [Integer] The port that the console is listening on for ssl
#        connections.
# @param console_services_listen_port [Integer] The port that console services is listening on.
#        The default is 4430.
# @param console_services_ssl_listen_port [Integer] The port that console services is listening
#        on for ssl connections. The default is 4431.
# @param console_services_api_listen_port [Integer] The port that the console services api is
#        listening on. The default is 4432.
# @param console_services_api_ssl_listen_port [Integer] The port that the console services api
#        is listening on for ssl connections. The default is 4433.
# @param console_services_plaintext_status_enabled [Boolean] This parameter will enable the
#        plain HTTP version of the console services status endpoint. The default value is false.
# @param console_services_plaintext_status_port [Boolean] The port that the plain HTTP status endpoint
#        listens on. The default is 8123.
#        plain HTTP version of the console services status endpoint. The default value is false.
# @param activity_database_name [String] The activity database name.
# @param activity_database_user [String] The username for login to the activity DB.
# @param activity_database_migration__user [String] The username for migrating the activity DB.
# @param activity_database_password [String] The password for user defined by activity_database_user.
# @param activity_url_prefix [String] The url prefix for the activity api.
# @param classifier_database_name [String] The name for classifier's database.
# @param classifier_database_user [String] The username that can login to the classifier DB.
# @param classifier_database_migration_user [String] The username for migrating the classifier DB.
# @param classifier_database_password [String] The password for the user defined by
#        classifier_database_user.
# @param classifier_url_prefix [String] The url prefix for the classifier api.
# @param classifier_synchronization_period [Integer] How often to synchronize classification data between the master and classifier.
# @param classifier_prune_threshold [Integer] How many days of node check-ins to keep in the classifier database.
# @param classifier_node_check_in_storage [Boolean] Whether or not to store node checkin data
# @param classifier_allow_config_data [Boolean] Whether or not to enable hiera data in the classifier
# @param rbac_database_name [String] The name for the rbac service's database.
# @param rbac_database_user [String] The username that can login to the rbac DB.
# @param rbac_database_migration_user [String] The username for migrating the rbac DB.
# @param rbac_database_password [String] The password for the user defined by rbac_database_user.
# @param rbac_url_prefix [String] The url prefix for the rbac api.
# @param rbac_password_reset_expiration [Integer] When a user doesn't remember their current password,
#        an administrator can generate a token for them to change their password. The duration, in
#        hours, that this generated token is valid can be changed with this config parameter. The
#        default value is 24.
# @param rbac_session_timeout [Integer] Positive integer that specifies how long a user's session
#        should last in minutes. The default value is 60.
# @param session_maximum_lifetime Optional[String] Positive integer that specifies the maximum allowable
#        that a console session can be valid for. Supported units are: "s" (seconds), "m" (minutes),
#        "h" (hours), "d" (days), "y" (years). May be set to "0" to not expire before the maximum token lifetime.
#        Units are specified as a single letter following an integer, for example "1d" (1 day).
#        If no units are specified, the integer is treated as seconds.
# @param rbac_token_auth_lifetime [String] This parameter is the time interval before new RBAC tokens
#        expire. Units are specified as a single letter following an integer, for example "1d" (1 day).
#        Supported units are: "s" (seconds), "m" (minutes), "h" (hours), "d" (days), "y" (years).
#        May be set to "0" to generate tokens that never expire. The default value is "5m".
# @param rbac_token_maximum_lifetime [String] The maximum allowable lifetime
#        for an rbac token, specified in the same format as rbac_token_auth_lifetime.
# @param rbac_failed_attempts_lockout [Integer] This parameter is a positive integer that specifies
#        how many failed login attempts are allowed on an account before that account is revoked.
#        The default value is 10.
# @param rbac_ds_trust_chain [String] This parameter is file path string that indicates the location
#        of a certificate to use when contacting the directory service configured for use with RBAC
#        over LDAPS.
# @param rbac_account_expiry_check_minutes [Integer] The polling frequency of the job to revoke idle
#        non-superuser user accounts.
# @param rbac_account_expiry_days [Integer] The number of days after which idle non-superuser users will be
#        revoked. If this value is not set or has a value less than 1 the revocation job will be disabled.
# @param localcacert [String] The path to the local CA certificate. This will be used instead of the
#        CA that is in Puppet's ssl dir.
# @param hostcrl [String] Path to certificate revocation list file.
# @param delayed_job_workers [Integer] Number of delayed job workers.
# @param disable_live_management [Boolean] This parameter will disable live management when set to
#        true. The default is false.
# @param migrate_db [Boolean] This parameter will allow automatic migration of the database.
# @param whitelisted_certnames [Array] An array of certificates allowed to communicate directly with
#        the console. This list is added to the base PE certificate list.
# @param java_args [String] Command line options for the Java binary, most notably
#        the -Xmx (max heap size) flag.
# @param browser_ssl_cert [String] Sets the path to the server certificate PEM file used by the
#        console for HTTPS.
# @param browser_ssl_private_key [String] For use with a custom CA, the path to a private key for
#        your public console ca certificate.
# @param send_analytics_data [Boolean] Enable/disable data analytics collection.
class puppet_enterprise::profile::console (
  $ca_host                                   = $puppet_enterprise::certificate_authority_host,
  $certname                                  = $facts['clientcert'],
  $database_host                             = $puppet_enterprise::console_database_host,
  $database_port                             = $puppet_enterprise::database_port,
  $database_properties                       = $puppet_enterprise::database_properties,
  $master_host                               = $puppet_enterprise::puppet_master_host,
  Integer $master_port                       = $puppet_enterprise::puppet_master_port,
  $master_certname                           = $puppet_enterprise::puppet_master_host,
  Array[String]  $puppetdb_host              = $puppet_enterprise::puppetdb_hosts_array,
  Array[Integer] $puppetdb_port              = $puppet_enterprise::puppetdb_ports_array,
  $listen_address                            = $puppet_enterprise::params::plaintext_address,
  $ssl_listen_address                        = $puppet_enterprise::params::ssl_address,
  $dashboard_listen_port                     = undef,
  $dashboard_ssl_listen_port                 = undef,
  $dashboard_database_name                   = undef,
  $dashboard_database_user                   = undef,
  $dashboard_database_password               = undef,
  $console_ssl_listen_port                   = $puppet_enterprise::console_port,
  $console_services_listen_port              = $puppet_enterprise::params::console_services_listen_port,
  $console_services_ssl_listen_port          = $puppet_enterprise::params::console_services_ssl_listen_port,
  $console_services_api_listen_port          = $puppet_enterprise::params::console_services_api_listen_port,
  $console_services_api_ssl_listen_port      = $puppet_enterprise::api_port,
  $console_services_plaintext_status_enabled = false,
  $console_services_plaintext_status_port    = 8123,
  $console_services_service_alert_timeout    = undef,
  $activity_url_prefix                       = $puppet_enterprise::params::activity_url_prefix,
  $activity_database_name                    = $puppet_enterprise::activity_database_name,
  $activity_database_migration_user          = $puppet_enterprise::activity_service_migration_db_user,
  $activity_database_user                    = $puppet_enterprise::activity_service_regular_db_user,
  $activity_database_password                = $puppet_enterprise::activity_database_password,
  $classifier_database_name                  = $puppet_enterprise::classifier_database_name,
  $classifier_database_migration_user        = $puppet_enterprise::classifier_service_migration_db_user,
  $classifier_database_user                  = $puppet_enterprise::classifier_service_regular_db_user,
  $classifier_database_password              = $puppet_enterprise::classifier_database_password,
  $classifier_url_prefix                     = $puppet_enterprise::params::classifier_url_prefix,
  $classifier_synchronization_period         = $puppet_enterprise::params::classifier_synchronization_period,
  $classifier_prune_threshold                = $puppet_enterprise::params::classifier_prune_threshold,
  Boolean $classifier_node_check_in_storage  = false,
  Boolean $classifier_allow_config_data      = $puppet_enterprise::params::classifier_allow_config_data,
  $rbac_database_name                        = $puppet_enterprise::rbac_database_name,
  $rbac_database_migration_user              = $puppet_enterprise::rbac_service_migration_db_user,
  $rbac_database_user                        = $puppet_enterprise::rbac_service_regular_db_user,
  $rbac_database_password                    = $puppet_enterprise::rbac_database_password,
  $rbac_url_prefix                           = $puppet_enterprise::params::rbac_url_prefix,
  $rbac_password_reset_expiration            = undef,
  Optional[Integer] $rbac_session_timeout    = undef,
  Optional[String] $session_maximum_lifetime = undef,
  $rbac_token_auth_lifetime                  = undef,
  # ENTERPRISE-1143: Has to be double quotes because of... HOCON reasons (might
  # be a bug in Puppet itself, or the HOCON library, or the HOCON module.)
  $rbac_token_maximum_lifetime                          = "10y", # lint:ignore:double_quoted_strings
  $rbac_failed_attempts_lockout                         = undef,
  $rbac_ds_trust_chain                                  = undef,
  Optional[Integer] $rbac_account_expiry_check_minutes  = undef,
  Optional[Integer] $rbac_account_expiry_days           = undef,
  $localcacert                                          = $puppet_enterprise::params::localcacert,
  $hostcrl                                              = $puppet_enterprise::params::hostcrl,
  $delayed_job_workers                                  = 2,
  $disable_live_management                              = true,
  $migrate_db                                           = false,
  $whitelisted_certnames                                = [],
  Hash $java_args                                       = $puppet_enterprise::params::console_services_java_args,
  $browser_ssl_cert                                     = undef,
  $browser_ssl_private_key                              = undef,
  $proxy_read_timeout                                   = 120,
  Integer $pcp_timeout                                  = 5,
  Boolean $display_local_time                           = false,
  Boolean $send_analytics_data                          = $puppet_enterprise::send_analytics_data,
  Puppet_enterprise::Replication_mode $replication_mode = 'none',
) inherits puppet_enterprise {

  $classifier_client_certname = $certname
  $console_client_certname    = $certname
  $console_server_certname    = $certname


  # We need this check here, otherwise on a mono-install
  # we will have a duplicate file resource.
  if $master_certname != $certname {
    $analytics_opt_out_ensure = $send_analytics_data ? {
      true  => absent,
      false => file,
    }

    file { '/etc/puppetlabs/analytics-opt-out':
      ensure  => $analytics_opt_out_ensure,
      notify  => Service['pe-console-services'],
      require => Package['pe-console-services']
    }
  }

  class { 'puppet_enterprise::profile::console::certs':
    certname    => $certname,
    localcacert => $localcacert,
    hostcrl     => $hostcrl,
    require     => Package['pe-console-services'],
  }

  if $puppet_enterprise::database_ssl and $puppet_enterprise::database_cert_auth {
    $console_ssl_dir = $puppet_enterprise::console_services_ssl_dir
    $client_pk8_key  = "${console_ssl_dir}/${console_server_certname}.private_key.pk8"
    $client_cert     = "${console_ssl_dir}/${console_server_certname}.cert.pem"
    $ssl_database_properties = "${database_properties}&sslkey=${client_pk8_key}&sslcert=${client_cert}"
  } else {
    $ssl_database_properties = $database_properties
  }

  include puppet_enterprise::packages
  Package <| tag == 'pe-console-packages' |> {
    before +> Class['puppet_enterprise::profile::console::console_services_config'],
  }

  # Unfortunately because we have no HOCON module
  # we have to keep the webserver config at the profile level.
  # When a HOCON module exists this class will consist of entries in
  # console-services' webserver/global confs for the apis (nc, rbac, activity).
  class { 'puppet_enterprise::profile::console::console_services_config':
    certname              => $certname,
    listen_address        => $listen_address,
    listen_port           => $console_services_listen_port,
    ssl_listen_address    => $ssl_listen_address,
    ssl_listen_port       => $console_services_ssl_listen_port,
    api_listen_port       => $console_services_api_listen_port,
    api_ssl_listen_port   => $console_services_api_ssl_listen_port,
    localcacert           => $localcacert,
    classifier_url_prefix => $classifier_url_prefix,
    activity_url_prefix   => $activity_url_prefix,
    rbac_url_prefix       => $rbac_url_prefix,
    status_proxy_enabled  => $console_services_plaintext_status_enabled,
    status_proxy_port     => $console_services_plaintext_status_port,
    replication_mode      => $replication_mode,
    notify                => Service[ 'pe-console-services' ],
  }

  puppet_enterprise::trapperkeeper::activity { 'console-services' :
    database_host           => $database_host,
    database_port           => $database_port,
    database_name           => $activity_database_name,
    database_user           => $activity_database_user,
    database_migration_user => $activity_database_migration_user,
    database_password       => $activity_database_password,
    database_properties     => $ssl_database_properties,
    rbac_host               => '127.0.0.1',
    rbac_port               => $console_services_api_listen_port,
    rbac_url_prefix         => $rbac_url_prefix,
    notify                  => Service['pe-console-services'],
  }

  puppet_enterprise::trapperkeeper::rbac { 'console-services' :
    certname                     => $certname,
    localcacert                  => $localcacert,
    database_host                => $database_host,
    database_port                => $database_port,
    database_name                => $rbac_database_name,
    database_user                => $rbac_database_user,
    database_migration_user      => $rbac_database_migration_user,
    database_password            => $rbac_database_password,
    database_properties          => $ssl_database_properties,
    password_reset_expiration    => $rbac_password_reset_expiration,
    token_auth_lifetime          => $rbac_token_auth_lifetime,
    token_maximum_lifetime       => $rbac_token_maximum_lifetime,
    failed_attempts_lockout      => $rbac_failed_attempts_lockout,
    ds_trust_chain               => $rbac_ds_trust_chain,
    account_expiry_check_minutes => $rbac_account_expiry_check_minutes,
    account_expiry_days          => $rbac_account_expiry_days,
    notify                       => Service['pe-console-services'],
  }

  file { '/etc/puppetlabs/console-services/rbac-certificate-whitelist':
    ensure => file,
    group  => 'pe-console-services',
    owner  => 'pe-console-services',
    mode   => '0640',
  }


  if $settings::storeconfigs {
    $whitelist_query_result =
      puppetdb_query(['from', 'resources',
                      ['extract', 'certname',
                        ['and',
                          ['=', 'type', 'Class'],
                          ['=', ['node','active'], true],
                          ['or',
                            ['=', 'title', 'Puppet_enterprise::Profile::Master'],
                            ['=', 'title', 'Puppet_enterprise::Profile::Puppetdb'],
                            ['=', 'title', 'Puppet_enterprise::Profile::Orchestrator']]]]])

    $dynamic_whitelisted_certnames = $whitelist_query_result.map |$row| { $row['certname'] }
  } else {
    $dynamic_whitelisted_certnames = []
  }
  $certs = pe_unique(
             pe_union([$master_certname, $certname],
                      pe_union($whitelisted_certnames,
                               $dynamic_whitelisted_certnames)))

  $certs.map |$cert| {
    puppet_enterprise::certs::whitelist_entry { "rbac cert whitelist entry: ${cert}":
      certname => $cert,
      target   => '/etc/puppetlabs/console-services/rbac-certificate-whitelist',
      notify   => Service['pe-console-services'],
      require  => File['/etc/puppetlabs/console-services/rbac-certificate-whitelist'],
    }
  }

  puppet_enterprise::trapperkeeper::classifier { 'console-services' :
    master_host             => $master_host,
    master_port             => $master_port,
    database_host           => $database_host,
    database_port           => $database_port,
    database_name           => $classifier_database_name,
    database_user           => $classifier_database_user,
    database_migration_user => $classifier_database_migration_user,
    database_password       => $classifier_database_password,
    database_properties     => $ssl_database_properties,
    client_certname         => $classifier_client_certname,
    localcacert             => $localcacert,
    synchronization_period  => $classifier_synchronization_period,
    prune_days_threshold    => $classifier_prune_threshold,
    allow_config_data       => $classifier_allow_config_data,
    node_check_in_storage   => $classifier_node_check_in_storage,
    notify                  => Service['pe-console-services'],
  }

  class { 'puppet_enterprise::console_services':
    client_certname          => $console_client_certname,
    master_host              => $master_host,
    classifier_host          => '127.0.0.1',
    classifier_port          => $console_services_api_listen_port,
    classifier_url_prefix    => $classifier_url_prefix,
    puppetdb_host            => $puppetdb_host,
    puppetdb_port            => $puppetdb_port,
    rbac_host                => '127.0.0.1',
    rbac_port                => $console_services_api_listen_port,
    activity_host            => '127.0.0.1',
    activity_port            => $console_services_api_listen_port,
    activity_url_prefix      => $activity_url_prefix,
    orchestrator_host        => $master_host,
    orchestrator_port        => $puppet_enterprise::orchestrator_port,
    orchestrator_url_prefix  => $puppet_enterprise::orchestrator_url_prefix,
    localcacert              => $localcacert,
    java_args                => $java_args,
    status_proxy_enabled     => $console_services_plaintext_status_enabled,
    pcp_timeout              => $pcp_timeout,
    service_alert_timeout    => $console_services_service_alert_timeout,
    display_local_time       => $display_local_time,
    session_maximum_lifetime => $session_maximum_lifetime,
    session_timeout          => $rbac_session_timeout,
    replication_mode         => $replication_mode,
  }


  class { 'puppet_enterprise::profile::console::proxy' :
    certname                           => $certname,
    trapperkeeper_proxy_listen_address => $listen_address,
    trapperkeeper_proxy_listen_port    => $console_services_listen_port,
    proxy_read_timeout                 => $proxy_read_timeout,
    ssl_listen_address                 => $ssl_listen_address,
    ssl_listen_port                    => $console_ssl_listen_port,
    browser_ssl_cert                   => $browser_ssl_cert,
    browser_ssl_private_key            => $browser_ssl_private_key,
    replication_mode                   => $replication_mode,
    require                            => Class['puppet_enterprise::profile::console::certs'],
  }

  include puppet_enterprise::profile::console::cache
}
