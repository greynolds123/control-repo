# Custom define for creating and managing the `<management_context>`
# element for a given broker.
#
# The managementContext is used to configure how ActiveMQ is exposed in
# JMX. By default, ActiveMQ uses the MBean server that is started by
# the JVM. For more information, see:
#
# http://activemq.apache.org/jmx.html
#
# Because there are numerous attributes available for the `<management_context>` element,
# only a handful are exposed.
#
# For a full list of available attributes, see
# http://activemq.apache.org/schema/core/activemq-core-5.9.0-schema.html#managementContext
#
# To use an attribute not explicitly exposed here, you can pass them in hash form to
# `$additional_attributes`.
#
# @param additional_attributes [Hash] A hash of user specified attributes to add to the broker element.
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param create_connector [Boolean] If we should create a JMX connector (to allow remote management)
#   for the MBeanServer.
# @param context_ensure [String] Whether or not this management_context should be present in the
#   config. Valid values are one of: present, absent, true, false.
define puppet_enterprise::amq::config::management_context(
  $additional_attributes = {},
  $brokername            = $::clientcert,
  $create_connector      = false,
  $context_ensure        = 'present',
){

  pe_validate_bool($create_connector)
  pe_validate_hash($additional_attributes)
  pe_validate_re($context_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $management_context = "${broker_context}/managementContext/managementContext"

  if $context_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${management_context}"
  } else {
    $_create_connector = "set #attribute/createConnector '${create_connector}'"

    if ! pe_empty($additional_attributes) {
      $_additional_attributes = pe_prefix(pe_join_keys_to_values($additional_attributes, ' '), 'set #attribute/')
    } else {
      $_additional_attributes = undef
    }

    $changes = pe_delete_undef_values(pe_flatten([
      $_create_connector,
      $_additional_attributes,
    ]))
  }

  augeas { "${brokername}: AMQ managementContext: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $management_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}
