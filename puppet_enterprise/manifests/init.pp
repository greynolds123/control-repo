# This is the base class that acts as the source of truth for information about a customers
# PE stack. Things like hostnames, ports and DB information should go here.
#
# This class should not be called directly, but rather is used by the profiles.
#
# For more information, see the [README.md](./README.md)
#
# @param certificate_authority_host [String] The hostname of the node acting as a certificate authority.
# @param certificate_authority_port [Integer] The port the CA service is listening on.
# @param puppet_master_host [String] The hostname of the node running the Puppet Server service.
#     In the case of a Large Enterprise Installation, this should be the Master of Masters.
# @param puppet_master_port [Integer] The port the Puppet Server service is listening on.
# @param api_port [Integer] The ssl port that the console services API is listening on.
# @param dashboard_port [Integer] *Deprecated* The ssl port that the old ruby based dashboard service is listening on.
# @param puppetdb_host Variant[String,Array[String]] The hostname running PuppetDB.
# @param puppetdb_port [Integer] The ssl port that PuppetDB is listening on.
# @param database_host [String] The hostname running PostgreSQL.
# @param database_port [Integer] The port that PostgreSQL is listening on.
# @param dashboard_database_name [String] *Deprecated* The name of the reports database.
# @param dashboard_database_user [String] *Deprecated* The username that can login to the console DB.
# @param dashboard_database_password [String] *Deprecated* The password for the user that can login to the console DB.
# @param puppetdb_database_name [String] The name for PuppetDB's database.
# @param puppetdb_database_user [String] The username that can login to the PuppetDB DB.
# @param puppetdb_database_password [String] The password for the user that can login to the PuppetDB DB.
# @param classifier_database_name [String] The name for classifier's database.
# @param classifier_database_user [String] The username that can login to the classifier DB.
# @param classifier_database_password [String] The password for the user that can login to the classifier DB.
# @param classifier_url_prefix [String] The url prefix for the classifier api.
# @param activity_database_name [String] The name for activity service's database.
# @param activity_database_user [String] The username that can login to the activity DB.
# @param activity_database_password [String] The password for the user that can login to the activity DB.
# @param activity_url_prefix [String] The url prefix for the activity api.
# @param rbac_database_name [String] The name for the rbac service's database..
# @param rbac_database_user [String] The username that can login to the rbac DB.
# @param rbac_database_password [String] The password for the user that can login to the rbac DB.
# @param rbac_url_prefix [String] The url prefix for the rbac api.
# @param puppetdb_database_name [String] The name for PuppetDB's database.
# @param puppetdb_database_user [String] The username that can login to the PuppetDB DB.
# @param puppetdb_database_password [String] The password for the user that can login to the PuppetDB DB.
# @param database_ssl [Boolean] Whether or not to enable SSL when connecting with PostgreSQL.
# @param database_cert_auth [Boolean] Whether or not to enable SSL cert auth when connecting with PostgreSQL.
# @param license_key_path [String] File path (absolute or w/in a module) to the license file. Defaults to the license installed on the PE Master.
# @param mcollective_middleware_hosts [Array] List of ActiveMQ brokers for mcollective
# @param mcollective_middleware_port [Integer] The port that ActiveMQ's STOMP service is listening on.
# @param mcollective_middleware_user [String] The STOMP user that can talk to ActiveMQ.
# @param mcollective_middleware_password [String] The password for the STOMP user.
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links.
# @param pcp_broker_host [String] Hostname of pcp broker.
# @param console_host [string] Hostname of console node.
# @param send_analytics_data [Boolean] Flag to enable data analytics collection
class puppet_enterprise (
  String $puppet_master_host,
  String $certificate_authority_host          = $puppet_master_host,
  Array[String] $mcollective_middleware_hosts = [$puppet_master_host],
  String $pcp_broker_host                     = $puppet_master_host,
  String $console_host                        = $puppet_master_host,
  Variant[String,Array[String]] $puppetdb_host = $puppet_master_host,
  String $database_host                       = pe_any2array($puppetdb_host)[0],

  $certificate_authority_port      = 8140,
  $puppet_master_port              = undef,

  $console_port                    = 443,

  # In PE 3.7, it is assumed that the services api and dashboard are running on
  # the same host as the console. At this time parameters are provided for
  # changing the service ports for the api and dashboard, but not for changing
  # either the composite api host or individual service host(s).

  $api_port                        = $puppet_enterprise::params::console_services_api_ssl_listen_port,
  $dashboard_port                  = undef,

  $puppetdb_port                   = 8081,

  $database_port                   = 5432,

  $dashboard_database_name         = undef,
  $dashboard_database_user         = undef,
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

  $orchestrator_database_name      = 'pe-orchestrator',
  $orchestrator_database_user      = 'pe-orchestrator',
  $orchestrator_database_password  = undef,

  $use_application_services        = undef,

  Boolean $database_ssl            = true,
  Boolean $database_cert_auth      = true,

  $license_key_path                = $puppet_enterprise::params::dest_license_key_path,
  # Opts users into data analytics collection
  $send_analytics_data             = true,

  $mcollective_middleware_port     = 61613,
  $mcollective_middleware_user     = 'mcollective',
  $mcollective_middleware_password = $puppet_enterprise::params::stomp_password,
  Boolean $manage_symlinks         = $::platform_symlink_writable,
  Integer $pcp_broker_port         = 8142,
) inherits puppet_enterprise::params {

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

  # Console services ssl directory
  $console_services_ssl_dir = "${server_data_dir}/console-services/certs"

  # The puppet-agent share directory (augeas)
  $puppet_share_dir    = '/opt/puppetlabs/puppet/share'

  # Location of PE packages being served be the master of masters
  $packages_dir        = '/opt/puppetlabs/server/data/packages'
  # The puppet-agent packages are available through Puppet at this fileserver mount point
  $packages_mountpoint = 'pe_packages'

  # Location of PE module tarballs copied from installer
  $module_tarballsrc   = "${server_share_dir}/installer/modules"
  # Module tarballs available through Puppet at this fileserver mount point
  $module_mountpoint   = 'pe_modules'

  # Postgresql variables required to coordinate installation of postgresql client
  # on either master or database node
  # The actual package name for the postgresql client.
  $postgresql_client_package_name = 'pe-postgresql'
  # The ensure parameter value for postgresql package installation.
  $postgresql_ensure = 'latest'


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
  $orchestrator_url = "https://${puppet_master_host}:8143"
  $rbac_url = "https://${console_host}:${api_port}${rbac_url_prefix}"

  if ($use_application_services != undef) {
    warning('Deprecation: $puppet_enterprise::use_application_services is deprecated and will be ignored')
  }
}
