# Custom define for creating and managing an `authenticationUser` for the `simpleAuthenticationPlugin`.
#
# If you have modest authentication requirements (or just want to quickly set up your testing environment)
# you can use SimpleAuthenticationPlugin. With this plugin you can define users and groups directly in the
# broker's XML configuration.
#
# @param groups [String] A comma seperated list of groups that the user should be a member of.
# @param password [String] Password for the user.
# @param username [String] The username for the user to be added.
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param user_ensure [String] Whether to ensure that this user entry should be present in the config.
#   Valid values are one of: preset, absent, true, false.
define puppet_enterprise::amq::config::simple_authentication_user(
  $groups,
  $password,
  $username,
  $brokername  = $::clientcert,
  $user_ensure = 'present',
){
  pe_validate_re($user_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $plugin_context = "${broker_context}/plugins/simpleAuthenticationPlugin"
  $user_context  = "${plugin_context}/users/authenticationUser[#attribute/username='${username}']"

  if $user_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${user_context}"
  } else {
    $_groups   = "set #attribute/groups '${groups}'"
    $_password = "set #attribute/password '${password}'"
    $_username = "set #attribute/username '${username}'"

    $changes = [
      $_username,
      $_password,
      $_groups,
    ]
  }

  augeas { "${brokername}: AMQ simpleAuthentication user: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $user_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}
