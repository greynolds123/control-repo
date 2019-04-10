# Ensures that the base `activemq.xml` file is created.
#
# @param brokername [String] Used for ensuring uniqueness of the amq::config::beans resource.
class puppet_enterprise::amq::config(
  $brokername  = $::clientcert,
) inherits puppet_enterprise::params {

  file { '/etc/puppetlabs/activemq/activemq.xml':
    ensure  => file,
    owner   => $puppet_enterprise::params::root_user,
    group   => 'pe-activemq',
    mode    => '0640',
  }

  puppet_enterprise::amq::config::beans { "${brokername} - beans": }
}
