# A Broker plugin which updates a JMS Client's timestamp on the message
# with a broker timestamp. Useful when the clocks on client machines are known to
# not be correct and you can only trust the time set on the broker machines.
#
# Enabling this plugin will break JMS compliance since the timestamp that the
# producer sees on the messages after as send() will be different from the
# timestamp the consumer will observe when he receives the message.
#
# This plugin is not enabled in the default ActiveMQ configuration.
#
#
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param future_only [Boolean] If set to true will never set the message time stamp and expiration time to
#   a lower value than the original values. If set to false, they will always be updated.
# @param plugin_ensure [String] Whether to ensure that this plugin is present in the given brokers `plugin`
#   section. Valid values are one of: preset, absent, true, false.
# @param ttl_ceiling [Integer] Can be used to apply a limit to the expiration time. Defaults to 0.
# @param zero_expiration_override [Integer] Can be used to apply an expiration time to incoming
#   messages with no expiration defined (messages that would never expire).
define puppet_enterprise::amq::config::timestamping_broker_plugin(
  $brokername               = $::clientcert,
  $future_only              = false,
  $plugin_ensure            = 'present',
  $ttl_ceiling              = 0,
  $zero_expiration_override = 0,
){
  pe_validate_bool($future_only)
  pe_validate_re($plugin_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $plugin_context = "${broker_context}/plugins/timeStampingBrokerPlugin"

  if $plugin_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${plugin_context}"
  } else {
    $_future_only              = "set #attribute/futureOnly '${future_only}'"
    $_ttl_ceiling              = "set #attribute/ttlCeiling '${ttl_ceiling}'"
    $_zero_expiration_override = "set #attribute/zeroExpirationOverride '${zero_expiration_override}'"

    $changes = [
      $_future_only,
      $_ttl_ceiling,
      $_zero_expiration_override,
    ]
  }

  augeas { "${brokername}: AMQ timeStampingBrokerPlugin: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $plugin_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}
