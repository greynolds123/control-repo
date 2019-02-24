# Profile for creating the peadmin mcollective user && client. This is a special user that lives on
# the puppet master node and is intended for issuing orchestration commands.
#
# For more information, see the [README.md](./README.md)
#
# @param activemq_brokers [Array] List of ActiveMQ brokers.
# @param collectives [Array] List of collectives that this client should talk to.
# @param create_user [String] Whether or not we should create and manage this users account on disk.
# @param home_dir [String] The home directory of the peadmin system user.
# @param main_collective [String] The collective this client should direct Registration messages to.
# @param randomize_activemq [Boolean] Whether to randomize the order of the connection pool before connecting.
# @param stomp_passowrd [String] The stomp password.
# @param stomp_port [Integer] The port that the stomp service is listening on.
# @param stomp_user [String] The username for sending messages over the stomp protocol.
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
# @param $mco_disovery_timeout Optional[Integer] Control the timeout for how long to discover nodes
# @param mco_arbitrary_client_config Optional[Array[String]] takes settings like ['foo = bar', 'baz = bah']
class puppet_enterprise::profile::mcollective::peadmin(
  $activemq_brokers        = $puppet_enterprise::mcollective_middleware_hosts,
  $collectives             = ['mcollective'],
  $create_user             = $puppet_enterprise::params::mco_create_client_user,
  $home_dir                = '/var/lib/peadmin',
  $main_collective         = 'mcollective',
  $randomize_activemq      = false,
  $stomp_password          = $puppet_enterprise::mcollective_middleware_password,
  $stomp_port              = $puppet_enterprise::mcollective_middleware_port,
  $stomp_user              = $puppet_enterprise::mcollective_middleware_user,
  Boolean $manage_symlinks = $puppet_enterprise::manage_symlinks,
  Optional[Integer]       $mco_discovery_timeout       = undef,
  Optional[Array[String]] $mco_arbitrary_client_config = undef,
) inherits puppet_enterprise {

  pe_validate_array($activemq_brokers)
  pe_validate_array($collectives)
  pe_validate_bool($randomize_activemq)

  puppet_enterprise::mcollective::client { 'peadmin':
    activemq_brokers => $activemq_brokers,
    cert_name        => $puppet_enterprise::params::mco_peadmin_client_name,
    keypair_name     => $puppet_enterprise::params::mco_peadmin_keypair_name,
    create_user      => $create_user,
    home_dir         => $home_dir,
    logfile          => "${home_dir}/.mcollective.d/client.log",
    main_collective  => $main_collective,
    stomp_password   => $stomp_password,
    stomp_port       => $stomp_port,
    stomp_user       => $stomp_user,
    collectives      => $collectives,
    manage_symlinks  => $manage_symlinks,
    randomize_activemq => $randomize_activemq,
    mco_discovery_timeout       => $mco_discovery_timeout,
    mco_arbitrary_client_config => $mco_arbitrary_client_config,
  }
}
