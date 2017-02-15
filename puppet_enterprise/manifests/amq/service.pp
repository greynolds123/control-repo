# Class for setting up the activemq service.
#
# Subsribes to any changes in puppet_enterprise::amq::config
class puppet_enterprise::amq::service (
  Enum['stopped', 'running'] $ensure = 'running',
  Boolean                    $enable = true,
  ){
  service { 'pe-activemq':
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    subscribe  => Class['puppet_enterprise::amq::config'],
  }
}
