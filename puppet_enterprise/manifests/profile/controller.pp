# This profile sets up PE controller tools.
#
# @param manage_puppet_code [Boolean] Whether the puppet-code global config should be managed
# @param puppet_code_service_url [String] The URL of the code-manager service
class puppet_enterprise::profile::controller(
  Boolean $manage_puppet_code        = true,
  Boolean $manage_orchestrator       = true,
  Optional[String] $code_manager_url = $puppet_enterprise::code_manager_url,
  Optional[String] $orchestrator_url = $puppet_enterprise::orchestrator_url,
  String $rbac_url                   = $puppet_enterprise::rbac_url,
  Array[String]  $puppetdb_hosts     = $puppet_enterprise::puppetdb_hosts_array,
  Array[Integer] $puppetdb_port      = $puppet_enterprise::puppetdb_ports_array,
  Array[String] $puppetdb_urls       = pe_format_urls('https',
                                                      $puppetdb_hosts,
                                                      $puppetdb_port),
) inherits puppet_enterprise {

  include puppet_enterprise::packages
  Package<| tag == 'pe-controller-packages' |>

  $client_tools_confdir = $puppet_enterprise::params::client_tools_confdir
  $client_tools_ssldir = "${client_tools_confdir}/ssl"
  $client_tools_certsdir = "${client_tools_ssldir}/certs"
  $client_tools_cacert = "${client_tools_certsdir}/ca.pem"

  $root_user = $puppet_enterprise::params::root_user
  $root_group = $puppet_enterprise::params::root_group

  file {
    default:
      owner   => $root_user,
      group   => $root_group,
      require => Package['pe-client-tools'];
    [$client_tools_confdir, $client_tools_ssldir, $client_tools_certsdir]:
      ensure  => directory,
      mode    => '0755',
      recurse => false;
    $client_tools_cacert:
      ensure => present,
      source => $puppet_enterprise::params::localcacert,
      mode    => '0444';
  }

  if $manage_orchestrator {
    $orchestrator_config = "${client_tools_confdir}/orchestrator.conf"

    # Don't define any settings in the config file with unset values.
    $service_url_setting = {'service-url' => $orchestrator_url}.filter |$pair| { !pe_empty($pair[1]) }
    $_orchestrator_config = {'options' =>  $service_url_setting}

    file { $orchestrator_config:
      ensure  => present,
      owner   => $root_user,
      group   => $root_group,
      mode    => '0444',
      content => inline_template('<%= @_orchestrator_config.to_json %>'),
    }
  }

  if $manage_puppet_code {
    $puppet_code_config = "${client_tools_confdir}/puppet-code.conf"

    # Don't define any settings in the config file with unset values.
    $_puppet_code_config = {'service-url' => $code_manager_url}.filter |$pair| { !pe_empty($pair[1]) }

    file { $puppet_code_config:
      ensure  => present,
      owner   => $root_user,
      group   => $root_group,
      mode    => '0444',
      content => inline_template('<%= @_puppet_code_config.to_json %>'),
    }
  }

  $puppet_access_config = "${client_tools_confdir}/puppet-access.conf"
  $_puppet_access_config = {
    'service-url'      => $rbac_url,
    'certificate-file' => $puppet_enterprise::params::localcacert
  }.filter |$pair| { !pe_empty($pair[1]) }

  file { $puppet_access_config:
    ensure  => present,
    owner   => $root_user,
    group   => $root_group,
    mode    => '0444',
    content => inline_template('<%= @_puppet_access_config.to_json %>'),
  }

  $puppetdb_cli_config = "${client_tools_confdir}/puppetdb.conf"
  $_puppetdb_cli_config = { 'puppetdb' =>  {
      'server_urls' => $puppetdb_urls,
      'cacert'      => $puppet_enterprise::params::localcacert
    }.filter |$pair| { !pe_empty($pair[1]) }
  }

    file { $puppetdb_cli_config:
      ensure  => present,
      owner   => $root_user,
      group   => $root_group,
      mode    => '0444',
      content => inline_template('<%= @_puppetdb_cli_config.to_json %>'),
    }

  class { 'puppet_enterprise::cli_config':
    path    => "${client_tools_confdir}/services.conf",
    user    => $root_user,
    group   => $root_group,
    mode    => '0444',
    require => Package['pe-client-tools'];
  }
}
