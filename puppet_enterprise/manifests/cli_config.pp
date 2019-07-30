# Manage a config file that contains information about all known services in a
# PE installation; this is very useful for CLI tools that have to talk to
# various pieces of it.
#
# @param path [String] The path to the config file
# @param user [String] The user that owns the config file
# @param group [String] The group that owns the config file
# @param mode [String] The mode of the config file
# @param additional_services Service records to add to the config file,
# in addition to those queried from puppetdb.
# @param additional_nodes Node records to add to the config file, in addition
# to those queried from pe.conf
class puppet_enterprise::cli_config (
  String $path,
  String $user,
  String $group,
  String $mode,
  Array[
    Struct[
      { type => String,
        url => String,
        server => String,
        port => Integer,
        prefix => String,
        status_url => String,
        status_prefix => String,
        primary => Boolean,
        node_certname => String }]] $additional_services = [],
  Array[
    Struct[
      { certname => String,
        role => String }]] $additional_nodes = [],
) inherits puppet_enterprise {
  if $settings::storeconfigs {
    $classes_to_fetch = {
      'Puppet_enterprise::Profile::Master' => [
        { type => 'master',
          port_param => 'ssl_listen_port',
          service_prefix => '',
          status_key => 'pe-master',
          display_name => 'Puppet Server',},],
      'Puppet_enterprise::Master::File_sync' => [
        { type => 'file-sync-storage',
          port_param => 'puppetserver_webserver_ssl_port',
          service_prefix => '',
          status_key => 'file-sync-storage-service',
          disabled_param => 'storage_service_disabled',
          display_name => 'File Sync Storage Service',},
        { type => 'file-sync-client',
          port_param => 'puppetserver_webserver_ssl_port',
          service_prefix => '',
          status_key => 'file-sync-client-service',
          display_name => 'File Sync Client Service',},],
      'Puppet_enterprise::Master::Code_manager' => [
        { type => 'code-manager',
          port_param => 'webserver_ssl_port',
          service_prefix => '',
          status_key => 'code-manager-service',
          status_port_param => 'puppet_master_port',
          display_name => 'Code Manager',}],
      'Puppet_enterprise::Profile::Puppetdb' => [
        { type => 'puppetdb',
          port_param => 'ssl_listen_port',
          service_prefix => 'pdb',
          status_key => 'puppetdb-status',
          display_name => 'PuppetDB'}],
      'Puppet_enterprise::Profile::Orchestrator' => [
        { type => 'orchestrator',
          port_param => 'ssl_listen_port',
          service_prefix => 'orchestrator',
          status_key => 'orchestrator-service',
          display_name => 'Orchestrator'},
        { type => 'pcp-broker',
          port_param => 'pcp_listen_port',
          status_port_param => 'ssl_listen_port',
          service_prefix => 'pcp',
          status_key => 'broker-service',
          display_name => 'PCP Broker',
          protocol => 'wss'},
        { type => 'pcp-broker',
          port_param => 'pcp_listen_port',
          status_port_param => 'ssl_listen_port',
          service_prefix => 'pcp2',
          status_key => 'broker-service',
          display_name => 'PCP Broker v2',
          protocol => 'wss'}],
      'Puppet_enterprise::Profile::Console' => [
        { type => 'classifier',
          port_param => 'console_services_api_ssl_listen_port',
          service_prefix => 'classifier-api',
          status_key => 'classifier-service',
          display_name => 'Classifier',},
        { type => 'rbac',
          port_param => 'console_services_api_ssl_listen_port',
          service_prefix => 'rbac-api',
          status_key => 'rbac-service',
          display_name => 'RBAC',},
        { type => 'activity',
          port_param => 'console_services_api_ssl_listen_port',
          service_prefix => 'activity-api',
          status_key => 'activity-service',
          display_name => 'Activity Service',}
      ]
    }

    $query_or_clause =
      pe_concat(['or'],
                pe_keys($classes_to_fetch).map |$title| {['=', 'title', $title]})

    $rows = puppetdb_query(['from', 'resources',
                            ['extract', ['certname', 'title', 'parameters', 'tags'],
                             ['and',
                              ['=', ['node','active'], true],
                              ['=', 'type', 'Class'],
                              $query_or_clause]],
                            ['order_by', [['certname','asc'], ['title', 'asc']]]])

    $rows_with_role_tags = $rows.filter |$row| {
      $replica_role = 'puppet_enterprise::profile::primary_master_replica'
      $row['tags'].filter |$tag| { $tag == $replica_role }[0] != undef
    }
    $primary_master_replica_nodes = pe_unique($rows_with_role_tags.map |$row| {
      {
        'role' => 'primary_master_replica',
        'display_name' => 'Primary Master Replica',
        'certname' => $row['certname']
      }
    })

    $queried_services_nested = $rows.map |$row| {
      $resource_title = $row['title']
      $class_parameters = $row['parameters']
      $node_certname = $row['certname']

      $service_defs_for_class = $classes_to_fetch[$resource_title]
      $service_defs_for_class.map |$service_def| {
        $service_prefix = $service_def['service_prefix']
        $service_type = $service_def['type']
        $service_display_name = $service_def['display_name']
        $service_status_key = $service_def['status_key']
        $service_port_param = $service_def['port_param']
        $status_port_param = $service_def['status_port_param']
        $service_disabled_param = $service_def['disabled_param']
        $service_port = $class_parameters[$service_port_param]
        $service_protocol = if $service_def['protocol'] { $service_def['protocol'] } else { 'https' }

        # Here we use the status port param if it is set, but
        # default to the service port if it is not set
        $status_port = if $status_port_param {
            $class_parameters[$status_port_param]
          } else {
            $service_port
          }
        $exclude_service = ($service_disabled_param and $class_parameters[$service_disabled_param])

        unless $exclude_service  {
          {
            type          => $service_type,
            url           => "${service_protocol}://${node_certname}:${service_port}/${service_prefix}",
            server        => $node_certname,
            port          => $service_port,
            prefix        => $service_prefix,
            status_url    => "https://${node_certname}:${status_port}/status",
            status_prefix => 'status',
            status_key    => $service_status_key,
            node_certname => $node_certname,
            display_name  => $service_display_name,
          }
        }
      }
    }

    $queried_services = pe_flatten($queried_services_nested).filter |$elem| { $elem != undef}

    $queried_nodes = pe_concat([
      {
        'role' => 'primary_master',
        'display_name' => 'Primary Master',
        'certname' => $puppet_enterprise::puppet_master_host
      },
    ],
    $primary_master_replica_nodes)
  }
  else {
    $queried_services = []
    $queried_nodes = []
  }

  Pe_hocon_setting {
    ensure  => present,
    path    => $path,
  }

  file { $path:
    ensure => present,
    owner  => $user,
    group  => $group,
    mode   => $mode,
  }

  pe_hocon_setting { "${path}/services":
    setting => 'services',
    value   => pe_concat($queried_services, $additional_services),
    type    => 'array',
  }

  pe_hocon_setting { "${path}/nodes":
    setting => 'nodes',
    value   => pe_concat($queried_nodes, $additional_nodes),
    type    => 'array',
  }

  pe_hocon_setting { "${path}/certs":
    setting => 'certs',
    value   => {
      'ca-cert' => $puppet_enterprise::params::localcacert,
    },
    type    => 'hash',
  }
}
