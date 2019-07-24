# Internal class for Puppet Enterprise to configure the Puppet Server
#
# @param metrics_webservice_enabled [Boolean] Toggle whether to enable the /metrics endpoint.
# @param metrics_graphite_enabled [Boolean] Toggle whether to write metrics to Graphite.
# @param metrics_puppetserver_metrics_allowed [Array] A whitelist of metric names to be sent to the enabled reporters.
# @param metrics_jmx_enabled [Boolean] Toggle whether to run with JMX (Java Management Extensions) enabled.
# @param metrics_server_id [String] What ID to tag the metrics with
# @param profiler_enabled [Boolean] Whether to run the Java profiler.
# @param puppetserver_jruby_puppet_master_code_dir [String] Path to the puppet code dir. When not set it will use the puppet default.
# @param file_sync_puppet_code_repo [String] Deprecated - The id of the file sync repo that contains the puppet code.
# @param certname [String] The cert name the Server will use.
# @param cipher_suites [Array] A list of acceptable cipher suites for making HTTP requests
# @param connect_timeout_milliseconds [Integer] The amount of time an outbound HTTP connection will wait to connect before giving up
# @param idle_timeout_milliseconds [Integer] The amount of time an outbound HTTP connection will wait for data to be available before closing the socket
# @param java_args [Hash] Key-value pairs describing the java arguments to be passed when starting the master
# @param status_logging_enabled [Boolean] Toggle whether to enable periodic status logging
# @param status_logging_interval_minutes [Integer] How often to log status data for puppetserver
# @param jruby_borrow_timeout [Integer] Set the timeout when attempting to borrow an instance from the JRuby pool in milliseconds. Defaults is 1200000.
# @param jruby_max_active_instances [Integer] The maximum number of jruby instances that the Puppet Server will spawn to serve Agent traffic.
# @param jruby_max_requests_per_instance [Integer] The maximum number of requests a single JRuby instance will handle before it is flushed from memory and refreshed.
# @param jruby_environment_class_cache_enabled [Boolean] Whether or not Puppet Server should enable the use of caching for requests made to the environment_classes endpoint.
# @param jruby_jar [String] Specify a different jruby jar to load.  Default is '/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar'
# @param jruby_compile_mode [Enum] Turn JIT compiling on or off.  Default is on with 'jit', can also be 'off'.
# @param localcacert [String] The path to the local CA cert used for generating SSL certs.
# @param base_puppet_admin_certs [Array] Base list of Certificates to build upon when making the whitelist on the master.
# @param puppet_admin_certs [Array] Certificates to add to the whitelist on the master.
# @param ssl_protocols [Array] List of acceptable protocols for making and receiving HTTP requests
# @param static_files [Hash] Paths to static files to serve up on the master. Keys are the URLs the files will be found at, values are the paths to the folders to be served.
# @param tk_jetty_max_threads [Integer] Maxiumum number of Jerry threads that should be started
# @param puppetserver_webserver_ssl_host The network interface puppetserver should listen on.
# @param puppetserver_webserver_ssl_port The port puppetserver should listen on.
# @param puppetserver_jruby_puppet_gem_home The directory where gems for puppetserver will be installed and loaded from.
# @param puppetserver_jruby_puppet_master_conf_dir Path to puppet's conf dir. When not set it will use the puppet default.
# @param puppetserver_jruby_puppet_master_var_dir Path to puppet's var dir. When not set it will use the puppet default.
# @param puppetserver_jruby_puppet_master_run_dir Path to puppet's run dir. When not set it will use the puppet default.
# @param puppetserver_jruby_puppet_master_log_dir Path to puppet's log dir. When not set it will use the puppet default.
# @param puppetserver_jruby_puppet_ruby_load_path The path used for jruby to load ruby libraries such as puppet and hiera.
# @param service_stop_retries Number of seconds to wait during shutdown after the TERM signal is sent before sending a KILL signal to the process. (Only affects systemv platforms).
# @param start_timeout Number of seconds to wait during startup for the service to finish booting before timing out.
# @param code_manager_auto_configure [Boolean] Configure code-manager based on r10k params
# @param djava_io_tmpdir Directory to use as a tmpdir for puppetserver instead of the system default tmpdir.
# @param pre_commit_hook_commands [Optional[Array]] List of commands to be run (in order) prior to a commit happening.
# @param jruby_puppet_max_queued_requests [Optional[Integer]] Maximum number of queued jruby (agent) requests before responding with a 503 and retry-after headers
# @param jruby_puppet_max_retry_delay [Optional[Integer]] Maximum value for a random delay (in seconds) to give to agents when max-queued-requests has been exceeded so they can retry in that amount of time
# @param reserved_code_cache [Optional[Pattern[/^\d+[kmgKMG]$/]] How much java codecache to allow puppetserver to use (when a 2g heap is used, this defaults to 512m in params.pp)
class puppet_enterprise::master::puppetserver(
  $metrics_graphite_enabled,
  $metrics_puppetserver_metrics_allowed,
  $metrics_jmx_enabled,
  $metrics_server_id,
  $profiler_enabled,
  String $puppetserver_jruby_puppet_master_code_dir,
  Boolean  $metrics_webservice_enabled                     = true,
  Optional[String] $file_sync_puppet_code_repo             = undef,
  $certname                                                = $facts['clientcert'],
  Optional[Array[String]] $cipher_suites                   = undef,
  Optional[Integer] $connect_timeout_milliseconds          = undef,
  Optional[Integer] $idle_timeout_milliseconds             = undef,
  Hash $java_args                                          = $puppet_enterprise::params::puppetserver_java_args,
  Boolean $status_logging_enabled                          = false,
  Integer $status_logging_interval_minutes                 = 30,
  Optional[Boolean] $enable_gc_logging                     = undef,
  Optional[Integer] $jruby_borrow_timeout                  = undef,
  Optional[Integer] $jruby_max_active_instances            = undef,
  Integer $jruby_max_requests_per_instance                 = 100000,
  Optional[Boolean] $jruby_environment_class_cache_enabled = undef,
  String $jruby_jar                                        = '/opt/puppetlabs/server/apps/puppetserver/jruby-9k.jar',
  Enum['jit', 'off'] $jruby_compile_mode                   = 'jit',
  $localcacert                                             = $puppet_enterprise::params::localcacert,
  Array[String] $base_puppet_admin_certs                   = [$facts['clientcert']],
  Array[String] $puppet_admin_certs                        = [],
  Array[String] $ssl_protocols                             = $puppet_enterprise::ssl_protocols,
  Hash $static_files                                       = {},
  Optional[Integer] $tk_jetty_max_threads                  = undef,
  $puppetserver_webserver_ssl_host                         = '0.0.0.0',
  $puppetserver_webserver_ssl_port                         = $puppet_enterprise::puppet_master_port,
  $puppetserver_jruby_puppet_gem_home                      = '/opt/puppetlabs/server/data/puppetserver/jruby-gems',
  $puppetserver_jruby_puppet_master_conf_dir               = '/etc/puppetlabs/puppet',
  $puppetserver_jruby_puppet_master_var_dir                = '/opt/puppetlabs/server/data/puppetserver',
  $puppetserver_jruby_puppet_master_run_dir                = '/var/run/puppetlabs/puppetserver',
  $puppetserver_jruby_puppet_master_log_dir                = '/var/log/puppetlabs/puppetserver',
  Array[String] $puppetserver_jruby_puppet_ruby_load_path  = ['/opt/puppetlabs/puppet/lib/ruby/vendor_ruby', '/opt/puppetlabs/puppet/cache/lib'],
  $service_stop_retries                                    = 60,
  $start_timeout                                           = 300,
  Optional[Boolean] $code_manager_auto_configure           = undef,
  Optional[String]  $djava_io_tmpdir                       = undef,
  Optional[Array[String]] $pre_commit_hook_commands        = ['/opt/puppetlabs/server/bin/generate-puppet-types.rb'],
  Optional[Integer] $jruby_puppet_max_queued_requests      = undef,
  Optional[Integer] $jruby_puppet_max_retry_delay          = undef,
  Optional[Pattern[/^\d+[kmgKMG]$/]] $reserved_code_cache  = $puppet_enterprise::params::puppetserver_code_cache,
) inherits puppet_enterprise::params {
  include puppet_enterprise::packages

  pe_validate_single_integer($service_stop_retries)
  pe_validate_single_integer($start_timeout)

  $container = 'puppetserver'
  $_puppet_admin_certs = $base_puppet_admin_certs + $puppet_admin_certs

  if ($file_sync_puppet_code_repo != undef) {
    warning('Deprecation: $puppet_enterprise::master::puppetserver::file_sync_puppet_code_repo is deprecated and will be ignored')
  }

  File {
    ensure => present,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
    require => Package['pe-puppetserver'],
  }

   Pe_concat {
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
    require => Package['pe-puppetserver'],
  }

  Pe_hocon_setting {
    ensure => present,
    require => Package['pe-puppetserver'],
    notify => Service["pe-${container}"],
  }

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg {
    container => $container,
  }

  $confdir = "/etc/puppetlabs/${container}"

  puppet_enterprise::trapperkeeper::bootstrap_cfg { "${container}:master jetty9-service" :
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
    service   => 'jetty9-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'pe-master-service' :
    namespace => 'puppetlabs.enterprise.services.master.pe-master-service',
  }

  # The namespace of the pe-master-service changed in 2017.3
  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'old-pe-master-service' :
    ensure    => absent,
    namespace => 'puppetlabs.enterprise.services.master.master-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'master-service' :
    namespace => 'puppetlabs.services.master.master-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'request-handler-service' :
    namespace => 'puppetlabs.services.request-handler.request-handler-service',
  }
  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'jruby-puppet-pooled-service' :
    namespace => 'puppetlabs.services.jruby.jruby-puppet-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'jruby-pool-manager-service' :
    namespace => 'puppetlabs.services.jruby-pool-manager.jruby-pool-manager-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'metrics-service' :
    namespace => 'puppetlabs.trapperkeeper.services.metrics.metrics-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'puppet-profiler-service' :
    namespace => 'puppetlabs.services.puppet-profiler.puppet-profiler-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'pe-metrics-puppet-profiler-service' :
    namespace => 'puppetlabs.enterprise.services.puppet-profiler.pe-puppet-profiler-service',
  }

  # The name and namespace of the metrics-puppet-profiler-service changed in 2017.3
  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'metrics-puppet-profiler-service' :
    ensure    => absent,
    namespace => 'puppetlabs.enterprise.services.puppet-profiler.puppet-profiler-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'puppet-server-config-service' :
    namespace => 'puppetlabs.services.config.puppet-server-config-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'puppet-admin-service' :
    namespace => 'puppetlabs.services.puppet-admin.puppet-admin-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'webrouting-service' :
    namespace => 'puppetlabs.trapperkeeper.services.webrouting.webrouting-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'legacy-routes-service' :
    namespace => 'puppetlabs.services.legacy-routes.legacy-routes-service',
  }

  # The pe-legacy-routes-service was moved to OSS puppetserver in 2017.3 and
  # renamed to the legacy-routes-service
  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'pe-legacy-routes-service' :
    ensure    => absent,
    namespace => 'puppetlabs.enterprise.services.legacy-routes.pe-legacy-routes-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'status-service' :
    namespace => 'puppetlabs.trapperkeeper.services.status.status-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'authorization-service' :
    namespace => 'puppetlabs.trapperkeeper.services.authorization.authorization-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'scheduler-service' :
    namespace => 'puppetlabs.trapperkeeper.services.scheduler.scheduler-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'pe-jruby-metrics-service' :
    namespace => 'puppetlabs.enterprise.services.jruby.pe-jruby-metrics-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'jruby-metrics-service' :
    namespace => 'puppetlabs.services.jruby.jruby-metrics-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'puppetserver-analytics-service' :
    service => 'puppetserver-analytics-service',
    namespace => 'puppetlabs.enterprise.services.analytics.analytics-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'filesystem-watch-service' :
    namespace => 'puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'remote-rbac-consumer-service' :
    namespace => 'puppetlabs.rbac-client.services.rbac',
  }

  # Uses
  #   $certname
  #   $localcacert
  #   $static_files
  #   $tk_jetty_max_threads
  file { "${confdir}/conf.d/webserver.conf" :
    ensure => present,
  }

  pe_hocon_setting{ 'webserver.client-auth':
    ensure   => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.client-auth',
  }
  pe_hocon_setting{ 'webserver.ssl-host':
    ensure   => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-host',
  }
  pe_hocon_setting{ 'webserver.ssl-port':
    ensure   => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-port',
  }
  pe_hocon_setting{ 'webserver.ssl-cert':
    ensure   => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-cert',
  }
  pe_hocon_setting{ 'webserver.ssl-key':
    ensure   => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-key',
  }
  pe_hocon_setting{ 'webserver.ssl-ca-cert':
    ensure   => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-ca-cert',
  }
  pe_hocon_setting{ 'webserver.ssl-crl-path':
    ensure   => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.ssl-crl-path',
  }
  pe_hocon_setting{ 'webserver.access-log-config':
    ensure   => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.access-log-config',
  }
  pe_hocon_setting{ 'webserver.max-threads':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.max-threads',
  }
  pe_hocon_setting{ 'webserver.static-content':
    ensure  => absent,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.static-content',
  }

  puppet_enterprise::trapperkeeper::webserver_settings { 'puppet-server' :
    container          => $container,
    ssl_listen_address => $puppetserver_webserver_ssl_host,
    ssl_listen_port    => Integer($puppetserver_webserver_ssl_port),
    localcacert        => $localcacert,
    access_log_config  => "${confdir}/request-logging.xml",
    tk_jetty_max_threads => $tk_jetty_max_threads,
    default_server       => true,
    ssl_protocols        => $ssl_protocols,
  }

  if $static_files and !pe_empty($static_files) {
    $static_files_ensure = present
  } else {
    $static_files_ensure = absent
  }

  pe_hocon_setting{ 'webserver.puppet-server.static-content':
    ensure  => $static_files_ensure,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.static-content',
    type    => 'array',
    value   => pe_puppetserver_static_content_list($static_files),
  }

  file { "${confdir}/conf.d/web-routes.conf" :
    ensure => present,
  }

  pe_hocon_setting { 'web-router-service/master-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.services.master.master-service/master-service"',
    value   => '/puppet',
  }

  # The pe-master-service was moved to OSS puppetserver in 2017.3
  pe_hocon_setting { 'web-router-service/pe-master-service':
    ensure  => absent,
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.enterprise.services.master.master-service/pe-master-service"',
  }

  # In 2017.3, the OSS legacy-routes-service has replaced the pe-legacy-routes-service
  pe_hocon_setting { 'web-router-service/pe-legacy-routes-service':
    ensure  => absent,
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.enterprise.services.legacy-routes.pe-legacy-routes-service/pe-legacy-routes-service"',
  }
  pe_hocon_setting { 'web-router-service/legacy-routes-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.services.legacy-routes.legacy-routes-service/legacy-routes-service"',
    value   => ''
  }

  pe_hocon_setting { 'web-router-service/certificate-authority-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.services.ca.certificate-authority-service/certificate-authority-service"',
    value   => '/puppet-ca',
  }
  pe_hocon_setting { 'web-router-service/reverse-proxy-ca-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.enterprise.services.reverse-proxy.reverse-proxy-ca-service/reverse-proxy-ca-service"',
    value   => '',
  }
  pe_hocon_setting { 'web-router-service/puppet-admin-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.services.puppet-admin.puppet-admin-service/puppet-admin-service"',
    value   => '/puppet-admin-api',
  }
  pe_hocon_setting { 'web-router-service/status-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.trapperkeeper.services.status.status-service/status-service"',
    value   => '/status',
  }

  file { "${confdir}/conf.d/pe-puppet-server.conf" :
    ensure => present,
  }
  pe_hocon_setting { 'jruby-puppet.ruby-load-path':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.ruby-load-path',
    type    => 'array',
    value   => $puppetserver_jruby_puppet_ruby_load_path,
  }
  # Puppetserver 2.x moved ruby-load-path to the jruby-puppet section, and
  # os-settings had no other settings.
  pe_hocon_setting { 'os-settings.remove':
    ensure => absent,
    path     => "${confdir}/conf.d/pe-puppet-server.conf",
    setting  => 'os-settings',
  }
  pe_hocon_setting { 'jruby-puppet.gem-home':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.gem-home',
    value   => $puppetserver_jruby_puppet_gem_home,
  }
  pe_hocon_setting { 'jruby-puppet.master-conf-dir':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.master-conf-dir',
    value   => $puppetserver_jruby_puppet_master_conf_dir,
  }
  pe_hocon_setting { 'jruby-puppet.master-code-dir':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.master-code-dir',
    value   => $puppetserver_jruby_puppet_master_code_dir,
  }
  pe_hocon_setting { 'jruby-puppet.master-var-dir':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.master-var-dir',
    value   => $puppetserver_jruby_puppet_master_var_dir,
  }
  pe_hocon_setting { 'jruby-puppet.master-run-dir':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.master-run-dir',
    value   => $puppetserver_jruby_puppet_master_run_dir,
  }
  pe_hocon_setting { 'jruby-puppet.master-log-dir':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.master-log-dir',
    value   => $puppetserver_jruby_puppet_master_log_dir,
  }
  pe_hocon_setting { 'jruby-puppet.gem-path':
    ensure  => present,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.gem-path',
    value   => [
      $puppetserver_jruby_puppet_gem_home,
      '/opt/puppetlabs/server/data/puppetserver/vendored-jruby-gems',
      '/opt/puppetlabs/puppet/lib/ruby/vendor_gems',
    ]
  }

  if $jruby_borrow_timeout {
    $jruby_borrow_timeout_ensure = present
  } else {
    $jruby_borrow_timeout_ensure = absent
  }

  pe_hocon_setting { 'jruby-puppet.borrow-timeout':
    ensure  => $jruby_borrow_timeout_ensure,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.borrow-timeout',
    value   => $jruby_borrow_timeout,
  }

  if $jruby_max_active_instances {
    $jruby_max_active_instances_ensure = present
  } else {
    $jruby_max_active_instances_ensure = absent
  }

  pe_hocon_setting { 'jruby-puppet.max-active-instances':
    ensure  => $jruby_max_active_instances_ensure,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.max-active-instances',
    value   => $jruby_max_active_instances,
  }

  pe_hocon_setting { 'jruby-puppet.max-requests-per-instance':
    ensure  => present,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.max-requests-per-instance',
    value   => $jruby_max_requests_per_instance,
  }

  pe_hocon_setting { 'jruby-puppet.use-legacy-auth-conf':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.use-legacy-auth-conf',
    value   => false,
  }

  if ($jruby_max_active_instances and $jruby_puppet_max_queued_requests and
    ($jruby_max_active_instances + $jruby_puppet_max_queued_requests > 150)) {
    warning("Setting jruby_max_active_instances and jruby_puppet_max_queued_requests to more than 150 combined is not
     recommended, as Jetty may not have enough worker threads to satisfy requests.")
  }

  $_ensure_max_queued_requests = $jruby_puppet_max_queued_requests ? {
    undef   => absent,
    default => present,
  }
  pe_hocon_setting { 'jruby-puppet.max-queued-requests':
    ensure  => $_ensure_max_queued_requests,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.max-queued-requests',
    value   => $jruby_puppet_max_queued_requests,
  }

  $_ensure_max_retry_delay = $jruby_puppet_max_retry_delay ? {
    undef   => absent,
    default => present,
  }
  pe_hocon_setting { 'jruby-puppet.max-retry-delay':
    ensure  => $_ensure_max_retry_delay,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.max-retry-delay',
    value   => $jruby_puppet_max_retry_delay,
  }

  $metrics_webservice_webrouting_ensure = $metrics_webservice_enabled ? {
    true  => present,
    false => absent,
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'metrics-webservice' :
    ensure    => $metrics_webservice_webrouting_ensure,
    namespace => 'puppetlabs.trapperkeeper.services.metrics.metrics-service',
    service   => 'metrics-webservice',
  }

  pe_hocon_setting { 'metrics-service/metrics-webservice' :
    ensure  => $metrics_webservice_webrouting_ensure,
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.trapperkeeper.services.metrics.metrics-service/metrics-webservice"',
    value => '/metrics',
  }

  if $jruby_environment_class_cache_enabled == undef {
    if $code_manager_auto_configure {
      $jruby_environment_class_cache_enabled_ensure = present
      $jruby_environment_class_cache_enabled_value = true
    } else {
      $jruby_environment_class_cache_enabled_ensure = absent
      $jruby_environment_class_cache_enabled_value = undef
    }
  } else {
    $jruby_environment_class_cache_enabled_ensure = present
    $jruby_environment_class_cache_enabled_value = $jruby_environment_class_cache_enabled
  }

  pe_hocon_setting { 'jruby-puppet.environment-class-cache-enabled':
    ensure  => $jruby_environment_class_cache_enabled_ensure,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.environment-class-cache-enabled',
    value   => $jruby_environment_class_cache_enabled_value,
  }

  pe_hocon_setting { 'profiler.enabled':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'profiler.enabled',
    value   => $profiler_enabled,
  }

  pe_hocon_setting { 'pe-puppetserver.puppet-code-repo':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'pe-puppetserver.puppet-code-repo',
    value   => 'puppet-code',
  }

  if ($pre_commit_hook_commands) {
    pe_hocon_setting { 'pe-puppetserver.pre-commit-hook-commands':
      path    => "${confdir}/conf.d/pe-puppet-server.conf",
      setting => 'pe-puppetserver.pre-commit-hook-commands',
      type    => 'array',
      value   => $pre_commit_hook_commands,
    }
  }

  pe_hocon_setting { 'puppet-admin':
    ensure  => absent,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'puppet-admin',
  }

  Pe_puppet_authorization::Rule {
    ensure => present,
    notify => Service["pe-${container}"],
  }

  pe_puppet_authorization::rule { 'puppetlabs environment cache':
    match_request_path   => '/puppet-admin-api/v1/environment-cache',
    match_request_type   => 'path',
    match_request_method => 'delete',
    allow                => $_puppet_admin_certs,
    sort_order           => 500,
    path                 => "${confdir}/conf.d/auth.conf",
  }

  pe_puppet_authorization::rule { 'puppetlabs jruby pool':
    match_request_path   => '/puppet-admin-api/v1/jruby-pool',
    match_request_type   => 'path',
    match_request_method => 'delete',
    allow                => $_puppet_admin_certs,
    sort_order           => 500,
    path                 => "${confdir}/conf.d/auth.conf",
  }

  pe_hocon_setting { 'http-client.ssl-protocols':
    ensure  => present,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'http-client.ssl-protocols',
    type    => 'array',
    value   => $ssl_protocols,
  }

  if $cipher_suites and !pe_empty($cipher_suites) {
    $cipher_suites_ensure = present
  } else {
    $cipher_suites_ensure = absent
  }

  pe_hocon_setting { 'http-client.cipher-suites':
    ensure  => $cipher_suites_ensure,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'http-client.cipher-suites',
    type    => 'array',
    value   => $cipher_suites,
  }

  if $idle_timeout_milliseconds {
    $idle_timeout_milliseconds_ensure = present
  } else {
    $idle_timeout_milliseconds_ensure = absent
  }

  pe_hocon_setting { 'http-client.idle-timeout-milliseconds':
    ensure  => $idle_timeout_milliseconds_ensure,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'http-client.idle-timeout-milliseconds',
    value   => $idle_timeout_milliseconds,
  }

  if $connect_timeout_milliseconds {
    $connect_timeout_milliseconds_ensure = present
  } else {
    $connect_timeout_milliseconds_ensure = absent
  }

  pe_hocon_setting { 'http-client.connect-timeout-milliseconds':
    ensure  => $connect_timeout_milliseconds_ensure,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'http-client.connect-timeout-milliseconds',
    value   => $connect_timeout_milliseconds,
  }

  puppet_enterprise::trapperkeeper::global_settings { $container :
    service_user  => 'pe-puppet',
    service_group => 'pe-puppet',
    hostname      => $certname,
    ssl_cert      => "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
    ssl_key       => "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
    localcacert   => $localcacert,
  }

  # Uses
  #   $metrics_server_id
  #   $metrics_jmx_enabled
  #   $metrics_graphite_enabled
  #   $metrics_puppetserver_metrics_allowed
  file { "${confdir}/conf.d/metrics.conf" :
    ensure => present,
  }
  pe_hocon_setting { 'metrics.enabled':
    ensure => absent,
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.enabled',
  }
  pe_hocon_setting { 'metrics.server-id':
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.server-id',
    value   => $metrics_server_id,
  }
  # Enable or disable jmx metrics reporter for puppetserver domain
  pe_hocon_setting { 'metrics.registries.puppetserver.reporters.jmx.enabled':
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.registries.puppetserver.reporters.jmx.enabled',
    value   => $metrics_jmx_enabled,
  }
  # Enable or disable jmx metrics reporter for default domain, used by
  # pcp-broker
  pe_hocon_setting { 'metrics.registries.default.reporters.jmx.enabled':
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.registries.default.reporters.jmx.enabled',
    value   => $metrics_jmx_enabled,
  }
  # Enable or disable Graphite metrics reporter for puppetserver domain
  pe_hocon_setting { 'metrics.registries.puppetserver.reporters.graphite.enabled':
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.registries.puppetserver.reporters.graphite.enabled',
    value   => $metrics_graphite_enabled,
  }
  # Which metrics should be allowed to be sent to the enabled reporters
  if $metrics_puppetserver_metrics_allowed {
    $metrics_puppetserver_metrics_allowed_ensure = present
  } else {
    $metrics_puppetserver_metrics_allowed_ensure = absent
  }

  pe_hocon_setting { 'metrics.registries.puppetserver.metrics-allowed':
    ensure  => $metrics_puppetserver_metrics_allowed_ensure,
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.registries.puppetserver.metrics-allowed',
    value   => $metrics_puppetserver_metrics_allowed,
    type    => 'array',
  }

  ## Handle upgrade changes for metrics.conf
  ## See PE-16992 - This upgrade code was added in in 2016.3, and it can be removed when
  ## 2016.2 is no longer supported

  # Reporter enabling/disabling is under metrics.registries.<domain>.reporters now
  pe_hocon_setting { 'metrics.reporters.graphite.enabled':
    ensure  => absent,
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.reporters.graphite.enabled',
  }

  # There are no settings under metrics.reporters.jmx any more
  pe_hocon_setting { 'metrics.reporters.jmx':
    ensure  => absent,
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.reporters.jmx',
  }
  ## End Metrics upgrade section

  # Configure connections to console services
  $console_url = "https://${$::puppet_enterprise::console_host}:${$::puppet_enterprise::api_port}"

  file { "${confdir}/conf.d/rbac-consumer.conf" :
    ensure => present,
  }
  pe_hocon_setting { 'rbac-consumer.api-url':
    path    => "${confdir}/conf.d/rbac-consumer.conf",
    setting => 'rbac-consumer.api-url',
    value   => "${console_url}${puppet_enterprise::params::rbac_url_prefix}",
  }

  file { "${confdir}/conf.d/activity-consumer.conf" :
    ensure => present,
  }

  pe_hocon_setting { 'activity-consumer.api-url':
    path    => "${confdir}/conf.d/activity-consumer.conf",
    setting => 'activity-consumer.api-url',
    value   => "${console_url}${puppet_enterprise::params::activity_url_prefix}",
  }

  $_djava_io_tmpdir = pe_pick($djava_io_tmpdir, '/opt/puppetlabs/server/apps/puppetserver/tmp')
  $_tmpdir_java_args = {'Djava.io.tmpdir=' => $_djava_io_tmpdir}

  if ($reserved_code_cache) {
    # PE-25321
    if ($reserved_code_cache =~ /^(\d+)([kmgKMG])$/) {
      $rcc_integer = Integer($1)
      $rcc_unit  = $2
      $rcc_in_mb = $rcc_unit ? {
        /[kK]/ => Integer($rcc_integer / 1024),
        /[mM]/ => $rcc_integer,
        /[gG]/ => $rcc_integer * 1024,
      }
      if $rcc_in_mb > 2048 {
        warning('limiting $reserved_code_cache to its maximum of 2048 MB')
        $_reserved_code_cache_java_args = {'XX:ReservedCodeCacheSize=' => '2048m'}
      } else {
        $_reserved_code_cache_java_args = {'XX:ReservedCodeCacheSize=' => $reserved_code_cache}
      }
    }
  } else {
    $_reserved_code_cache_java_args = {}
  }

  $_java_args = pe_merge($java_args, $_tmpdir_java_args, $_reserved_code_cache_java_args)

  pe_hocon_setting { 'jruby-puppet.compile-mode':
    ensure  => present,
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'jruby-puppet.compile-mode',
    value   => $jruby_compile_mode,
  }

  if $status_logging_enabled {
    pe_hocon_setting{ 'status.debug-logging.interval-minutes':
      ensure  => present,
      path    => "${confdir}/conf.d/pe-puppet-server.conf",
      setting => 'status.debug-logging.interval-minutes',
      value   => $status_logging_interval_minutes,
    }
  } else {
    # If logging is disabled, we remove the parent of "interval-minutes".
    # Otherwise tk-status errors on startup, because interval-minutes is a
    # required key in the debug-logging section if that section is present
    pe_hocon_setting{ 'status.debug-logging':
      ensure  => absent,
      path    => "${confdir}/conf.d/pe-puppet-server.conf",
      setting => 'status.debug-logging',
    }
  }

  puppet_enterprise::trapperkeeper::java_args { $container :
    java_args => $_java_args,
    enable_gc_logging => $enable_gc_logging,
  }

  puppet_enterprise::trapperkeeper::init_defaults { $container :
    user                 => 'pe-puppet',
    group                => 'pe-puppet',
    service_stop_retries => $service_stop_retries,
    start_timeout        => $start_timeout,
    jruby_jar            => $jruby_jar
  }

  # PE-10520 - invalid [files] section causes puppet run failure
  if ! $facts['puppet_files_dir_present'] {
    augeas { 'fileserver.conf remove [files]':
      changes   => [
        'remove files',
      ],
      onlyif    => 'match files size > 0',
      incl      => '/etc/puppetlabs/puppet/fileserver.conf',
      load_path => "${puppet_enterprise::puppet_share_dir}/augeas/lenses/dist",
      lens      => 'PuppetFileserver.lns',
      notify    => Service["pe-${container}"],
    }
  }

  puppet_enterprise::trapperkeeper::pe_service { $container : }
}
