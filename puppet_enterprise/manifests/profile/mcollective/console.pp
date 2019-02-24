# WARNING: This class is obsolete and will be removed in a future version
# of Puppet Enterprise.  Please remove it from your classification.
#
# Profile for creating the console mcollective user && client. This is a special user that lives on
# the console node and is intended for issuing orchestration commands via the live management page.
#
# For more information, see the [README.md](./README.md)
#
# @param activemq_brokers [Array] List of ActiveMQ brokers.
# @param collectives [Array] List of collectives that this client should talk to.
# @param create_user [String] Whether or not we should create and manage this users account on disk.
# @param home_dir [String] The home directory of the puppet-dashboard system user.
# @param main_collective [String] The collective this client should direct Registration messages to.
# @param randomize_activemq [Boolean] Whether to randomize the order of the connection pool before connecting.
# @param stomp_passowrd [String] The stomp password.
# @param stomp_port [Integer] The port that the stomp service is listening on.
# @param stomp_user [String] The username for sending messages over the stomp protocol.
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
class puppet_enterprise::profile::mcollective::console(
  $activemq_brokers        = $puppet_enterprise::mcollective_middleware_hosts,
  $collectives             = ['mcollective'],
  $create_user             = $puppet_enterprise::params::mco_create_client_user,
  $home_dir                = '/opt/puppet/share/puppet-dashboard',
  $main_collective         = 'mcollective',
  $randomize_activemq      = false,
  $stomp_password          = $puppet_enterprise::mcollective_middleware_password,
  $stomp_port              = $puppet_enterprise::mcollective_middleware_port,
  $stomp_user              = $puppet_enterprise::mcollective_middleware_user,
  Boolean $manage_symlinks = $puppet_enterprise::manage_symlinks,
) inherits puppet_enterprise {
}
