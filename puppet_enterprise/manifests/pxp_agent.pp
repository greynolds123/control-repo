# Internal class for Puppet Enterprise to manage pxp-agent
#
# @param broker_ws_uri Variant[String, Array[String]] The websocket uri of the broker
#        endpoint, or array of uris to try. Should always be an array when used by pe
#        module code. Uris must begin with 'ws://' or 'wss://'.
# @param master_uris Optional[Array[String]] An array of uris used to download tasks.
#        Uris must begin with 'https://'.
# @param ssl_key [String] The path to the private key used to connect to the pcp-broker.
# @param ssl_cert [String] The path to the certificate used to connect to the pcp-broker.
# @param ssl_ca_cert [String] The path to the local CA cert used to issue the SSL certs.
# @param pxp_loglevel [String] One of the following logging levels: none,
#        trace, debug, info, warning, error, or fatal.
# @param pxp_logfile [String] Allows overriding the default logfile location.
# @param enabled [Boolean] Whether to start the pxp-agent service on boot.
# @param ping_interval [Integer] The interval between sending websocket pings. This
#        affects the time an agent waits before timing out and determining the broker
#        is unavailable if it has become unreachable (but not closed the TCP connection).
#        Only effects puppet-agent 1.9 and later.
# @param spool_dir_purge_ttl [String] The time to keep records of old Puppet or task runs
#        on agents. Is expressed in minutes/hours/days via '30m', '4h', '14d'. Defaults
#        to '14d' (14 days).
# @param task_cache_dir_purge_ttl [String] The time to keep unused cached tasks on agents.
#        Is expressed in minutes/hours/days via '30m', '4h', '14d'. Defaults to '14d'
#        (14 days).
# @param task_download_timeout the number of seconds to wait for a task download to complete.
# @param task_download_connect_timeout The number of seconds to wait for a connection to be
#        established when downloading a task.
# @param master_proxy Proxy URI for downloading tasks from master. An example for squid
#        might be https://<master>:3128. Proxy should be configured for SSL passthrough.
# @param broker_proxy Proxy URI for websocket connection with PCP broker. An example for
#        squid might be https://<master>:3128. Proxy should be configured for SSL passthrough.
# @param extra_options Any extra config that should be written to pxp-agent.conf. Only use
#        this for items that are not exposed as parameters on this class as compatability is
#        not guaranteed. Options specified in this has will not override other parameters on
#        this class.
class puppet_enterprise::pxp_agent(
  Variant[String, Array[String]] $broker_ws_uri,
  Optional[Array[String]]        $master_uris                   = undef,
  String                         $pxp_loglevel                  = 'info',
  Optional[String]               $pxp_logfile                   = undef,
  Optional[String]               $pcp_version                   = undef,
  Boolean                        $enabled                       = true,
  Optional[Integer]              $ping_interval                 = undef,
  Optional[String]               $spool_dir_purge_ttl           = undef,
  Optional[String]               $task_cache_dir_purge_ttl      = undef,
  Optional[Integer]              $task_download_timeout         = undef,
  Optional[Integer]              $task_download_connect_timeout = undef,
  Optional[String]               $master_proxy                  = undef,
  Optional[String]               $broker_proxy                  = undef,
  Optional[Hash]                 $extra_options                 = {},
) inherits puppet_enterprise::params {

  $broker_ws_uris = pe_any2array($broker_ws_uri)

  $broker_ws_uris_config = $puppet_enterprise::params::agent_failover_compatible ? {
    true    => { 'broker-ws-uris' => $broker_ws_uris },
    default => { 'broker-ws-uri'  => $broker_ws_uris[0] },
  }

  # These should only be added if they're non-empty and the agent version supports them.
  # Add only if the version is compatible then filter undefined keys
  $optional_config = {
    'pcp-version' => $pcp_version,
    'logfile' => $pxp_logfile,
    'ping-interval' => $puppet_enterprise::params::ping_interval_compatible ? {
      true    => $ping_interval,
      default => undef },
    'master-uris' => $puppet_enterprise::params::pxp_task_compatible ? {
      true    => $master_uris,
      default => undef },
    'spool-dir-purge-ttl' => $puppet_enterprise::params::spool_ttl_compatible ? {
      true    => $spool_dir_purge_ttl,
      default => undef },
    'task-cache-dir-purge-ttl' => $puppet_enterprise::params::task_cache_ttl_compatible ? {
      true    => $task_cache_dir_purge_ttl,
      default => undef },
    'task-download-timeout' => $puppet_enterprise::params::task_download_timeout_compatible ? {
      true    => $task_download_timeout,
      default => undef },
    'task-download-connect-timeout' => $puppet_enterprise::params::task_download_timeout_compatible ? {
      true    => $task_download_connect_timeout,
      default => undef },
    'master-proxy' => $puppet_enterprise::params::pxp_proxy_compatible ? {
      true    => $master_proxy,
      default => undef },
    'broker-ws-proxy' => $puppet_enterprise::params::pxp_proxy_compatible ? {
      true    => $broker_proxy,
      default => undef },
    }.filter |$key, $val| { !pe_empty($val) }

  $pxp_agent_config = pe_merge($extra_options,
                               $broker_ws_uris_config,
                               $optional_config,
                               {
                                 'ssl-key'     => "${puppet_enterprise::params::ssl_dir}/private_keys/${facts['clientcert']}.pem",
                                 'ssl-cert'    => "${puppet_enterprise::params::ssl_dir}/certs/${facts['clientcert']}.pem",
                                 'ssl-ca-cert' => $puppet_enterprise::params::localcacert,
                                 'loglevel'    => $pxp_loglevel,
                               })

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
