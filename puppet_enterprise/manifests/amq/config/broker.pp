# Custom define for creating and managing the `<broker>`
# element for a given broker.
#
# Because there are numerous attributes available for the `<broker>` element,
# only a handful are exposed.
#
# For a full list of available attributes, see
# http://activemq.apache.org/schema/core/activemq-core-5.9.0-schema.html#broker
#
# To use an attribute not explicitly exposed here, you can pass them in hash form to
# `$additional_attributes`.
#
# @param additional_attributes [Hash] A hash of user specified attributes to add to the broker element.
# @param broker_ensure [String] Whether to ensure that this broker is present in the config file. Valid values
#         are one of: preset, absent, true, false
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param data_directory [String] Sets the directory in which the data files will be stored by default
#         for the JDBC and Journal persistence adaptors.
# @param persistent [Boolean] Sets whether or not messages are saved to disk.
# @param use_jmx [Boolean] Sets whether or not the Broker's services should be exposed into JMX or not.
define puppet_enterprise::amq::config::broker(
  $additional_attributes = {},
  $broker_ensure         = 'present',
  $brokername            = $::clientcert,
  $data_directory        = '${activemq.base}/data',
  $persistent            = false,
  $use_jmx               = true,
){

  pe_validate_hash($additional_attributes)
  pe_validate_bool($use_jmx, $persistent)
  pe_validate_re($broker_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"

  if $broker_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${broker_context}"
  } else {
    $_brokername     = "set #attribute/brokerName '${brokername}'"
    $_xmlns          = "set #attribute/xmlns 'http://activemq.apache.org/schema/core'"
    $_data_directory = "set #attribute/dataDirectory '${data_directory}'"
    $_persistent     = "set #attribute/persistent '${persistent}'"
    $_use_jmx        = "set #attribute/useJmx '${use_jmx}'"

    if ! pe_empty($additional_attributes) {
      $_additional_attributes = pe_prefix(pe_join_keys_to_values($additional_attributes, ' '), 'set #attribute/')
    } else {
      $_additional_attributes = undef
    }

    $changes = pe_delete_undef_values(pe_flatten([
      $_brokername,
      $_xmlns,
      $_data_directory,
      $_persistent,
      $_use_jmx,
      $_additional_attributes,
      ]))
    }

  augeas { "${brokername}: AMQ broker: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $broker_context,
    changes => $changes,
    notify  => Service['pe-activemq'],
  }
}
