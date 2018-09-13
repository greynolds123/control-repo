# Profile for setting up an ActiveMQ broker.
#
# The profile implements a handful of defined types to configure AMQ and exports a pair of
# puppet_enterprise::amq::config::network_connector's for collection by the
# puppet_enterprise::profile::amq::hub profile.
#
# For more information, see the [README.md](./README.md#broker)
#
# @param brokername [String] Sets the name of this broker; which must be unique in the network
# @param decrease_network_consumer_priority [Boolean] If true, decrease the priority for dispatching to
#         a network Queue consumer the further away it is (in network hops) from the producer. When false all
#         network consumers use same default priority(0) as local consumers.
# @param duplex [Boolean] If true, a network connection will be used to both produce AND Consume
#         messages. This has proven to be problematic if a broker is restarted. Recommended to leave
#         this setting set to false.
# @param dynamic_only [Boolean] If true, only activate a networked durable subscription when a
#         corresponding durable subscription reactivates, by default they are activated on startup.
# @param excluded_collectives [Array] List of brokers that this broker should not talk to.
# @param heap_mb [Integer] Sets the Xms and Xmx java properties on ActiveMQ.
# @param included_collectives [Array] List of brokers that this broker should talk to.
# @param keystore_password [String] The password for the Java keystore used by ActiveMQ's SSLContext.
# @param truststore_password [String] The password for the Java truststore used by ActiveMQ's SSLContext.
# @param network_ttl [Integer] The number of brokers in the network that messages and subscriptions can
#         pass through
# @param openwire_protocol [String] The type of connection that brokers will use to communicate with
#         each other. There is currently a bug in the version of ActiveMQ we ship that prevents us from
#         enabling ssl+nio due to us removing SSLv3.
# @param openwire_transport_options [Hash] List of transport options to be appended to the connection
#         string. This list is NOT additive and will overwrite PE's defaults which will renable SSLv3.
# @param queue_conduit_subscriptions [Boolean] Whether or not to enable conduit subscriptions for queues.
# @param stomp_protocol [String] The type of connection that clients (MCollective) will be using to
#         talk with the broker.
# @param stomp_transport_options [Hash] List of transport options to be appended to the connection
#         string. This list is NOT additive and will overwrite PE's defaults which will renable SSLv3.
# @param stomp_port [Integer] Port to listen on for client messages. It is not recommended to alter the
#         parameter on this profile, but instead of the puppet_enterprise class. Otherwise you will
#         also need to update the mcollective profile to reflect the port change.
# @param stomp_user [String] The username for sending messages over the stomp protocol.
# @param stomp_passowrd [String] The stomp password.
# @param topic_conduit_subscriptions [Boolean] Whether or not to enable conduit subscriptions for topics.
# @param enable_web_console [Boolean] If true, will enable ActiveMQ's web console. Additional manual
#         configuration may be requried in the jetty.xml file, located next to activemq.xml.
# @param memory_usage [String] The max amount of memory the broker can use for storing messages before
#         storing messages on disk. Values of the form "20 mb", "1024kb", and "1g" can be used.
# @param store_usage [String] The amount of disk space usable for storing persistent messages. Values
#         of the form "20 mb", "1024kb", and "1g" can be used.
# @param temp_usage [String] The amount of disk space usable for storing non-persistent messages.
#         Values of the form "20 mb", "1024kb", and "1g" can be used.
# @param network_connector_tag [String] The tag name that the network connectors for this broker
#         will be exported as.
# @param activemq_hubname [String] The resolvable name of the activemq hub when this broker is
#         part of a hub and spoke configuration.
# @param use_dedicated_task_runner [Boolean] Whether or not to enable the dedicated task runner.
#         For increased performance, recommended that this is left as false.
class puppet_enterprise::profile::amq::broker (
  $brokername                             = $puppet_enterprise::params::activemq_brokername,
  $decrease_network_consumer_priority     = true,
  $duplex                                 = false,
  $dynamic_only                           = true,
  $excluded_collectives                   = [],
  $heap_mb                                = $puppet_enterprise::params::activemq_heap_mb,
  $included_collectives                   = [],
  $keystore_password                      = $puppet_enterprise::params::activemq_java_ks_password,
  $truststore_password                    = $puppet_enterprise::params::activemq_java_ts_password,
  $network_ttl                            = $puppet_enterprise::params::activemq_network_ttl,
  $openwire_protocol                      = $puppet_enterprise::params::openwire_protocol,
  Integer $openwire_port                  = $puppet_enterprise::params::openwire_port,
  $openwire_transport_options             = $puppet_enterprise::params::activemq_transport_options,
  $queue_conduit_subscriptions            = false,
  $stomp_protocol                         = $puppet_enterprise::params::stomp_protocol,
  $stomp_transport_options                = $puppet_enterprise::params::activemq_transport_options,
  $stomp_port                             = $puppet_enterprise::mcollective_middleware_port,
  $stomp_user                             = $puppet_enterprise::mcollective_middleware_user,
  $stomp_password                         = $puppet_enterprise::mcollective_middleware_password,
  $topic_conduit_subscriptions            = true,
  $enable_web_console                     = false,
  $memory_usage                           = '200mb',
  $store_usage                            = '1gb',
  $temp_usage                             = '1gb',
  Optional[String] $network_connector_tag = undef,
  Optional[String] $activemq_hubname      = pe_servername(),
  $use_dedicated_task_runner              = false,
) inherits puppet_enterprise {

  pe_validate_bool($use_dedicated_task_runner)

  class { 'puppet_enterprise::amq':
    brokername => $brokername,
  }

  # Template uses:
  # - $puppetversion (fact)
  # - $heap_mb
  # - use_dedicated_task_runner
  file { "${puppet_enterprise::params::defaults_dir}/pe-activemq":
    ensure  => file,
    content => template('puppet_enterprise/amq/activemq.defaults.erb'),
    owner   => $puppet_enterprise::params::root_user,
    group   => $puppet_enterprise::params::root_group,
    mode    => '0755',
    notify  => Service['pe-activemq'],
  }

  # The pe-activemq package lays down a broker named 'localhost' which
  # we do not want to exist. Remove it
  puppet_enterprise::amq::config::broker { 'remove default localhost':
    brokername    => 'localhost',
    broker_ensure => 'absent',
  }

  puppet_enterprise::amq::config::broker { $brokername:
    brokername => $brokername,
  }

  class { 'puppet_enterprise::amq::certs':
    brokername          => $brokername,
    keystore_password   => $keystore_password,
    truststore_password => $truststore_password,
  }

  puppet_enterprise::amq::config::ssl_context { "${brokername}-ssl-context":
    brokername          => $brokername,
    keystore_password   => $keystore_password,
    truststore_password => $truststore_password,
  }

  # If this broker is part of a hub and spoke network of brokers, a network connector will need to be
  # established to talk to the hub. This was not needed before due to the use of duplex connectors,
  # however due to the numerous connection issues we have found when using duplex connectors, the
  # connections are now simplex, meaning both broker and hub will need a connection to communicate.
  if $activemq_hubname and !pe_empty($activemq_hubname) and $activemq_hubname != $brokername {
    puppet_enterprise::amq::config::network_connector { "${brokername} to ${activemq_hubname}-topic":
      brokername                         => $activemq_hubname,
      connector_name                     => "${activemq_hubname}-topic",
      conduit_subscriptions              => $topic_conduit_subscriptions,
      decrease_network_consumer_priority => $decrease_network_consumer_priority,
      duplex                             => $duplex,
      dynamic_only                       => $dynamic_only,
      excluded_collectives               => $excluded_collectives,
      included_collectives               => $included_collectives,
      network_ttl                        => $network_ttl,
      openwire_protocol                  => $openwire_protocol,
      openwire_port                      => $openwire_port,
      stomp_password                     => $stomp_password,
      stomp_user                         => $stomp_user,
    }

    puppet_enterprise::amq::config::network_connector { "${brokername} to ${activemq_hubname}-queue":
      brokername                         => $activemq_hubname,
      connector_name                     => "${activemq_hubname}-queue",
      conduit_subscriptions              => $queue_conduit_subscriptions,
      decrease_network_consumer_priority => $decrease_network_consumer_priority,
      duplex                             => $duplex,
      dynamic_only                       => $dynamic_only,
      excluded_collectives               => $excluded_collectives,
      included_collectives               => $included_collectives,
      network_ttl                        => $network_ttl,
      openwire_protocol                  => $openwire_protocol,
      openwire_port                      => $openwire_port,
      stomp_password                     => $stomp_password,
      stomp_user                         => $stomp_user,
    }
  }

  if !pe_empty($activemq_hubname) and pe_empty($network_connector_tag) {
    $_network_connector_tag = "pe-amq-network-connectors-for-${activemq_hubname}"
  }
  elsif pe_empty($network_connector_tag) {
    $_network_connector_tag = "pe-amq-network-connectors"
  }
  else {
    $_network_connector_tag = $network_connector_tag
  }

  @@puppet_enterprise::amq::config::network_connector { "export: ${brokername}-topic":
    brokername                         => $brokername,
    connector_name                     => "${brokername}-topic",
    conduit_subscriptions              => $topic_conduit_subscriptions,
    decrease_network_consumer_priority => $decrease_network_consumer_priority,
    duplex                             => $duplex,
    dynamic_only                       => $dynamic_only,
    excluded_collectives               => $excluded_collectives,
    included_collectives               => $included_collectives,
    network_ttl                        => $network_ttl,
    openwire_protocol                  => $openwire_protocol,
    openwire_port                      => $openwire_port,
    stomp_password                     => $stomp_password,
    stomp_user                         => $stomp_user,
    tag                                => $_network_connector_tag,
  }

  @@puppet_enterprise::amq::config::network_connector { "export: ${brokername}-queue":
    brokername                         => $brokername,
    connector_name                     => "${brokername}-queue",
    conduit_subscriptions              => $queue_conduit_subscriptions,
    decrease_network_consumer_priority => $decrease_network_consumer_priority,
    duplex                             => $duplex,
    dynamic_only                       => $dynamic_only,
    excluded_collectives               => $excluded_collectives,
    included_collectives               => $included_collectives,
    network_ttl                        => $network_ttl,
    openwire_protocol                  => $openwire_protocol,
    openwire_port                      => $openwire_port,
    stomp_password                     => $stomp_password,
    stomp_user                         => $stomp_user,
    tag                                => $_network_connector_tag,
  }

  puppet_enterprise::amq::config::management_context { "${brokername} - managementContext":
    brokername => $brokername,
  }

  puppet_enterprise::amq::config::destination_policy_entry { "${brokername}-topic->":
    brokername                   => $brokername,
    destination_type             => 'topic',
    target_destination           => '>',
    enable_producer_flow_control => false,
    memory_limit                 => '5mb'
  }

  puppet_enterprise::amq::config::destination_policy_entry { "${brokername}-queue->":
    brokername                   => $brokername,
    destination_type             => 'queue',
    target_destination           => '>',
    enable_producer_flow_control => false,
    memory_limit                 => '20mb'
  }

  puppet_enterprise::amq::config::destination_policy_entry { "${brokername}-queue-*.reply.>":
    brokername                      => $brokername,
    destination_type                => 'queue',
    target_destination              => '*.reply.>',
    enable_gc_inactive_destinations => true,
    inactive_timout_before_gc       => 300000,
  }

  puppet_enterprise::amq::config::transport_connector { "${brokername}-openwire-transport":
    brokername     => $brokername,
    transport_name => 'openwire',
    transport_uri  => "${openwire_protocol}://0.0.0.0:61616",
    transport_options => $openwire_transport_options,
  }

  puppet_enterprise::amq::config::transport_connector { "${brokername}-stomp-transport":
    brokername        => $brokername,
    transport_name    => 'stomp+ssl',
    transport_uri     => "${stomp_protocol}://0.0.0.0:${stomp_port}",
    transport_options => $stomp_transport_options,
  }

  puppet_enterprise::amq::config::statistics_broker_plugin { "${brokername}-statisticsBrokerPlugin":
    brokername => $brokername
  }

  puppet_enterprise::amq::config::timestamping_broker_plugin { "${brokername}-timeStampingBrokerPlugin":
    brokername               => $brokername,
    zero_expiration_override => 30000,
  }

  puppet_enterprise::amq::config::simple_authentication_user { "${brokername}-simple_auth_user-mcollective":
    brokername => $brokername,
    groups     => 'mcollective,admins,everyone',
    password   => $stomp_password,
    username   => 'mcollective',
  }

  puppet_enterprise::amq::config::authorization_plugin_entry { "${brokername}-authorization-queue->":
    brokername         => $brokername,
    destination_type   => 'queue',
    target_destination => '>',
    write              => 'admins',
    read               => 'admins',
    admin              => 'admins',
  }

  puppet_enterprise::amq::config::authorization_plugin_entry { "${brokername}-authorization-topic->":
    brokername         => $brokername,
    destination_type   => 'topic',
    target_destination => '>',
    write              => 'admins',
    read               => 'admins',
    admin              => 'admins',
  }

  puppet_enterprise::amq::config::authorization_plugin_entry { "${brokername}-authorization-queue-mcollective.>":
    brokername         => $brokername,
    destination_type   => 'queue',
    target_destination => 'mcollective.>',
    write              => 'mcollective',
    read               => 'mcollective',
    admin              => 'mcollective',
  }

  puppet_enterprise::amq::config::authorization_plugin_entry { "${brokername}-authorization-topic-mcollective.>":
    brokername         => $brokername,
    destination_type   => 'topic',
    target_destination => 'mcollective.>',
    write              => 'mcollective',
    read               => 'mcollective',
    admin              => 'mcollective',
  }

  puppet_enterprise::amq::config::authorization_plugin_entry { "${brokername}-authorization-topic-ActiveMQ.Advisory.>":
    brokername         => $brokername,
    destination_type   => 'topic',
    target_destination => 'ActiveMQ.Advisory.>',
    write              => 'everyone',
    read               => 'everyone',
    admin              => 'everyone',
  }

  puppet_enterprise::amq::config::web_console { "${brokername} - web console - ${enable_web_console}":
    console_ensure  => pe_bool2str($enable_web_console),
  }

  puppet_enterprise::amq::config::system_usage { "${brokername} - systemusage":
    brokername   => $brokername,
    memory_usage => $memory_usage,
    store_usage  => $store_usage,
    temp_usage   => $temp_usage,
  }
}
