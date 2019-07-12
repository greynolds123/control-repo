# Profile for creating a MCollective server.
#
# For more information, see the [README.md](./README.md)
#
# @param activemq_brokers [Array] List of ActiveMQ brokers.
# @param allow_no_actionpolicy [Integer] Determine if Action Policies are required by default.
#         Valid values: 1 or 0. Value of 1 indicates no actionpolicies are required.
# @param collectives [Array] List of collectives that this client should talk to.
# @param create_user [String] Whether or not we should create and manage this users account on disk.
# @param main_collective [String] The collective this client should direct Registration messages to.
# @param mco_fact_cache_time [Integer] The time out for the facts cache.
# @param mco_identity [String] The node's name or identity. This should be unique for each node, but
#         does not need to be.
# @param mco_identity [String] The loglevel of the MCO server.
#         Valid values: fatal, error, warn, info, or debug.
# @param mco_registerinterval [Integer] How long (in seconds) to wait between registration messages.
#         Setting this to 0 disables registration.
# @param randomize_activemq [Boolean] Whether to randomize the order of the connection pool before connecting.
# @param stomp_passowrd [String] The stomp password.
# @param stomp_port [Integer] The port that the stomp service is listening on.
# @param stomp_user [String] The username for sending messages over the stomp protocol.
# @param mco_arbitrary_server_config Optional[Array[String]] takes settings like ['foo = bar', 'baz = bah']
class puppet_enterprise::profile::mcollective::agent (
  Array[String] $activemq_brokers = $puppet_enterprise::mcollective_middleware_hosts,
  String  $allow_no_actionpolicy  = $puppet_enterprise::params::mco_require_actionpolicy,
  Array[String] $collectives      = ['mcollective'],
  String  $main_collective        = 'mcollective',
  Boolean $manage_metadata_cron   = true,
  Integer $mco_fact_cache_time    = $puppet_enterprise::params::mco_fact_cache_time,
  String  $mco_identity           = $puppet_enterprise::params::mco_identity,
  String  $mco_loglevel           = $puppet_enterprise::params::mco_loglevel,
  Integer $mco_registerinterval   = $puppet_enterprise::params::mco_registerinterval,
  Boolean $randomize_activemq     = false,
  String  $stomp_password         = $puppet_enterprise::mcollective_middleware_password,
  Integer $stomp_port             = $puppet_enterprise::mcollective_middleware_port,
  String  $stomp_user             = $puppet_enterprise::mcollective_middleware_user,
  Optional[Array[String]] $mco_arbitrary_server_config = undef,
) inherits puppet_enterprise {

  pe_validate_re($allow_no_actionpolicy, '^[0-1]$')
  if !($mco_loglevel in ['fatal','error','warn','info','debug']) {
    fail("loglevel must be either fatal, error, warn, info, or debug; not ${mco_loglevel}")
  }

  # Don't accept the shared server public key as a client, or every server can
  # act as a client!
  file { "${puppet_enterprise::params::mco_clients_cert_dir}/${puppet_enterprise::params::mco_server_name}-public.pem":
    ensure => absent,
  }

  class { 'puppet_enterprise::mcollective::server':
    activemq_brokers      => $activemq_brokers,
    allow_no_actionpolicy => $allow_no_actionpolicy,
    collectives           => $collectives,
    main_collective       => $main_collective,
    manage_metadata_cron  => $manage_metadata_cron,
    mco_fact_cache_time   => $mco_fact_cache_time,
    mco_identity          => $mco_identity,
    mco_loglevel          => $mco_loglevel,
    mco_registerinterval  => $mco_registerinterval,
    randomize_activemq    => $randomize_activemq,
    stomp_password        => $stomp_password,
    stomp_port            => $stomp_port,
    stomp_user            => $stomp_user,
    mco_arbitrary_server_config => $mco_arbitrary_server_config,
  }
}
