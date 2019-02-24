# Custom define for setting up a statistics broker.
#
# Can be used to retrieve statistics from the broker or its destinations.
#
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param entry_ensure [String] Whether or not this entry should be present in the config. Valid values
#   are one of: present, absent, true, false.
define puppet_enterprise::amq::config::statistics_broker_plugin(
  $brokername    = $::clientcert,
  $plugin_ensure = 'present',
){
  pe_validate_re($plugin_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $plugin_context = "${broker_context}/plugins/statisticsBrokerPlugin"

  if $plugin_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${plugin_context}"
  } else {
    $changes = "set ${plugin_context} ''"
  }

  augeas { "${brokername}: AMQ statisticsBrokerPlugin: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $plugin_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}
