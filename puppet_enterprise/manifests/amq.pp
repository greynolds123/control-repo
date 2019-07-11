# This class is responsible for installing and configuring ActiveMQ for use as
# the middleware in MCollective.
#
# By default, the only thing this class will create and manage is the following:
#   - The ActiveMQ package
#   - That `/etc/puppetlabs/activemq/activemq.xml` contains the following:
#     - A valid XML file
#     - the necessary `<beans>` element and it's attributes
#   - restart the service if `activemq.xml` file is modified.
#
# @param brokername [String] Sets the name of this broker; which must be unique in the network
class puppet_enterprise::amq(
  $brokername       = $::clientcert,
) inherits puppet_enterprise::params {

  include puppet_enterprise::packages
  Package <| tag == 'pe-activemq-packages' |>

  class { 'puppet_enterprise::amq::config':
    brokername         => $brokername,
    require            => Package['pe-activemq'],
  }

  class { 'puppet_enterprise::amq::service': }
}
