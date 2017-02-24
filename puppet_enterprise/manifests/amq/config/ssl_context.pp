# Custom define for creating and managing the `<ssl_context>`
# element for a given broker.
# The SslContext is used to configure the SslTransportFactory of a given broker.
#
# @param additional_attributes [Hash] A hash of user specified attributes to add to the ssl_context.
# @param brokername [String] The name of the ActiveMQ broker whose configuration this entry belongs to.
# @param entry_ensure [String] Whether or not this entry should be present in the config. Valid values
#   are one of: present, absent, true, false.
# @param keystore_password [String] The password for the Java keystore used by ActiveMQ's SSLContext.
# @param keystore_path [String] The path to the keystore on disk.
# @param truststore_password [String] The password for the Java truststore used by ActiveMQ's SSLContext.
# @param truststore_path [String] The path to the truststore on disk.
define puppet_enterprise::amq::config::ssl_context(
  $additional_attributes = {},
  $brokername            = $::clientcert,
  $context_ensure        = 'present',
  $keystore_password     = $puppet_enterprise::params::activemq_java_ks_password,
  $keystore_path         = 'file:${activemq.base}/conf/broker.ks',
  $truststore_password   = $puppet_enterprise::params::activemq_java_ts_password,
  $truststore_path       = 'file:${activemq.base}/conf/broker.ts',
){

  pe_validate_hash($additional_attributes)
  pe_validate_re($context_ensure, '^(present|absent|true|false)$')

  $broker_context = "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='${brokername}']"
  $ssl_context = "${broker_context}/sslContext/sslContext"

  if $context_ensure =~ /^(absent|false)$/ {
    $changes = "rm ${ssl_context}"
  } else {
    $_keystore_password   = "set #attribute/keyStorePassword '${keystore_password}'"
    $_keystore_path       = "set #attribute/keyStore '${keystore_path}'"
    $_truststore_password = "set #attribute/trustStorePassword '${truststore_password}'"
    $_truststore_path     = "set #attribute/trustStore '${truststore_path}'"

    if ! pe_empty($additional_attributes) {
      $_additional_attributes = pe_prefix(pe_join_keys_to_values($additional_attributes, ' '), 'set #attribute/')
    } else {
      $_additional_attributes = undef
    }

    $changes = pe_delete_undef_values(pe_flatten([
      $_keystore_password,
      $_keystore_path,
      $_truststore_password,
      $_truststore_path,
      $_additional_attributes,
    ]))
  }

  augeas { "${brokername}: AMQ sslContext: ${title}":
    incl    => '/etc/puppetlabs/activemq/activemq.xml',
    lens    => 'ActiveMQ_XML.lns',
    context => $ssl_context,
    changes => $changes,
    require => Puppet_enterprise::Amq::Config::Broker[$brokername],
    notify  => Service['pe-activemq'],
  }
}
