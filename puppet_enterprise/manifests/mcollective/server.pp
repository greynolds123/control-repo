# Defined type for creating and managing an mcollective server.
#
# @param activemq_brokers [Array] List of ActiveMQ brokers.
# @param activemq_heartbeat_interval [Integer] Time inbetween hearbeat signals. Useful if AMQ is behind
#         a loadbalancer.
# @param allow_no_actionpolicy [Integer] Determine if Action Policies are required by default.
#         Valid values: 1 or 0. Value of 1 indicates no actionpolicies are required.
# @param collectives [Array] List of collectives that this client should talk to.
# @param main_collective [String] The collective this client should direct Registration messages to.
# @param max_hbrlck_fails [Integer] Maximum amount of heartbeat lock obtain failures before assuming
#         the connection is dead and reconnecting.
# @param mco_identity [String] The node's name or identity. This should be unique for each node, but
#         does not need to be.
# @param mco_registerinterval [Integer] How long (in seconds) to wait between registration messages.
#         Setting this to 0 disables registration.
# @param randomize_activemq [Boolean] Whether to randomize the order of the connection pool before connecting.
# @param stomp_passowrd [String] The stomp password.
# @param stomp_port [Integer] The port that the stomp service is listening on.
# @param stomp_user [String] The username for sending messages over the stomp protocol.
# @param mco_arbitrary_server_config Optional[Array[String]] takes settings like ['foo = bar', 'baz = bah']
class puppet_enterprise::mcollective::server(
  $activemq_brokers            = $puppet_enterprise::params::activemq_brokers,
  $activemq_heartbeat_interval = $puppet_enterprise::params::activemq_heartbeat_interval,
  $allow_no_actionpolicy       = $puppet_enterprise::params::mco_require_actionpolicy,
  $main_collective             = 'mcollective',
  $max_hbrlck_fails            = 0,
  $manage_metadata_cron        = true,
  $mco_fact_cache_time         = $puppet_enterprise::params::mco_fact_cache_time,
  $mco_identity                = $puppet_enterprise::params::mco_identity,
  $mco_loglevel                = $puppet_enterprise::params::mco_loglevel,
  $mco_registerinterval        = $puppet_enterprise::params::mco_registerinterval,
  $randomize_activemq          = false,
  $stomp_password              = $puppet_enterprise::params::stomp_password,
  $stomp_port                  = $puppet_enterprise::mcollective_middleware_port,
  $stomp_user                  = $puppet_enterprise::params::stomp_user,
  $collectives                 = ['mcollective'],
  Optional[Array[String]] $mco_arbitrary_server_config = undef,
) inherits puppet_enterprise {

  pe_validate_re($allow_no_actionpolicy, '^[0-1]$')

  include puppet_enterprise::mcollective::server::plugins
  include puppet_enterprise::mcollective::server::logs
  include puppet_enterprise::mcollective::server::certs

  class { 'puppet_enterprise::mcollective::server::facter':
    manage_metadata_cron  => $manage_metadata_cron,
  }

  # Manage the MCollective server configuration
  # Template uses:
  # - $activemq_brokers
  # - $activemq_heartbeat_interval
  # - $allow_no_actionpolicy
  # - $max_hbrlck_fails
  # - $mco_audit_log_file
  # - $mco_etc
  # - $mco_fact_cache_time
  # - $mco_identity
  # - $mco_loglevel
  # - $mco_plugin_libdir
  # - $mco_registerinterval
  # - $mco_server_log_file
  # - $mco_server_name
  # - $mco_ssl_dir
  # - $randomize_activemq
  # - $stomp_password
  # - $stomp_port
  # - $stomp_user
  # - $mco_arbitrary_server_config
  file { "${puppet_enterprise::params::mco_etc}/server.cfg":
    content => template('puppet_enterprise/mcollective/server.cfg.erb'),
    mode    => '0660',
    notify  => Service['mcollective'],
  }

  include puppet_enterprise::mcollective::service
  include puppet_enterprise::mcollective::cleanup
}
