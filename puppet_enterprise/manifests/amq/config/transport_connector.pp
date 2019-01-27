# Custom define for creating and managing a `transportConnector` for a broker
#
# Transport connectors are for configuring clients (such as MCollective) to talk with the broker.
#
# More information can be found at http://activemq.apache.org/configuring-version-5-transports.html
#
# @param transport_name [String] A unique name for the transport connector.
# @param transport_uri [String] The protocol + ip address to connect to.
# @param transport_options [Hash] A hash of additional uri parameters. Can be used to specify things
#   like what ssl protocols to use and other features.
# @param additional_attributes [Hash] A hash of user specified attributes to add to the policy element.
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param connector_ensure [String] Whether or not this entry should be present in the config. Valid values
#   are one of: present, absent, true, false.
define puppet_enterprise::amq::config::transport_connector(
  $transport_name,
  $transport_uri,
  $transport_options     = {},
  $additional_attributes = {},
  $brokername            = $::clientcert,
  $connector_ensure      = 'present',
) {
  pe_validate_hash($additional_attributes)
  pe_validate_re($connector_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $connector_context = "${broker_context}/transportConnectors/transportConnector[#attribute/name='${transport_name}']"

  if $connector_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${connector_context}"
  } else {

    if ! pe_empty($transport_options) {
      # the ampersand is encoded as an Augeas work around
      $opt_string = pe_join(pe_join_keys_to_values($transport_options, '='), '&amp;')
      $opts = "?${opt_string}"
    } else {
      $opts = undef
    }

    $_transport_name = "set #attribute/name '${transport_name}'"
    $_transport_uri  = "set #attribute/uri '${transport_uri}${opts}'"

    if ! pe_empty($additional_attributes) {
      $_additional_attributes = pe_prefix(pe_join_keys_to_values($additional_attributes, ' '), 'set #attribute/')
    } else {
      $_additional_attributes = undef
    }

    $changes = pe_delete_undef_values(pe_flatten([
      $_transport_name,
      $_transport_uri,
      $_additional_attributes,
    ]))
  }

  augeas { "${brokername}: AMQ transportConnector: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $connector_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}
