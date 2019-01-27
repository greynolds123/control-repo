# Custom define for creating and managing an `authorization entry` for the
# `authorizationPlugin`.
#
# In ActiveMQ we use a number of operations which you can associate with user
# roles and either individual queues or topics or you can use wildcards to
# attach to hierarchies of topics and queues.
#
# @param admin [String] A comma-separated list of roles that have permission to create
#         destinations in the destination subtree.
# @param destination_type [String] One of the following: topic, queue, tempQueue or tempTopic.
# @param read [String] A comma-separated list of roles that have permission to consume messages from
#         the matching destinations.
# @param target_destination [String] The topic or queues destination. can either be individual
#         queues or topics, or you can use wildcards.
# @param write [String] A comma-separated list of roles that have permission to publish messages to the
#         matching destinations.
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param entry_ensure [String] Whether to ensure that this entry is present in the `authorizationPlugin`
#         or absent. Valid values are one of: preset, absent, true, false.
define puppet_enterprise::amq::config::authorization_plugin_entry(
  $admin,
  $destination_type,
  $read,
  $target_destination,
  $write,
  $brokername   = $::clientcert,
  $entry_ensure = 'present',
){
  pe_validate_re($destination_type, '^(topic|queue|tempTopic|tempQueue)$')
  pe_validate_re($entry_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $plugin_context = "${broker_context}/plugins/authorizationPlugin"
  $entry_context  = "${plugin_context}/map/authorizationMap/authorizationEntries/authorizationEntry[#attribute/${destination_type}='${target_destination}']"

  if $entry_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${entry_context}"
  } else {
    $_target_destination = "set #attribute/${destination_type} '${target_destination}'"
    $_admin              = "set #attribute/admin '${admin}'"
    $_read               = "set #attribute/read '${read}'"
    $_write              = "set #attribute/write '${write}'"

    $changes = pe_delete_undef_values(pe_flatten([
      $_target_destination,
      $_admin,
      $_read,
      $_write,
    ]))
  }

  augeas { "${brokername}: AMQ authorizationPlugin entry: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $entry_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}
