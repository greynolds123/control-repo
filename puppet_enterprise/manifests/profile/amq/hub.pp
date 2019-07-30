# MCollective and Activemq have been removed in 2019.0
# This is a stub class to warn if the PE Activemq Hub class is still being applied.
class puppet_enterprise::profile::amq::hub (
  $brokername         = undef,
  $heap_mb            = undef,
  $keystore_password     = undef,
  $truststore_password   = undef,
  $network_ttl        = undef,
  $openwire_protocol  = undef,
  Optional[Integer] $openwire_port = undef,
  $stomp_protocol     = undef,
  $stomp_port         = undef,
  $stomp_user         = undef,
  $stomp_password     = undef,
  $enable_web_console  = false,
  Optional[String] $memory_usage = undef,
  $store_usage         = '1gb',
  $temp_usage          = '1gb',
  $network_connector_export_tag = 'pe-amq-network-connectors-hub-mesh',
  $network_connector_spoke_collect_tag = undef,
  $use_dedicated_task_runner = false,
) {
  notify { 'puppet_enterprise::profile::amq::hub-still-applied':
    message  => 'MCollective and Activemq have been removed from PE 2019.0+, but the puppet_enterprise::profile::amq::hub class is still being applied. Please remove this class from your classification.',
    loglevel => 'warning',
  }
}
