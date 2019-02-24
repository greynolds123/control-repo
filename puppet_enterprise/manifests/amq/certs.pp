# Responsible for setting up the java keystore and truststore used by ActiveMQ.
# The KS and TS are used for encrypting the connection between brokers.
#
# Since PE has a full CA stack already implemented - we reuse the agent certs for this.
#
# @param brokername [String] Used for ensuring uniqueness of the pe_java_ks resource.
# @param keystore_password [String] The password for the Java keystore used by ActiveMQ's SSLContext.
# @param truststore_password [String] The password for the Java truststore used by ActiveMQ's SSLContext.
class puppet_enterprise::amq::certs(
  $brokername          = $::clientcert,
  $keystore_password   = $puppet_enterprise::params::activemq_java_ks_password,
  $truststore_password = $puppet_enterprise::params::activemq_java_ts_password,
) inherits puppet_enterprise::params {

  # pe_java_ks needs to path to both `openssl` and `keytool`.
  # openssl ships with puppet-agent, while keytool ships with pe-java
  Pe_java_ks {
    path   => [ '/opt/puppetlabs/puppet/bin', '/opt/puppetlabs/server/bin', '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
    notify => Class['puppet_enterprise::amq::service'],
  }

  $java_ks_path = '/etc/puppetlabs/activemq/broker.ks'
  $java_ts_path = '/etc/puppetlabs/activemq/broker.ts'

  pe_java_ks { 'puppetca:truststore':
    ensure       => latest,
    target       => $java_ts_path,
    certificate  => $puppet_enterprise::params::localcacert,
    password     => $truststore_password,
    trustcacerts => true,
    require      => Package['pe-activemq'],
  }

  pe_java_ks { "${brokername}:keystore":
    ensure      => latest,
    target      => $java_ks_path,
    certificate => "${puppet_enterprise::params::ssl_dir}/certs/${::clientcert}.pem",
    private_key => "${puppet_enterprise::params::ssl_dir}/private_keys/${::clientcert}.pem",
    password    => $keystore_password,
    require     => Pe_java_ks['puppetca:truststore'],
  }

  file { [$java_ts_path, $java_ks_path]:
    ensure  => file,
    owner   => $puppet_enterprise::params::root_user,
    group   => 'pe-activemq',
    mode    => '0640',
    require => Pe_java_ks['puppetca:truststore', "${brokername}:keystore"],
  }
}
