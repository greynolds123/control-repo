# This is the base class that acts as the source of truth for information about a customers
# PE stack. Things like hostnames, ports and DB information should go here.
#
# This class should not be called directly, but rather is used by the profiles.
#
# For more information, see the [README.md](./README.md)
#
# @param allow_unauthenticated_status [Boolean] True allows unauthenticated access, by default. False requires authentication on the application's status-service endpoint.
# @param certificate_authority_host [String] The hostname of the node acting as a certificate authority.
# @param certificate_authority_port [Integer] The port the CA service is listening on.
# @param puppet_master_host [String] The hostname of the node running the Puppet Server service.
#     In the case of a Large Enterprise Installation, this should be the Master of Masters.
# @param puppet_master_port [Integer] The port the Puppet Server service is listening on.
# @param api_port [Integer] The ssl port that the console services API is listening on.
# @param console_port [Integer] The ssl port that the console services web interface is listening on.
# @param puppetdb_host Variant[String,Array[String]] The hostname running PuppetDB.
# @param puppetdb_port Variant[String,Array[String],Integer, Array[Integer]] The ssl port that PuppetDB is listening on.
# @param database_host [String] The hostname running PostgreSQL.
# @param database_port [Integer] The port that PostgreSQL is listening on.
# @param puppetdb_database_name [String] The name for PuppetDB's database.
# @param puppetdb_database_user [String] The username that can login to the PuppetDB DB.
# @param puppetdb_database_password [String] The password for the user that can login to the PuppetDB DB.
# @param puppetdb_sync_interval_minutes [Integer] The polling interval PuppetDB
#    will use to synchronize with it's sync peers.
# @param classifier_database_name [String] The name for classifier's database.
# @param classifier_database_password [String] The password for the user that can login to the classifier DB.
# @param classifier_url_prefix [String] The url prefix for the classifier api.
# @param activity_database_name [String] The name for activity service's database.
# @param activity_database_password [String] The password for the user that can login to the activity DB.
# @param activity_url_prefix [String] The url prefix for the activity api.
# @param rbac_database_name [String] The name for the rbac service's database.
# @param rbac_database_password [String] The password for the user that can login to the rbac DB.
# @param rbac_url_prefix [String] The url prefix for the rbac api.
# @param use_application_services [Boolean] Whether to enable application management features in orchestrator.
# @param orchestrator_database_name [String] The name for the orchestrator service's database.
# @param orchestrator_database_password [String] The password for the user that can login to the orchestrator DB.
# @param inventory_database_name [String] The name for the inventory service's database.
# @param inventory_database_password [String] The password for the user that can login to the inventory DB.
# @param puppetdb_database_name [String] The name for PuppetDB's database.
# @param puppetdb_database_password [String] The password for the user that can login to the PuppetDB DB.
# @param database_ssl [Boolean] Whether or not to enable SSL when connecting with PostgreSQL.
# @param database_cert_auth [Boolean] Whether or not to enable SSL cert auth when connecting with PostgreSQL.
# @param license_key_path [String] File path (absolute or w/in a module) to the license file. Defaults to the license installed on the PE Master.
# @param ssl_protocols [Array[String]] The list of SSL protocols to allow.
# @param ssl_cipher_suites [Array[String]] The list of SSL cipher suites to allow.
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links.
# @param pcp_broker_host [String] Hostname of pcp broker.
# @param console_host [string] Hostname of console node.
# @param send_analytics_data [Boolean] Flag to enable data analytics collection.
# @param ha_enabled_replicas [Array[String]] A list of replicas that are ready to serve various services requests
# what the app should expect when interacting with its database.
class puppet_enterprise (
  String $puppet_master_host,
  Boolean $allow_unauthenticated_status       = true,
  String $certificate_authority_host          = $puppet_master_host,
  String $pcp_broker_host                     = $puppet_master_host,
  String $console_host                        = $puppet_master_host,
  Variant[String,Array[String]] $puppetdb_host = $puppet_master_host,
  String $database_host                       = pe_any2array($puppetdb_host)[0],

  String $puppetdb_database_host              = $database_host,
  String $console_database_host               = $database_host,
  String $orchestrator_database_host          = $database_host,
  String $inventory_database_host             = $orchestrator_database_host,

  # Do not data type any ports until we no longer rely on the classifier.
  # Installer versions pre MEEP set ports as strings in the classifier, not ints.
  $certificate_authority_port      = 8140,
  $puppet_master_port              = 8140,

  $console_port                    = 443,

  # In PE 3.7, it is assumed that the services api and dashboard are running on
  # the same host as the console. At this time parameters are provided for
  # changing the service ports for the api and dashboard, but not for changing
  # either the composite api host or individual service host(s).

  $api_port                        = $puppet_enterprise::params::console_services_api_ssl_listen_port,

  Variant[String,Array[String],Integer,Array[Integer]] $puppetdb_port = 8081,

  $database_port                   = 5432,

  $puppetdb_database_name          = 'pe-puppetdb',
  $puppetdb_database_user          = 'pe-puppetdb',
  $puppetdb_database_password      = undef,

  $classifier_database_name                  = 'pe-classifier',

  String $classifier_database_super_user = 'pe-classifier',
  String $classifier_database_read_user  = 'pe-classifier-read',
  String $classifier_database_write_user = 'pe-classifier-write',

  String $classifier_service_regular_db_user   = $classifier_database_write_user,
  String $classifier_service_migration_db_user = $classifier_database_super_user,

  $classifier_database_password              = undef,
  $classifier_url_prefix                     = $puppet_enterprise::params::classifier_url_prefix,

  $activity_database_name                  = 'pe-activity',

  String $activity_database_super_user     = 'pe-activity',
  String $activity_database_read_user      = 'pe-activity-read',
  String $activity_database_write_user     = 'pe-activity-write',

  String $activity_service_migration_db_user = $activity_database_super_user,
  String $activity_service_regular_db_user  = $activity_database_write_user,

  $activity_database_password              = undef,
  $activity_url_prefix                     = $puppet_enterprise::params::activity_url_prefix,

  $rbac_database_name             = 'pe-rbac',

  String $rbac_database_super_user = 'pe-rbac',
  String $rbac_database_read_user  = 'pe-rbac-read',
  String $rbac_database_write_user = 'pe-rbac-write',

  String $rbac_service_migration_db_user = $rbac_database_super_user,
  String $rbac_service_regular_db_user   = $rbac_database_write_user,

  $rbac_database_password              = undef,
  $rbac_url_prefix                     = $puppet_enterprise::params::rbac_url_prefix,

  $orchestrator_url_prefix                     = '/orchestrator',
  String $inventory_url_prefix                 = '/inventory',
  $orchestrator_database_name                  = 'pe-orchestrator',
  String $inventory_database_name              = 'pe-inventory',

  String $orchestrator_database_super_user = 'pe-orchestrator',
  String $orchestrator_database_read_user  = 'pe-orchestrator-read',
  String $orchestrator_database_write_user = 'pe-orchestrator-write',
  String $inventory_database_super_user = 'pe-inventory',
  String $inventory_database_read_user  = 'pe-inventory-read',
  String $inventory_database_write_user = 'pe-inventory-write',

  String $orchestrator_service_migration_db_user = $orchestrator_database_super_user,
  String $orchestrator_service_regular_db_user   = $orchestrator_database_write_user,
  String $inventory_service_migration_db_user = $inventory_database_super_user,
  String $inventory_service_regular_db_user   = $inventory_database_write_user,

  $orchestrator_database_password               = undef,
  Optional[String] $inventory_database_password = undef,
  Integer $orchestrator_port                    = 8143,
  Integer $bolt_server_port                     = 62658,
  Integer $bolt_server_concurrency              = 100,
  Integer $plan_executor_port                   = 62659,
  Integer $plan_executor_workers                = 1,

  Integer $ace_server_port        = 44633,
  Integer $ace_server_concurrency = 10,

  Integer $pglogical_keepalives_idle = 30,
  Optional[Integer] $pglogical_keepalives_interval = undef,
  Integer $pglogical_keepalives_count = 2,

  $use_application_services        = undef,

  Boolean $database_ssl            = true,
  Boolean $database_cert_auth      = true,

  $license_key_path                = $puppet_enterprise::params::dest_license_key_path,
  # Opts users into data analytics collection
  $send_analytics_data             = true,

  Array[String] $ssl_protocols     = ['TLSv1.2'],
  Array[String] $ssl_cipher_suites = [],
  Boolean $manage_symlinks         = $facts['platform_symlink_writable'],
  Integer $pcp_broker_port         = 8142,
  Integer $puppetdb_sync_interval_minutes = 2,
  Optional[Array[String]] $ha_enabled_replicas = [],
) inherits puppet_enterprise::params {

  $puppetdb_hosts_array  = pe_flatten([$puppetdb_host])
  $puppetdb_ports_array  = pe_flatten([$puppetdb_port]).map | $port | {
    Integer($port)
  }

  File {
    mode => '0644',
  }

  # This is the base puppet enterprise bin directory, where the core binaries
  # for puppet, facter, hiera, etc. are linked.
  $puppetlabs_bin_dir = '/opt/puppetlabs/bin'

  # Base puppet enterprise server directory
  $puppet_server_dir   = '/opt/puppetlabs/server'
  # Base bin directory for server side tools and services
  $server_bin_dir      = "${puppet_server_dir}/bin"
  # Base puppet enterprise server side share directory
  $server_share_dir    = "${puppet_server_dir}/share"
  # System wide modules directory included in $basemodulepath setting
  $system_module_dir   = '/opt/puppetlabs/puppet/modules'
  # Base puppet enterprise data directory
  $server_data_dir     = "${puppet_server_dir}/data"

  #PE nginx
  $nginx_conf_dir = '/etc/puppetlabs/nginx'

  # Console services ssl directory
  $console_services_ssl_dir = "${server_data_dir}/console-services/certs"

  # The puppet-agent share directory (augeas)
  $puppet_share_dir    = '/opt/puppetlabs/puppet/share'

  # Location of PE packages being served be the master of masters
  $packages_dir        = '/opt/puppetlabs/server/data/packages'
  # The puppet-agent packages are available through Puppet at this fileserver mount point
  $packages_mountpoint = 'pe_packages'

  # The module mountpoint has been unused since 2016.4.5, but we need this
  # to be able to remove the fileserver mountpoint for pe_modules from the CA
  # and Replica during upgrades.
  $module_mountpoint   = 'pe_modules'

  # Postgresql variables required to coordinate installation of postgresql client
  # on either master or database node
  # The ensure parameter value for postgresql package installation.
  $postgresql_ensure = 'latest'

  $pg_user = 'pe-postgres'
  $pg_group = $pg_user
  $pg_psql_path = "${server_bin_dir}/psql"

  # ANCHORS
  # When building a complex multi-tier model, it is not known up front which
  # profiles will be deployed to a given node. However, some profiles when
  # deployed together have dependencies which must be expressed. For example,
  # the CA must be set up and configured before certificates can be requested.
  # Therefore the CA must be configured before any certificate-requiring
  # service. Since the profiles cannot express those dependencies directly
  # against each other, since they may or may not exist in a given node's
  # catalog, we instead have them express dependencies against common anchors.

  pe_anchor { 'puppet_enterprise:barrier:ca': }

  # VARIABLES
  # Several variables consumed by child classes are generated based on
  # user-specified parameters to this class. These must be set here instead of
  # in params because they are dynamic based on user specified data, and not
  # just defaults.

  if $database_ssl {
    $database_properties = $puppet_enterprise::params::jdbc_ssl_properties
  } else {
    $database_properties = ''
  }

  $code_manager_url = "https://${puppet_master_host}:8170/code-manager"
  $orchestrator_url = "https://${puppet_master_host}:${orchestrator_port}"
  $rbac_url = "https://${console_host}:${api_port}${rbac_url_prefix}"

  $analytics_host = $puppet_master_host
  $analytics_port = $puppet_master_port
}
