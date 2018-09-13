# Internal class for Puppet Enterprise to configure the Puppet Server
#
# @param metrics_webservice_enabled [Boolean] Toggle whether to enable the /metrics endpoint.
# @param metrics_server_id [String] What ID to tag the metrics with
# @param metrics_jmx_enabled [Boolean] Toggle whether to run with JMX (Java Management Extensions) enabled.
# @param metrics_graphite_enabled [Boolean] Toggle whether to write metrics to Graphite.
# @param metrics_puppetserver_metrics_allowed [Array] A whitelist of metric names to be sent to the enabled reporters.
# @param profiler_enabled [Boolean] Whether to run the Java profiler.
# @param file_sync_puppet_code_repo [String] The id of the file sync repo that contains the puppet code.
# @param jruby_max_active_instances [Integer] The maximum number of jruby instances that the Puppet Server will spawn to server Agent traffic.
# @param jruby_max_requests_per_instance [Integer] The maximum number of requests a single JRuby instance will handle before it is flushed from memory and refreshed.
# @param jruby_borrow_timeout [Integer] Set the timeout when attempting to borrow an instance from the JRuby pool in milliseconds. Defaults is 1200000.
# @param jruby_environment_class_cache_enabled [Boolean] Whether or not Puppet Server should enable the use of caching for requests made to the environment_classes endpoint.
# @param certname [String] The cert name the Server will use.
# @param localcacert [String] The path to the local CA cert used for generating SSL certs.
# @param puppet_admin_certs [Array] Certificates to add to the whitelist on the master.
# @param static_files [Hash] Paths to static files to serve up on the master. Keys are the URLs the files will be found at, values are the paths to the folders to be served.
# @param java_args [Hash] Key-value pairs describing the java arguments to be passed when starting the master
# @param tk_jetty_max_threads [Integer] Maxiumum number of Jerry threads that should be started
# @param ssl_protocols [Array] List of acceptable protocols for making HTTP requests
# @param cipher_suites [Array] A list of acceptable cipher suites for making HTTP requests
# @param idle_timeout_milliseconds [Integer] The amount of time an outbound HTTP connection will wait for data to be available before closing the socket
# @param connect_timeout_milliseconds [Integer] The amount of time an outbound HTTP connection will wait to connect before giving up
# @param code_manager_auto_configure [Boolean] Configure code-manager based on r10k params
class puppet_enterprise::master::puppetserver(
  $metrics_graphite_enabled,
  $metrics_puppetserver_metrics_allowed,
  $metrics_jmx_enabled,
  $metrics_server_id,
  $profiler_enabled,
  String $puppetserver_jruby_puppet_master_code_dir,
  Optional[Boolean] $metrics_webservice_enabled            = undef,
  String $file_sync_puppet_code_repo                       = 'puppet-code',
  $certname                                                = $::clientcert,
  Optional[Array[String]] $cipher_suites                   = undef,
  Optional[Integer] $connect_timeout_milliseconds          = undef,
  Optional[Integer] $idle_timeout_milliseconds             = undef,
  Hash $java_args                                          = $puppet_enterprise::params::puppetserver_java_args,
  Optional[Integer] $jruby_borrow_timeout                  = undef,
  Optional[Integer] $jruby_max_active_instances            = undef,
  Integer $jruby_max_requests_per_instance                 = 10000,
  Optional[Boolean] $jruby_environment_class_cache_enabled = undef,
  $localcacert                                             = $puppet_enterprise::params::localcacert,
  Array[String] $base_puppet_admin_certs                   = [$::clientcert],
  Array[String] $puppet_admin_certs                        = [],
  Optional[Array[String]] $ssl_protocols                   = undef,
  Hash $static_files                                       = {},
  Optional[Integer] $tk_jetty_max_threads                  = undef,
  $puppetserver_webserver_ssl_host                         = '0.0.0.0',
  $puppetserver_webserver_ssl_port                         = '8140',
  $puppetserver_jruby_puppet_gem_home                      = '/opt/puppetlabs/server/data/puppetserver/jruby-gems',
  $puppetserver_jruby_puppet_master_conf_dir               = '/etc/puppetlabs/puppet',
  $puppetserver_jruby_puppet_master_var_dir                = '/opt/puppetlabs/server/data/puppetserver',
  $puppetserver_jruby_puppet_master_run_dir                = '/var/run/puppetlabs/puppetserver',
  $puppetserver_jruby_puppet_master_log_dir                = '/var/log/puppetlabs/puppetserver',
  Array[String] $puppetserver_jruby_puppet_ruby_load_path  = ['/opt/puppetlabs/puppet/lib/ruby/vendor_ruby', '/opt/puppetlabs/puppet/cache/lib'],
  $service_stop_retries                                    = 60,
  $start_timeout                                           = 120,
  Optional[Boolean] $code_manager_auto_configure           = undef,
  Optional[String]  $djava_io_tmpdir                       = undef,
) inherits puppet_enterprise::params {

  pe_validate_single_integer($service_stop_retries)
  pe_validate_single_integer($start_timeout)

  $container = 'puppetserver'
  $_puppet_admin_certs = $base_puppet_admin_certs + $puppet_admin_certs

  File {
    ensure => present,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
  }

  Pe_concat {
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
  }

  Pe_hocon_setting {
    ensure => present,
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
    namespace => 'puppetlabs.enterprise.services.master.master-service',
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

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'metrics-puppet-profiler-service' :
    namespace => 'puppetlabs.enterprise.services.puppet-profiler.puppet-profiler-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'pe-metrics-service' :
    namespace => 'puppetlabs.enterprise.services.metrics.pe-metrics-service',
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

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'analytics-service' :
    namespace => 'puppetlabs.enterprise.services.analytics.analytics-service',
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

  pe_hocon_setting{ 'webserver.puppet-server.default-server':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.default-server',
    value   => true,
  }
  pe_hocon_setting{ 'webserver.puppet-server.client-auth':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.client-auth',
    value   => 'want',
  }
  pe_hocon_setting{ 'webserver.puppet-server.ssl-host':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.ssl-host',
    value   => $puppetserver_webserver_ssl_host,
  }
  pe_hocon_setting{ 'webserver.puppet-server.ssl-port':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.ssl-port',
    value   => $puppetserver_webserver_ssl_port,
  }
  pe_hocon_setting{ 'webserver.puppet-server.ssl-cert':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.ssl-cert',
    value   => "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
  }
  pe_hocon_setting{ 'webserver.puppet-server.ssl-key':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.ssl-key',
    value   => "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
  }
  pe_hocon_setting{ 'webserver.puppet-server.ssl-ca-cert':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.ssl-ca-cert',
    value   => $localcacert,
  }
  pe_hocon_setting{ 'webserver.puppet-server.ssl-crl-path':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.ssl-crl-path',
    value   => $hostcrl,
  }
  pe_hocon_setting{ 'webserver.puppet-server.access-log-config':
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.access-log-config',
    value   => "${confdir}/request-logging.xml",
  }

  if $tk_jetty_max_threads {
    $tk_jetty_max_threads_ensure = present
  } else {
    $tk_jetty_max_threads_ensure = absent
  }

  pe_hocon_setting{ 'webserver.puppet-server.max-threads':
    ensure  => $tk_jetty_max_threads_ensure,
    path    => "${confdir}/conf.d/webserver.conf",
    setting => 'webserver.puppet-server.max-threads',
    value   => $tk_jetty_max_threads,
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

  pe_hocon_setting { 'web-router-service/pe-master-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.enterprise.services.master.master-service/pe-master-service"',
    value   => '/puppet',
  }
  pe_hocon_setting { 'web-router-service/legacy-routes-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.services.legacy-routes.legacy-routes-service/legacy-routes-service"',
    value   => '',
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

  # Puppetserver 2.x does not use this route in PE
  pe_hocon_setting { 'web-router-service/remove-master-service':
    ensure  => absent,
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.services.master.master-service/master-service"',
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

  if $metrics_webservice_enabled == true {
    $metrics_webservice_webrouting_ensure = present

    puppet_enterprise::trapperkeeper::bootstrap_cfg { "metrics-webservice" :
      namespace => 'puppetlabs.trapperkeeper.services.metrics.metrics-service',
      service   => 'metrics-webservice',
    }

  } else {
    $metrics_webservice_webrouting_ensure = absent
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
    value   => $file_sync_puppet_code_repo,
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

  if $ssl_protocols and !pe_empty($ssl_protocols) {
    $ssl_protocols_ensure = present
  } else {
    $ssl_protocols_ensure = absent
  }

  pe_hocon_setting { 'http-client.ssl-protocols':
    ensure  => $ssl_protocols_ensure,
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

  # Uses
  #   $confdir
  #   $certname
  #   $localcacert
  file { "${confdir}/conf.d/global.conf" :
    ensure => present,
  }
  pe_hocon_setting { "${confdir}/conf.d/global.conf#global.logging-config":
    path    => "${confdir}/conf.d/global.conf",
    setting => 'global.logging-config',
    value   => "${confdir}/logback.xml",
  }
  pe_hocon_setting { "${confdir}/conf.d/global.conf#global.hostname":
    path    => "${confdir}/conf.d/global.conf",
    setting => 'global.hostname',
    value   => $certname,
  }
  pe_hocon_setting{ 'global.certs.ssl-cert':
    path    => "${confdir}/conf.d/global.conf",
    setting => 'global.certs.ssl-cert',
    value   => "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
  }
  pe_hocon_setting{ 'global.certs.ssl-key':
    path    => "${confdir}/conf.d/global.conf",
    setting => 'global.certs.ssl-key',
    value   => "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
  }
  pe_hocon_setting{ 'global.certs.ssl-ca-cert':
    path    => "${confdir}/conf.d/global.conf",
    setting => 'global.certs.ssl-ca-cert',
    value   => $localcacert,
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
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.enabled',
    ensure => absent,
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
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.registries.puppetserver.metrics-allowed',
    value   => $metrics_puppetserver_metrics_allowed,
    type    => 'array',
    ensure  => $metrics_puppetserver_metrics_allowed_ensure,
  }

  ## Handle upgrade changes for metrics.conf
  ## See PE-16992 - This upgrade code was added in in 2016.3, and it can be removed when
  ## 2016.2 is no longer supported

  # Reporter enabling/disabling is under metrics.registries.<domain>.reporters now
  pe_hocon_setting { 'metrics.reporters.graphite.enabled':
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.reporters.graphite.enabled',
    ensure  => absent,
  }

  # There are no settings under metrics.reporters.jmx any more
  pe_hocon_setting { 'metrics.reporters.jmx':
    path    => "${confdir}/conf.d/metrics.conf",
    setting => 'metrics.reporters.jmx',
    ensure  => absent,
  }
  ## End Metrics upgrade section

  # Configure connections to console services
  $console_url = "https://${$::puppet_enterprise::console_host}:${console_services_api_ssl_listen_port}"

  file { "${confdir}/conf.d/rbac-consumer.conf" :
    ensure => present,
  }
  pe_hocon_setting { 'rbac-consumer.api-url':
    path    => "${confdir}/conf.d/rbac-consumer.conf",
    setting => 'rbac-consumer.api-url',
    value   => "${console_url}${rbac_url_prefix}",
  }

  file { "${confdir}/conf.d/activity-consumer.conf" :
    ensure => present,
  }

  pe_hocon_setting { 'activity-consumer.api-url':
    path    => "${confdir}/conf.d/activity-consumer.conf",
    setting => 'activity-consumer.api-url',
    value   => "${console_url}${activity_url_prefix}",
  }

  $puppetserver_initconf = "${puppet_enterprise::params::defaults_dir}/pe-puppetserver"

  $tmp_mount_options = $::mountpoints.dig( '/tmp', 'options' )
  $tmp_is_noexec = pe_empty( $tmp_mount_options ) ? {
    false   => !pe_empty( pe_grep( $tmp_mount_options , 'noexec' )),
    default => false,
  }

  $_djava_io_tmpdir = pe_pick($djava_io_tmpdir, '/opt/puppetlabs/server/apps/puppetserver/tmp')

  $_java_args = $tmp_is_noexec ? {
    true  => pe_merge($java_args, {'Djava.io.tmpdir=' => $_djava_io_tmpdir}),
    false => pe_empty($djava_io_tmpdir) ? {
        true  => $java_args,
        false => pe_merge($java_args, {'Djava.io.tmpdir=' => $_djava_io_tmpdir}),
      }
  }

  puppet_enterprise::trapperkeeper::java_args { $container :
    java_args => $_java_args,
  }

  Pe_ini_setting {
    ensure            => present,
    path              => $puppetserver_initconf,
    key_val_separator => '=',
    section           => '',
  }

  pe_ini_setting { "${container} initconf java_bin":
    setting => 'JAVA_BIN',
    value   => '"/opt/puppetlabs/server/bin/java"',
  }

  pe_ini_setting { "${container} initconf user":
    setting => 'USER',
    value   => 'pe-puppet',
  }

  pe_ini_setting { "${container} initconf group":
    setting => 'GROUP',
    value   => 'pe-puppet',
  }

  pe_ini_setting { "${container} initconf install_dir":
    setting => 'INSTALL_DIR',
    value   => '"/opt/puppetlabs/server/apps/puppetserver"',
  }

  pe_ini_setting { "${container} initconf config":
    setting => 'CONFIG',
    value   => "\"${confdir}/conf.d\"",
  }

  pe_ini_setting { "${container} initconf bootstrap_config":
    setting => 'BOOTSTRAP_CONFIG',
    value   => "\"${confdir}/bootstrap.cfg\"",
  }

  pe_ini_setting { "${container} initconf service_stop_retries":
    setting => 'SERVICE_STOP_RETRIES',
    value   => $service_stop_retries,
  }

  pe_ini_setting { "${container} initconf start_timeout":
    setting => 'START_TIMEOUT',
    value   => $start_timeout,
  }

  # PE-10520 - invalid [files] section causes puppet run failure
  if ! $::puppet_files_dir_present {
    augeas { "fileserver.conf remove [files]":
      changes   => [
        "remove files",
      ],
      onlyif    => "match files size > 0",
      incl      => '/etc/puppetlabs/puppet/fileserver.conf',
      load_path => "${puppet_enterprise::puppet_share_dir}/augeas/lenses/dist",
      lens      => 'PuppetFileserver.lns',
      notify    => Service["pe-${container}"],
    }
  }

  service { "pe-${container}":
    ensure  => running,
    enable  => true,
    require => Package["pe-${container}"],
  }
}
