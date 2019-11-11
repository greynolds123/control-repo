# Custom define to either enabling or disabling the built in AMQ console.
#
# Configuration for the console is not exposed or managed by this module.
# The configuration for the console is layed down by the packaging and sits
# next to the activemq.xml file.
#
# @param console_config_file [String] The file with additional jetty configuration.
# @param console_ensure [String] Whether or not this entry should be present in the config. Valid values
#   are one of: present, absent, true, false.
define puppet_enterprise::amq::config::web_console(
  $console_config_file   = 'jetty.xml',
  $console_ensure        = 'present',
){

  pe_validate_re($console_ensure, '^(present|absent|true|false)$')

  $console_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/import[#attribute/resource='${console_config_file}']"

  if $console_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${console_context}"
  } else {
    $changes = "set #attribute/resource '${console_config_file}'"
  }

  augeas { "AMQ webConsole: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $console_context,
    changes => $changes,
    notify  => Service['pe-activemq'],
  }
}

