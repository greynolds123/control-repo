# This class sets up the agent. For more information, see the [README.md](./README.md)
#
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
class puppet_enterprise::profile::agent(
  Boolean $manage_symlinks = $puppet_enterprise::manage_symlinks,
  Boolean $pxp_enabled     = true,
  String $pcp_broker_host  = $puppet_enterprise::pcp_broker_host,
  Integer $pcp_broker_port = $puppet_enterprise::pcp_broker_port,
) inherits puppet_enterprise {

  include puppet_enterprise::symlinks

  if $manage_symlinks {
    File <| tag == 'pe-agent-symlinks' |>
  }

  # We still manage older agent installs, so if identity isn't specified fallback to only enabling
  # the pxp-agent service.
  if ($puppet_enterprise::params::pxp_compatible and
  ((defined('$identity') and $::identity['privileged']) or $pxp_enabled)) {
    class { 'puppet_enterprise::pxp_agent':
      broker_ws_uri => "wss://${pcp_broker_host}:${pcp_broker_port}/pcp/",
      enabled => $pxp_enabled,
    }
  }
}
