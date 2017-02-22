# Custom define for creating and managing the `<destination_policy_entry>`
# element for a given broker.
#
# Because there are numerous attributes available for the `<broker>` element,
# only a handful are exposed.
#
# For a full list of available attributes, see
# http://activemq.apache.org/schema/core/activemq-core-5.9.0-schema.html#policyEntry
#
# To use an attribute not explicitly exposed here, you can pass them in hash form to
# `$additional_attributes`.
#
# yes, timeout is missing the `e`...that is the actual attribute name.
# http://activemq.apache.org/schema/core/activemq-core-5.9.0-schema.html#policyEntry
#
# @param destination_type [String] One of the following: topic, queue, tempQueue or tempTopic.
# @param target_destination [String] One of the following: topic, queue, tempQueue or tempTopic.
# @param additional_attributes [Hash] A hash of user specified attributes to add to the policy element.
# @param additional_policies [Hash] A hash of additional policy's to apply.
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param enable_gc_inactive_destinations [Boolean] whether or not to delete inactive destinations.
# @param enable_producer_flow_control [Boolean] The producer will slow down and eventually block if no
#   resources(e.g. memory) are available on the broker. If this is off messages get off-lined to disk to
#   prevent memory exhaustion.
# @param entry_ensure [String] Whether or not this entry should be present in the config. Valid values
#   are one of: present, absent, true, false.
# @param inactive_timout_before_gc [Integer] Inactivity period (in ms) before destination is considered
#   inactive.
# @param memory_limit [String] The memory limit for a given destination. This acts as a child to the
#   overall broker memory specified by the <systemUsage>'s memoryLimit attribute. There is no default for
#   this value; it simply acts as a child to the overall broker memory until the broker memory is
#   exhausted.
define puppet_enterprise::amq::config::destination_policy_entry(
  Pattern[/^(topic|queue|tempTopic|tempQueue)$/] $destination_type,
  $target_destination,
  Hash $additional_attributes                              = {},
  Hash $additional_policies                                = {},
  $brokername                                              = $::clientcert,
  $enable_gc_inactive_destinations                         = false,
  $enable_producer_flow_control                            = true,
  Pattern[/^(present|absent|true|false)$/] $entry_ensure   = 'present',
  Optional[Integer] $inactive_timout_before_gc             = undef,
  Optional[Pattern[/^[0-9]*\s?(kb|mb|gb)$/]] $memory_limit = undef,
){

  pe_validate_bool($enable_producer_flow_control, $enable_gc_inactive_destinations)
  pe_validate_hash($additional_attributes, $additional_policies)

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $entry_context = "${broker_context}/destinationPolicy/policyMap/policyEntries/policyEntry[#attribute/${destination_type}='${target_destination}']"

  if $entry_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${entry_context}"
  } else {
    $_target_destination       = "set #attribute/${destination_type} '${target_destination}'"
    $_producer_flow_control    = "set #attribute/producerFlowControl '${enable_producer_flow_control}'"
    $_gc_inactive_destinations = "set #attribute/gcInactiveDestinations '${enable_gc_inactive_destinations}'"

    if $inactive_timout_before_gc {
      $_inactive_timout = "set #attribute/inactiveTimoutBeforeGC '${inactive_timout_before_gc}'"
    } else {
      $_inactive_timout = undef
    }

    if $memory_limit {
      $_memory_limit = "set #attribute/memoryLimit '${memory_limit}'"
    } else {
      $_memory_limit = undef
    }

    if ! pe_empty($additional_attributes) {
      $_additional_attributes = pe_prefix(pe_join_keys_to_values($additional_attributes, ' '), 'set #attribute/')
    } else {
      $_additional_attributes = undef
    }

    if ! pe_empty($additional_policies) {
      $_additional_policies = pe_prefix(pe_join_keys_to_values($additional_policies, ' '), 'set ')
    } else {
      $_additional_policies = undef
    }

    $changes = pe_delete_undef_values(pe_flatten([
      $_target_destination,
      $_producer_flow_control,
      $_gc_inactive_destinations,
      $_inactive_timout,
      $_memory_limit,
      $_additional_attributes,
      $_additional_policies
    ]
    ))
  }

  augeas { "${brokername}: AMQ destinationPolicyEntry: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $entry_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}
