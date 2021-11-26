# Type for configuring and deploying the razor application to torquebox
#
# @param server_http_port [Integer] The http port to bind torquebox to.
# @param server_https_port [Integer] The https port to bind torquebox to.
define pe_razor::server::torquebox() {
  include pe_razor::params

  $ssl_dir = '/etc/puppetlabs/puppet/ssl'

  $jboss_standalone_dir = $pe_razor::params::jboss_standalone_dir
  $jboss_standalone_xml_path = "${jboss_standalone_dir}/configuration/standalone.xml"

  $java_ssl_alias   = 'pe-razor'
  $java_ts_path     = "${pe_razor::params::data_dir}/pe-razor.ts"
  $java_ts_password = 'pe-razor'
  $java_ts_alias    = 'pe-razor:truststore'
  $java_ks_path     = "${pe_razor::params::data_dir}/pe-razor.ks"
  $java_ks_password = 'pe-razor'
  $java_ks_alias    = 'pe-razor:keystore'

  Pe_java_ks {
    path   => [ $pe_razor::params::pe_java_ks_path, '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
  }

  pe_java_ks { $java_ts_alias:
    ensure       => latest,
    target       => $java_ts_path,
    certificate  => "${ssl_dir}/certs/ca.pem",
    password     => $java_ts_password,
    trustcacerts => true,
  }

  pe_java_ks { $java_ks_alias:
    ensure      => latest,
    target      => $java_ks_path,
    certificate => "${ssl_dir}/certs/${::clientcert}.pem",
    private_key => "${ssl_dir}/private_keys/${::clientcert}.pem",
    password    => $java_ks_password,
    require     => Pe_java_ks[$java_ts_alias],
  }

  # The xml configuration file needs to be layed down before the service start
  # Template uses:
  #   - $java_ssl_alias
  #   - $java_ks_password
  #   - $java_ks_path
  #   - $java_ts_password
  #   - $java_ts_path
  file { $jboss_standalone_xml_path:
    ensure  => file,
    owner   => 'pe-razor',
    content => template('pe_razor/standalone.xml.erb'),
    before  => Service['pe-razor-server'],
  }

  # Ensure that we have deployed the application.
  exec { 'deploy the razor application to torquebox':
    provider => shell,
    command  => template('pe_razor/do-deploy.sh.erb'),
    creates  => "${jboss_standalone_dir}/deployments/razor-server-knob.yml",
    require  => Package['pe-razor-server'],
  }

  # This one is to work around the fact that `creates` means we never deploy
  # twice.  This one should only trigger if the update to our
  # database happened.
  exec { 'redeploy the razor application to torquebox':
    provider    => shell,
    command     => template('pe_razor/do-redeploy.sh.erb'),
    refreshonly => true,
    require     => Service['pe-razor-server'],
  }
}
