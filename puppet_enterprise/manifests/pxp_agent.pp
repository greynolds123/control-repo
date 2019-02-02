# Internal class for Puppet Enterprise to manage pxp-agent
#
# @param broker_ws_uri [String] The websocket uri of the broker endpoint.
# @param ssl_key [String] The path to the private key used to connect to the pcp-broker.
# @param ssl_cert [String] The path to the certificate used to connect to the pcp-broker.
# @param ssl_ca_cert [String] The path to the local CA cert used to issue the SSL certs.
class puppet_enterprise::pxp_agent(
  $broker_ws_uri,
  String $pxp_loglevel = 'info',
  Boolean $enabled = true,
) inherits puppet_enterprise::params {

  $pxp_agent_config = {
    'broker-ws-uri' => $broker_ws_uri,
    'ssl-key'       => "${puppet_enterprise::params::ssl_dir}/private_keys/${::clientcert}.pem",
    'ssl-cert'      => "${puppet_enterprise::params::ssl_dir}/certs/${::clientcert}.pem",
    'ssl-ca-cert'   => $puppet_enterprise::params::localcacert,
    'loglevel'      => $pxp_loglevel,
  }

  # Manage the pxp-agent configuration
  # Template uses:
  # - $pxp_agent_config
  # TODO(CTH-383) replace with pe_hocon_setting resources once CTH-383 is shipping
  file { "${puppet_enterprise::params::pxp_agent_etc}/pxp-agent.conf":
    content => inline_template('<%= @pxp_agent_config.to_json %>'),
    mode    => '0660',
    notify  => Service['pxp-agent'],
  }

  class { 'puppet_enterprise::pxp_agent::service':
    enabled => $enabled,
  }

}
