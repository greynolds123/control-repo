# Profile for setting up an ActiveMQ hub.
#
# An ActiveMQ hub is basically a broker, with the addition of a `networkConnectors` section. That
# configuration section is responsible for setting up the communication of each broker so that the
# network will act as a hub and spoke configuration.
#
# The profile will pass all parameters through to puppet_enterprise::profile::amq::broker, and then
# collect the exported network_connector resources.
#
# For more information, see the [README.md](./README.md#spoke)
#
# @param brokername [String] Sets the name of this broker; which must be unique in the network
# @param heap_mb [Integer] Sets the Xms and Xmx java properties on ActiveMQ.
# @param keystore_password [String] The password for the Java keystore used by ActiveMQ's SSLContext.
# @param truststore_password [String] The password for the Java truststore used by ActiveMQ's SSLContext.
# @param network_ttl [Integer] The number of brokers in the network that messages and subscriptions can
#         pass through
# @param openwire_protocol [String] The type of connection that brokers will use to communicate with
#         each other. There is currently a bug in the version of ActiveMQ we ship that prevents us from
#         enabling ssl+nio due to us removing SSLv3.
# @param openwire_transport_options [Hash] List of transport options to be appended to the connection
#         string. This list is NOT additive and will overwrite PE's defaults which will renable SSLv3.
# @param stomp_protocol [String] The type of connection that clients (MCollective) will be using to
#         talk with the broker.
# @param stomp_transport_options [Hash] List of transport options to be appended to the connection
#         string. This list is NOT additive and will overwrite PE's defaults which will renable SSLv3.
# @param stomp_port [Integer] Port to listen on for client messages. It is not recommended to alter the
#         parameter on this profile, but instead of the puppet_enterprise class. Otherwise you will
#         also need to update the mcollective profile to reflect the port change.
# @param stomp_user [String] The username for sending messages over the stomp protocol.
# @param stomp_passowrd [String] The stomp password.
# @param enable_web_console [Boolean] If true, will enable ActiveMQ's web console. Additional manual
#         configuration may be requried in the jetty.xml file, located next to activemq.xml.
# @param memory_usage [String] The max amount of memory the broker can use for storing messages before
#         storing messages on disk. Values of the form "20 mb", "1024kb", and "1g" can be used.
# @param store_usage [String] The amount of disk space usable for storing persistent messages. Values
#         of the form "20 mb", "1024kb", and "1g" can be used.
# @param temp_usage [String] The amount of disk space usable for storing non-persistent messages.
#         Values of the form "20 mb", "1024kb", and "1g" can be used.
# @param network_connector_export_tag [String] The tag name to use when exporting this hubs network
#         connector. Only useful in a meshed hub and spoke configuration.
# @param network_connector_spoke_collect_tag [String] The tag name of brokers to collect. In a meshed
#         hub and spoke setup, this will need to be unique for each set of hub and spokes. The tag
#         on the broker group should be set as well to match this.
# @param use_dedicated_task_runner [Boolean] Whether or not to enable the dedicated task runner.
#         For increased performance, recommended that this is left as false.
class puppet_enterprise::profile::amq::hub (
  $brokername         = $puppet_enterprise::params::activemq_brokername,
  $heap_mb            = $puppet_enterprise::params::activemq_heap_mb,
  $keystore_password     = $puppet_enterprise::params::activemq_java_ks_password,
  $truststore_password   = $puppet_enterprise::params::activemq_java_ts_password,
  $network_ttl        = $puppet_enterprise::params::activemq_network_ttl,
  $openwire_protocol  = $puppet_enterprise::params::openwire_protocol,
  Integer $openwire_port = $puppet_enterprise::params::openwire_port,
  $stomp_protocol     = $puppet_enterprise::params::stomp_protocol,
  $stomp_port         = $puppet_enterprise::mcollective_middleware_port,
  $stomp_user         = $puppet_enterprise::mcollective_middleware_user,
  $stomp_password     = $puppet_enterprise::mcollective_middleware_password,
  $enable_web_console  = false,
  $memory_usage        = '200mb',
  $store_usage         = '1gb',
  $temp_usage          = '1gb',
  $network_connector_export_tag = "pe-amq-network-connectors-hub-mesh",
  $network_connector_spoke_collect_tag = undef,
  $use_dedicated_task_runner = false,
) inherits puppet_enterprise {

  pe_validate_bool($use_dedicated_task_runner)

  class { 'puppet_enterprise::profile::amq::broker':
    brokername                => $brokername,
    heap_mb                   => $heap_mb,
    keystore_password         => $keystore_password,
    network_ttl               => $network_ttl,
    truststore_password       => $truststore_password,
    openwire_protocol         => $openwire_protocol,
    stomp_password            => $stomp_password,
    stomp_port                => $stomp_port,
    stomp_protocol            => $stomp_protocol,
    stomp_user                => $stomp_user,
    enable_web_console        => $enable_web_console,
    memory_usage              => $memory_usage,
    store_usage               => $store_usage,
    temp_usage                => $temp_usage,
    network_connector_tag     => $network_connector_export_tag,
    activemq_hubname          => $brokername,
    use_dedicated_task_runner => $use_dedicated_task_runner,
    openwire_port             => $openwire_port,
  }

  $_spoke_collect_tag = $network_connector_spoke_collect_tag ? {
    undef   => "pe-amq-network-connectors-for-${brokername}",
    default => $network_connector_spoke_collect_tag,
  }

  Puppet_enterprise::Amq::Config::Network_connector <<| tag == $_spoke_collect_tag |>>
  Puppet_enterprise::Amq::Config::Network_connector <<| tag == $network_connector_export_tag |>>
}
