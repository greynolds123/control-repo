# Custom define for creating the `beans` elements of an
# `ActiveMQ.xml` file. Takes care of ensuring all the necessary attributes
# are set on the `<beans>` element and it's child `<bean>` element.
#
# The main purpose of this defined type is in the event that the
# `activemq.xml` file becomes corrupt, the file can be blown away and regenerated.
define puppet_enterprise::amq::config::beans {
  $xsi_location = 'http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-2.0.xsd
    http://activemq.apache.org/schema/core
    http://activemq.apache.org/schema/core/activemq-core.xsd
    http://activemq.apache.org/camel/schema/spring
    http://activemq.apache.org/camel/schema/spring/camel-spring.xsd'
  $bean_class = 'org.springframework.beans.factory.config.PropertyPlaceholderConfigurer'

  augeas { 'amq_augeas_base_beans_config':
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    changes => [
      "set #comment '\n    Centrally managed by Puppet version ${::puppetversion}\n    For details on this file, visit https://docs.puppetlabs.com/mcollective/deploy/middleware/activemq.html\n'",
      "set beans/#attribute/xmlns 'http://www.springframework.org/schema/beans'",
      "set beans/#attribute/xmlns:amq 'http://activemq.apache.org/schema/core'",
      "set beans/#attribute/xmlns:xsi 'http://www.w3.org/2001/XMLSchema-instance'",
      "set beans/#attribute/xsi:schemaLocation '${xsi_location}'",
      "set beans/bean[#attribute/class='${bean_class}']/#attribute/class '${bean_class}'",
      "set beans/bean[#attribute/class='${bean_class}']/property/#attribute/name 'locations'",
      "set beans/bean[#attribute/class='${bean_class}']/property/#attribute/name 'locations'",
      "set beans/bean[#attribute/class='${bean_class}']/property[#attribute/name='locations']/value/#text 'file:\${activemq.base}/conf/credentials.properties'",
    ],
    require => File['/etc/puppetlabs/activemq/activemq.xml'],
    notify  => Service['pe-activemq'],
  }
}
