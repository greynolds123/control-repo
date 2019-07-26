# Internal class for Puppet Enterprise to manage all master-services.
#
# @param metrics_server_id [String] What ID to tag the metrics with
# @param metrics_jmx_enabled [Boolean] Toggle whether to run with JMX (Java Management Extensions) enabled.
# @param metrics_graphite_enabled [Boolean] Toggle whether to write metrics to Graphite.
# @param metrics_graphite_host [String] Graphite server to write metrics to..
# @param metrics_graphite_port [Integer] Port on Graphite server to write metrics to.
# @param metrics_graphite_update_interval_seconds [Integer] How often, in seconds, to wait between writing metrics to the Graphity server.
# @param metrics_puppetserver_metrics_allowed [Array] A whitelist of metric names to be sent to the enabled reporters.
# @param profiler_enabled [Boolean] Whether to run the Java profiler.
# @param certname [String] The cert name the Server will use.
# @param static_files [Hash] Paths to static files to serve up on the master. Keys are the URLs the files will be found at, values are the paths to the folders to be served.
# @param localcacert [String] The path to the local CA cert used for generating SSL certs.
# @param java_args [Hash] Key-value pairs describing the java arguments to be passed when starting the master
# @param environments_dir_mode [String] Permissions mode to set the Puppet environments directory to. User/group will be `pe-puppet`.
# @param enable_future_parser [Boolean] Toggle use of the "future" Puppet 4 parser.
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
# @param code_manager_auto_configure [Boolean] Configure code-manager based on r10k params
# @param puppetserver_jruby_puppet_master_code_dir [String] Path to where puppetserver should read code from.  Should match puppet.conf codedir setting
class puppet_enterprise::master(
  $metrics_server_id,
  $metrics_jmx_enabled,
  $metrics_graphite_enabled,
  $metrics_puppetserver_metrics_allowed,
  $profiler_enabled,
  String $puppetserver_jruby_puppet_master_code_dir,
  $app_management                            = $puppet_enterprise::use_application_services,
  $certname                                  = $::client_cert,
  $enable_future_parser                      = undef,
  $java_args                                 = $puppet_enterprise::params::puppetserver_java_args,
  $localcacert                               = $puppet_enterprise::params::localcacert,
  $manage_symlinks                           = true,
  Optional[Boolean] $static_catalogs         = undef,
  $static_files                              = {},
  Optional[Boolean] $code_manager_auto_configure = undef,
  Optional[String]  $environment_timeout     = undef,
) inherits puppet_enterprise::params {

  include puppet_enterprise::packages
  Package <| tag == 'pe-master-packages' |>

  include puppet_enterprise::symlinks

  $user = 'pe-puppet'
  $group = 'pe-puppet'

  if $manage_symlinks {
    File <| tag == 'pe-master-symlinks' |>
  }

  class { 'puppet_enterprise::master::puppetserver':
    certname                                 => $certname,
    localcacert                              => $localcacert,
    static_files                             => $static_files,
    java_args                                => $java_args,
    metrics_server_id                        => $metrics_server_id,
    metrics_jmx_enabled                      => $metrics_jmx_enabled,
    metrics_graphite_enabled                 => $metrics_graphite_enabled,
    metrics_puppetserver_metrics_allowed     => $metrics_puppetserver_metrics_allowed,
    profiler_enabled                         => $profiler_enabled,
    code_manager_auto_configure              => $code_manager_auto_configure,
    puppetserver_jruby_puppet_master_code_dir => $puppetserver_jruby_puppet_master_code_dir,
  }

  File {
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0644',
  }

  if !pe_empty($java_args) {
    pe_validate_hash($java_args)
  }

  # FIXME PACKAGING Should the packages set the permissions correctly?
  file { '/var/log/puppetlabs/puppet' :
    mode    => '0640',
  }

  # This is intended to establish the pe_build file on new compile masters.
  # The installer lays down pe_build for the master of masters.
  file { '/opt/puppetlabs/server/pe_build':
    ensure  => file,
    content => pe_build_version(),
  }

  # Start
  # puppet.conf
  Pe_ini_setting {
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    notify  => Service['pe-puppetserver'],
  }

  pe_ini_setting { 'puppetserver puppetconf certname' :
    setting => 'certname',
    value   => $certname,
    section => 'master',
  }

  pe_ini_setting { 'puppetserver puppetconf always_cache_features' :
    setting => 'always_cache_features',
    value   => 'true',
    section => 'master',
  }

  pe_ini_setting { 'puppetserver puppetconf user':
    setting => 'user',
    value   => $user,
    section => 'main'
  }

  pe_ini_setting { 'puppetserver puppetconf group':
    setting => 'group',
    value   => $group,
    section => 'main'
  }

  $_static_catalogs_ensure = $static_catalogs ? {
    true => 'present',
    false => 'present',
    default => 'absent',
  }

  pe_ini_setting { 'puppetserver static catalogs':
    ensure  => $_static_catalogs_ensure,
    setting => 'static_catalogs',
    value   => $static_catalogs,
    section => 'main',
  }

  $_environment_timeout_value = pe_pick( $environment_timeout, $code_manager_auto_configure ? {
    true    => 'unlimited',
    default => '0',
  } )

  pe_ini_setting { 'puppetconf environment_timeout setting':
    ensure  => present,
    setting => 'environment_timeout',
    value   => $_environment_timeout_value,
    section => 'main',
  }
  # End puppet.conf
}
