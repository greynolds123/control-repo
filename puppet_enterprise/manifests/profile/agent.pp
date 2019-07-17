# This class sets up the agent. For more information, see the [README.md](./README.md)
#
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
class puppet_enterprise::profile::agent(
  Boolean       $manage_symlinks           = $puppet_enterprise::manage_symlinks,
  Boolean       $pxp_enabled               = true,
  String        $pcp_broker_host           = $puppet_enterprise::pcp_broker_host,
  Integer       $pcp_broker_port           = $puppet_enterprise::pcp_broker_port,
  Boolean       $manage_puppet_conf        = false,
  Array[String] $server_list               = [],
  Array[String] $pcp_broker_ws_uris        = [],
  Array[String] $pcp_broker_list           = [],
  Boolean       $package_inventory_enabled = false,
  Optional[Array[String]] $master_uris     = undef,
) inherits puppet_enterprise {

  include puppet_enterprise::symlinks

  if $manage_symlinks {
    File <| tag == 'pe-agent-symlinks' |>
  }

  $_identity = pe_empty($facts['identity']) ? {
    false  => $facts['identity'],
    true => {},
  }

  # We still manage older agent installs, so if identity isn't specified fallback to only enabling
  # the pxp-agent service.
  if ($puppet_enterprise::params::pxp_compatible and
     ($_identity['privileged'] or $pxp_enabled)) {

    # if pcp_broker_ws_uris is set we can't configure pxp to use version 2.
    if (pe_empty($pcp_broker_ws_uris) and $puppet_enterprise::params::pcp_v2_compatible) {
       $pcp_version = '2'
    } else {
       $pcp_version = undef
    }

    $pcp_endpoint = if $pcp_version == '2' { 'pcp2' } else { 'pcp' }

    if pe_size($pcp_broker_list) > 0 {
      if !pe_empty($pcp_broker_ws_uris) {
        warning('Both $pcp_broker_ws_uris and $pcp_broker_list are set. $pcp_broker_ws_uris will be ignored.')
      }
      $pcp_broker_ws_uris_ = $pcp_broker_list.map |$broker| { "wss://${broker}/${pcp_endpoint}/" }
    } elsif !pe_empty($pcp_broker_ws_uris) {
        $pcp_broker_ws_uris_ = $pcp_broker_ws_uris
    } else {
      $pcp_broker_ws_uris_ = ["wss://${pcp_broker_host}:${pcp_broker_port}/${pcp_endpoint}/"]
    }

    if pe_empty($master_uris) {
      if pe_size($server_list) > 0 {
        $_master_uris = $server_list
      } else {
        $_master_uris = ["https://${puppet_enterprise::puppet_master_host}:${puppet_enterprise::puppet_master_port}"]
      }
    } else {
      $_master_uris = $master_uris
    }

    class { 'puppet_enterprise::pxp_agent':
      broker_ws_uri => $pcp_broker_ws_uris_,
      master_uris   => $_master_uris,
      pcp_version   => $pcp_version,
      enabled       => $pxp_enabled,
    }
  }

  if $puppet_enterprise::params::agent_failover_compatible and $manage_puppet_conf {
    if pe_size($server_list) > 0 {
      pe_ini_setting { 'agent conf file server_list':
        ensure  => present,
        path    => "${::puppet_enterprise::params::confdir}/puppet.conf",
        section => 'agent',
        setting => 'server_list',
        value   => pe_join($server_list, ','),
      }
    }
  }

  # Non-root users can't stat /opt/puppetlabs/puppet/cache
  # Note: The privileged flag of the identity fact only exists in Facter 3.2+
  # (puppet-agent 1.5.3, PE 2016.2.1), so an agent of that antiquity would need
  # to upgrade before package inventory data would be managed.
  if ($_identity['privileged']) {
    if $package_inventory_enabled {
      file {
        $puppet_enterprise::params::package_inventory_enabled_file:
          ensure => present,
          mode   => '0664',
      }
    } else {
      file {
        $puppet_enterprise::params::package_inventory_enabled_file:
          ensure => absent,
      }
    }
  }

  if !($facts['kernel'] in [ 'windows', 'Darwin' ]) {
    $uninstaller_path  = '/opt/puppetlabs/bin/puppet-enterprise-uninstaller'
    $_uninstall_script = file($uninstaller_path, '/dev/null')

    if $_uninstall_script =~ String[1] {
      file { $uninstaller_path :
        ensure  => file,
        mode    => '0544',
        content => $_uninstall_script,
      }
    }
  }
}
