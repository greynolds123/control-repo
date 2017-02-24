# Custom define for creating and managing a network_connector element.
#
# Network connectors define the broker-to-broker links that are the basis for a network of brokers and
# how we define a hub and spoke configuration.
#
# More information on network connectors and what they do can be found at
# https://access.redhat.com/documentation/en-US/Fuse_ESB_Enterprise/7.1/html/Using_Networks_of_Brokers/files/FMQNetworksConnectors.html.
#
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param connector_name [String] Identifies this network connector instance uniquely (for example, when
#   monitoring the broker through JMX).
# @param additional_attributes [Hash] A hash of user specified attributes to add to the network
#   connector.
# @param conduit_subscriptions [Boolean] Whether or not to enable conduit subscriptions.
# @param decrease_network_consumer_priority [Boolean] If true, decrease the priority for dispatching to
#   a network Queue consumer the further away it is (in network hops) from the producer. When false all
#   network consumers use same default priority(0) as local consumers.
# @param duplex [Boolean] If true, a network connection will be used to both produce AND Consume
#   messages. This is useful for hub and spoke scenarios when the hub is behind a firewall etc.
# @param dynamic_only [Boolean] If true, only activate a networked durable subscription when a
#   corresponding durable subscription reactivates, by default they are activated on startup.
# @param excluded_collectives [Array] Destinations matching this list won't be forwarded across the
#   network.
# @param exported_by [Deprecated] Not used.
# @param included_collectives [Array] Destinations that match this list will be forwarded across the
#   network. An empty list means all destinations not in the exluded list will be forwarded.
# @param network_ttl [Integer] The number of brokers in the network that messages and subscriptions
#   can pass through (sets both message&consumer -TTL)
# @param openwire_protocol [String] The type of connection that brokers will use to communicate with
#   each other. There is currently a bug in the version of ActiveMQ we ship that prevents us from
#   enabling ssl+nio due to us removing SSLv3.
# @param stomp_user [String] The username for sending messages over the stomp protocol.
# @param stomp_passowrd [String] The stomp password.
define puppet_enterprise::amq::config::network_connector(
  $brokername,
  $connector_name,
  $additional_attributes              = {},
  $conduit_subscriptions              = true,
  $decrease_network_consumer_priority = true,
  $duplex                             = true,
  $dynamic_only                       = true,
  $excluded_collectives               = [],
  $exported_by                        = undef,
  $included_collectives               = [],
  $network_ttl                        = $puppet_enterprise::params::activemq_network_ttl,
  $openwire_protocol                  = $puppet_enterprise::params::openwire_protocol,
  Integer $openwire_port              = $puppet_enterprise::params::openwire_port,
  $stomp_password                     = $puppet_enterprise::params::stomp_password,
  $stomp_user                         = $puppet_enterprise::params::stomp_user,
) {
  pe_validate_hash($additional_attributes)

  $broker_context            = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${::clientcert}']"
  $network_connector_context = "${broker_context}/networkConnectors/networkConnector[#attribute/name='${connector_name}']"

  $_connector_name              = "set #attribute/name '${connector_name}'"
  $_uri                         = "set #attribute/uri 'static:(${openwire_protocol}://${brokername}:${openwire_port})'"
  $_username                    = "set #attribute/userName ${stomp_user}"
  $_password                    = "set #attribute/password ${stomp_password}"
  $_duplex                      = "set #attribute/duplex ${duplex}"
  $_descrease_consumer_priority = "set #attribute/decreaseNetworkConsumerPriority ${decrease_network_consumer_priority}"
  $_network_ttl                 = "set #attribute/networkTTL ${network_ttl}"
  $_dynamic_only                = "set #attribute/dynamicOnly ${dynamic_only}"
  $_conduit_subscriptions       = "set #attribute/conduitSubscriptions ${conduit_subscriptions}"
  $_default_excluded_collectives =  $connector_name ? {
    /queue/ => 'set excludedDestinations/topic/#attribute/physicalName >',
    /topic/ => 'set excludedDestinations/queue/#attribute/physicalName >',
    default => ''
  }

  # Because we are now using selectors, if the user changes the collectives to include/exclude,
  # the list will not be overwritten. To work around this, tell augeas to remove all elements
  # in the element and rebuild it. Augeas is smart enough to not create a change event
  # if the end result of removing and adding elements back in result in the already
  # existing file.
  $_excluded_collective_topics_clear = 'rm excludedDestinations/topic'
  $_excluded_collective_queues_clear = 'rm excludedDestinations/queue'
  $_included_collective_topics_clear = 'rm dynamicallyIncludedDestinations/topic'
  $_included_collective_queues_clear = 'rm dynamicallyIncludedDestinations/queue'

  if ! pe_empty($excluded_collectives) {
    # To work around a bug in puppetdb exported resources where it will return a string or array based on the
    # number of elements in an array, always cast excluded collectives to an array.
    $_excluded_collectives = pe_flatten([$excluded_collectives])

    $_excluded_collectives_values = pe_suffix($_excluded_collectives, '.>')
    $_excluded_selectors = pe_prefix($_excluded_collectives_values, '#attribute/physicalName=')
    $_excluded_collective_topics = pe_create_amq_augeas_command(
      'excludedDestinations/topic',
      $_excluded_selectors,
      'physicalName',
      $_excluded_collectives_values
    )
    $_excluded_collective_queues = pe_create_amq_augeas_command(
      'excludedDestinations/queue',
      $_excluded_selectors,
      'physicalName',
      $_excluded_collectives_values
    )
  } else {
    $_excluded_collectives = undef
    $_excluded_collective_topics = undef
    $_excluded_collective_queues = undef
  }

  if ! pe_empty($included_collectives) {
    # To work around a bug in puppetdb exported resources where it will return a string or array based on the
    # number of elements in an array, always cast excluded collectives to an array.
    $_included_collectives = pe_flatten([$included_collectives])

    $_included_collectives_values = pe_suffix($_included_collectives, '.>')
    $_included_selectors = pe_prefix($_included_collectives_values, '#attribute/physicalName=')
    $_included_collective_topics = pe_create_amq_augeas_command(
      'dynamicallyIncludedDestinations/topic',
      $_included_selectors,
      'physicalName',
      $_included_collectives_values
    )
    $_included_collective_queues = pe_create_amq_augeas_command(
      'dynamicallyIncludedDestinations/queue',
      $_included_selectors,
      'physicalName',
      $_included_collectives_values
    )
  } else {
    $_included_collectives = undef
    $_included_collective_topics = undef
    $_included_collective_queues = undef
  }

  if ! pe_empty($additional_attributes) {
    $_additional_attributes = pe_prefix(pe_join_keys_to_values($additional_attributes, ' '), 'set #attribute/')
  } else {
    $_additional_attributes = undef
  }

  $changes = pe_delete_undef_values(pe_flatten([
    $_connector_name,
    $_uri,
    $_username,
    $_password,
    $_duplex,
    $_descrease_consumer_priority,
    $_network_ttl,
    $_dynamic_only,
    $_conduit_subscriptions,
    $_additional_attributes,
    $_excluded_collective_topics_clear,
    $_excluded_collective_queues_clear,
    $_included_collective_topics_clear,
    $_included_collective_queues_clear,
    $_default_excluded_collectives,
    $_excluded_collective_topics,
    $_excluded_collective_queues,
    $_included_collective_topics,
    $_included_collective_queues,
  ]
  ))

  augeas { "${brokername}: AMQ network connector: ${connector_name}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $network_connector_context,
    changes => $changes,
    notify  => Service['pe-activemq'],
  }
}
