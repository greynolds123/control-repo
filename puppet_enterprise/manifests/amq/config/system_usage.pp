# Custom define for creating and managing the `<systemUsage>`
# element for a given broker.
#
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param memory_usage [String] The max amount of memory the broker can use for storing messages before
#   storing messages on disk. Values of the form "20 mb", "1024kb", and "1g" can be used.
# @param store_usage [String] The amount of disk space usable for storing persistent messages. Values
#   of the form "20 mb", "1024kb", and "1g" can be used.
# @param temp_usage [String] The amount of disk space usable for storing non-persistent messages.
#   Values of the form "20 mb", "1024kb", and "1g" can be used.
# @param usage_ensure [String] Whether or not this entry should be present in the config. Valid values
#   are one of: present, absent, true, false.
define puppet_enterprise::amq::config::system_usage(
  $brokername   = $::clientcert,
  $memory_usage = "200mb",
  $store_usage  = "1gb",
  $temp_usage   = "1gb",
  $usage_ensure = 'present',
){

  pe_validate_re($memory_usage, '^[0-9]*\s?(kb|mb|gb)$')
  pe_validate_re($store_usage, '^[0-9]*\s?(kb|mb|gb)$')
  pe_validate_re($temp_usage, '^[0-9]*\s?(kb|mb|gb)$')
  pe_validate_re($usage_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $usage_context = "${broker_context}/systemUsage/systemUsage"

  if $usage_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${usage_context}"
  } else {
    $_memory_usage = "set memoryUsage/memoryUsage/#attribute/limit '${memory_usage}'"
    $_store_usage  = "set storeUsage/storeUsage/#attribute/limit '${store_usage}'"
    $_temp_usage   = "set tempUsage/tempUsage/#attribute/limit '${temp_usage}'"

    $changes = [
      $_memory_usage,
      $_store_usage,
      $_temp_usage,
    ]
  }

  augeas { "${brokername}: AMQ systemUsage: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $usage_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}

