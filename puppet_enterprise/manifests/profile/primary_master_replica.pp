# This role indicates the node is a replica Master of Masters to be provisioned
# for HA failover.
#
# @param database_host_puppetdb [String] The FQDN of the host running PostgreSQL for the PuppetDB database.
#
class puppet_enterprise::profile::primary_master_replica (
  String $database_host_puppetdb = $facts['clientcert'],
) {

  $master_host = $puppet_enterprise::puppet_master_host
  # On a monolithic install $puppetdb_hosts == [$master_host], and we're doing
  # this to align the code with the puppetdb terminus code.
  $puppetdb_hosts = $puppet_enterprise::puppetdb_hosts_array
  $puppetdb_port  = $puppet_enterprise::puppetdb_ports_array
  $sync_interval_minutes = $puppet_enterprise::puppetdb_sync_interval_minutes

  include puppet_enterprise::license

  # Needed while we're still using NC based classification
  Puppet_enterprise::App_database['activity'] -> Service['pe-console-services']
  Puppet_enterprise::App_database['classifier'] -> Service['pe-console-services']
  Puppet_enterprise::App_database['rbac'] -> Service['pe-console-services']
  Puppet_enterprise::App_database['puppetdb'] -> Service['pe-puppetdb']

  class { 'puppet_enterprise::profile::database':
    replication_source_hostname => $master_host,
    replication_mode            => 'replica',
  }

  # This class installs the puppet-infra and puppet-infrastructure shims so that
  # the subcommands for the HA CLI are readily available for replicas
  include pe_infrastructure::puppet_infra_shims

  # FIXME While we don't have repos set up on the replica
  Package <| tag == 'pe-orchestrator-packages' |>
  Package <| tag == 'pe-bolt-server-packages' |>
  Package <| tag == 'pe-ace-server-packages' |>

  $public_packages_dir = "${puppet_enterprise::packages_dir}/public"

  exec { "Ensure packages dir ${puppet_enterprise::packages_dir}":
    command => "mkdir -p ${puppet_enterprise::packages_dir}",
    path    => '/sbin/:/bin/',
    unless  => "ls ${puppet_enterprise::packages_dir}",
    require => Package['pe-puppetserver'],
    before  => File[$public_packages_dir],
  }

  file { $public_packages_dir:
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
    source  => [
      $public_packages_dir,
      "puppet:///${puppet_enterprise::packages_mountpoint}/", # lint:ignore:puppet_url_without_modules
    ],
    require => Exec["Ensure packages dir ${puppet_enterprise::packages_dir}"],
  }

  # This mountpoint has been unused since 2016.4.5; ensure that it is removed.
  # This can be dropped once we are no longer upgrading from versions < 2016.4.5.
  puppet_enterprise::fileserver_conf { $puppet_enterprise::module_mountpoint:
    ensure     => absent,
    mountpoint => $puppet_enterprise::module_mountpoint,
    path       => '',
  }

  class { 'puppet_enterprise::profile::master':
    classifier_host            => $facts['clientcert'],
    classifier_client_certname => $facts['clientcert'],
    console_host               => $facts['clientcert'],
    console_server_certname    => $facts['clientcert'],
    # The replica operates a CA proxy service, so it must forward traffic to
    # the primary master until promoted.
    ca_host                    => $master_host,
    master_of_masters_certname => $facts['clientcert'],
    file_sync_enabled          => true,
    replication_mode           => 'replica',
    puppetdb_host              => pe_concat($puppetdb_hosts, [$facts['clientcert']]),
    puppetdb_port              => $puppetdb_port,
    require                    => Class['puppet_enterprise::profile::database']
  }

  class { 'puppet_enterprise::profile::puppetdb':
    database_host   => $database_host_puppetdb,
    master_certname => $facts['clientcert'],
    rbac_host       => $facts['clientcert'],
    sync_peers      => $puppetdb_hosts.map |$sync_peer| {
      { host                  => $sync_peer,
        port                  => $puppetdb_port[0],
        sync_interval_minutes => $sync_interval_minutes }
    },
    sync_whitelist  => $puppetdb_hosts,
    require         => Class['puppet_enterprise::profile::database']
  }

  class { 'puppet_enterprise::profile::console':
    database_host            => $facts['clientcert'],
    master_host              => $facts['clientcert'],
    master_certname          => $facts['clientcert'],
    puppetdb_host            => [$facts['clientcert']],
    ca_host                  => $facts['clientcert'],

    replication_mode         => 'replica',
    whitelisted_certnames    => [$facts['clientcert']],

    activity_database_user   => $puppet_enterprise::activity_database_read_user,
    classifier_database_user => $puppet_enterprise::classifier_database_read_user,
    rbac_database_user       => $puppet_enterprise::rbac_database_read_user,
    require                  => Class['puppet_enterprise::profile::database']
  }

}
