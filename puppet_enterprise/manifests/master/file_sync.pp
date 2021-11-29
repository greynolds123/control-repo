# Internal class for Puppet Enterprise to configure File Sync
#
# @param puppet_master_host [String] The host against which the agent is running
# @param master_of_masters_certname [String] The certname of the Master of Masters
# @param localcacert [String] The path to the local CA cert used for generating SSL certs.
# @param puppetserver_jruby_puppet_master_code_dir [String] The path to the code directory to be used by puppetserver
# @param puppetserver_webserver_ssl_port [String] The port to be used by puppetserver
# @param storage_service_disabled [Boolean] Whether or not the storage service should be disabled
# @param certname [String] The cert name the Server will use.
# @param file_sync_poll_interval [Integer] The interval, in seconds, at which a file sync client should poll the storage server
# @param file_sync_staging_dir [String] The path to the staging directory to be used by file sync
# @param whitelisted_certnames [Array[String]] Array of certnames that should
#    granted access to the file-sync API and git repo.  Note that any nodes
#    assigned to the "puppet_enterprise::profile::master" class are
#    automatically granted access to the file-sync endpoints, so this would
#    just be a list of any additional nodes that would need to be granted
#    access.  Defaults to [].
# @param provisioned_replicas [Array[String]] Array of certnames for provisioned
#   replicas; these will be given access to the ca-data file sync repo.
class puppet_enterprise::master::file_sync(
  $puppet_master_host,
  $master_of_masters_certname,
  $localcacert,
  $puppetserver_jruby_puppet_master_code_dir,
  $puppetserver_webserver_ssl_port,
  Boolean $storage_service_disabled,
  $certname                                              = $facts['clientcert'],
  $file_sync_poll_interval                               = 5,
  $file_sync_staging_dir                                 = '/etc/puppetlabs/code-staging',
  $file_sync_submodules_dir                              = '/etc/puppetlabs/code/environments/$<%= environments %>/modules',
  $file_sync_locking_enabled                             = true,
  Array[String] $whitelisted_certnames                   = [],
  $file_sync_enable_forceful_sync                        = true,
  $file_sync_preserve_deleted_submodules                 = false,
  Integer $file_sync_stream_file_threshold               = 1024,
  Puppet_enterprise::Replication_mode $replication_mode  = 'none',
  Array[String] $provisioned_replicas                    = [],
) inherits puppet_enterprise::params {
  include puppet_enterprise::packages

  $container = 'puppetserver'
  $confdir = "/etc/puppetlabs/${container}"

  File {
    ensure => present,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0640',
  }

  Pe_hocon_setting {
    ensure => present,
    notify => Service["pe-${container}"],
  }

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg {
    container => $container,
    require   => Package['pe-puppetserver'],
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'file-sync-client-service' :
    namespace => 'puppetlabs.enterprise.services.file-sync-client.file-sync-client-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'file-sync-web-service' :
    namespace => 'puppetlabs.enterprise.services.file-sync-web-service.file-sync-web-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'file-sync-versioned-code-service' :
    namespace => 'puppetlabs.enterprise.services.file-sync.file-sync-versioned-code-service',
  }

  $file_sync_config_file = "${confdir}/conf.d/file-sync.conf"
  #PE File Sync configuration
  file { $file_sync_config_file :
    ensure => present,
  }

  pe_hocon_setting { 'file-sync.data-dir':
    path    => $file_sync_config_file,
    setting => 'file-sync.data-dir',
    value   => '/opt/puppetlabs/server/data/puppetserver/filesync',
  }
  pe_hocon_setting { 'file-sync.client.poll-interval':
    path    => $file_sync_config_file,
    setting => 'file-sync.client.poll-interval',
    value   => $file_sync_poll_interval,
  }
  pe_hocon_setting { 'file-sync.client.server-api-url':
    path    => $file_sync_config_file,
    setting => 'file-sync.client.server-api-url',
    value   => "https://${puppet_master_host}:${puppetserver_webserver_ssl_port}/file-sync/v1",
  }
  pe_hocon_setting { 'file-sync.client.server-repo-url':
    path    => $file_sync_config_file,
    setting => 'file-sync.client.server-repo-url',
    value   => "https://${puppet_master_host}:${puppetserver_webserver_ssl_port}/file-sync-git",
  }
  pe_hocon_setting { 'file-sync.client.ssl-cert':
    path    => $file_sync_config_file,
    setting => 'file-sync.client.ssl-cert',
    value   => "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
  }
  pe_hocon_setting { 'file-sync.client.ssl-key':
    path    => $file_sync_config_file,
    setting => 'file-sync.client.ssl-key',
    value   => "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
  }
  pe_hocon_setting { 'file-sync.client.ssl-ca-cert':
    path    => $file_sync_config_file,
    setting => 'file-sync.client.ssl-ca-cert',
    value   => $localcacert,
  }
  pe_hocon_setting { 'file-sync.client.enable-forceful-sync':
    path    => $file_sync_config_file,
    setting => 'file-sync.client.enable-forceful-sync',
    value   => $file_sync_enable_forceful_sync,
  }
  pe_hocon_setting { 'file-sync.client.stream-file-threshold':
    path    => $file_sync_config_file,
    setting => 'file-sync.client.stream-file-threshold',
    value   => $file_sync_stream_file_threshold,
  }

  pe_hocon_setting { 'file-sync.repos.puppet-code.live-dir':
    path    => $file_sync_config_file,
    setting => 'file-sync.repos.puppet-code.live-dir',
    value   => $puppetserver_jruby_puppet_master_code_dir,
  }

  pe_hocon_setting { 'file-sync.preserve-deleted-submodules':
    path    => $file_sync_config_file,
    setting => 'file-sync.preserve-deleted-submodules',
    value   => $file_sync_preserve_deleted_submodules,
  }

  pe_hocon_setting { 'file-sync.repos.puppet-code.submodules-dir':
    path    => $file_sync_config_file,
    setting => 'file-sync.repos.puppet-code.submodules-dir',
    value   => $file_sync_submodules_dir,
  }

  pe_hocon_setting { 'pe-puppetserver.enable-file-sync-locking':
    path    => "${confdir}/conf.d/pe-puppet-server.conf",
    setting => 'pe-puppetserver.enable-file-sync-locking',
    value   => $file_sync_locking_enabled,
  }

  pe_hocon_setting { 'web-router-service/file-sync-web-service':
    path    => "${confdir}/conf.d/web-routes.conf",
    setting => 'web-router-service."puppetlabs.enterprise.services.file-sync-web-service.file-sync-web-service/file-sync-web-service"',
    value   => '/file-sync',
  }

  file { $puppetserver_jruby_puppet_master_code_dir:
    ensure => 'directory',
    owner => 'pe-puppet',
    group => 'pe-puppet',
    mode => '0740',
    recurse => false,
  }

  exec { 'chown all environments to pe-puppet' :
    command => "chown -R pe-puppet:pe-puppet ${puppetserver_jruby_puppet_master_code_dir}",
    unless  => "test \$(find ${puppetserver_jruby_puppet_master_code_dir} -not -user pe-puppet -print | wc -l) -eq 0",
    path    => ['/bin', '/usr/bin'],
    require => File[$puppetserver_jruby_puppet_master_code_dir],
  }

  $auth_conf = "${confdir}/conf.d/auth.conf"

  Pe_puppet_authorization::Rule {
    path   => $auth_conf,
    notify => Service["pe-${container}"],
  }

  if $storage_service_disabled {
    pe_hocon_setting { 'file-sync.repos.puppet-code.staging-dir':
      ensure  => absent,
      path    => $file_sync_config_file,
      setting => 'file-sync.repos.puppet-code.staging-dir',
    }
    if pe_current_server_version() == 'NOT-INSTALLED' {
      # Backup and remove the contents of the code-dir so that
      # it can be synced from the MoM
      exec { 'Backup code-dir':
        command => "tar czf /opt/puppetlabs/server/data/puppetserver/code-backup.tar.gz ${puppetserver_jruby_puppet_master_code_dir}",
        path    => '/sbin/:/bin/',
      }
      exec { 'Empty code-dir contents':
        command => "rm -rf ${puppetserver_jruby_puppet_master_code_dir}/*",
        path    => '/sbin/:/bin/',
        notify => Service["pe-${container}"],
        require => Exec['Backup code-dir'],
      }
    }

    pe_puppet_authorization::rule { 'puppetlabs file sync api':
      match_request_path   => '/file-sync/v1/',
      match_request_type   => 'path',
      allow                => [$certname, $master_of_masters_certname],
      sort_order           => 500,
    }

    pe_puppet_authorization::rule { 'puppetlabs file sync repo':
      ensure => absent,
    }
  } else {
    pe_hocon_setting { 'web-router-service/file-sync-storage-service/repo-servlet':
      path    => "${confdir}/conf.d/web-routes.conf",
      setting => 'web-router-service."puppetlabs.enterprise.services.file-sync-storage.file-sync-storage-service/file-sync-storage-service".repo-servlet',
      value   => '/file-sync-git',
    }
    puppet_enterprise::trapperkeeper::bootstrap_cfg { 'file-sync-storage-service' :
      namespace => 'puppetlabs.enterprise.services.file-sync-storage.file-sync-storage-service',
    }
    pe_hocon_setting { 'file-sync.repos.puppet-code.staging-dir':
      path    => $file_sync_config_file,
      setting => 'file-sync.repos.puppet-code.staging-dir',
      value   => $file_sync_staging_dir,
    }
    file { $file_sync_staging_dir:
      ensure  => 'directory',
      owner   => 'pe-puppet',
      group   => 'pe-puppet',
      mode    => '0740',
      recurse => false,
    }
    exec { "chown all ${file_sync_staging_dir} to pe-puppet" :
      command => "chown -R pe-puppet:pe-puppet ${file_sync_staging_dir}",
      unless  => "test \$(find ${file_sync_staging_dir} -not -user pe-puppet -print | wc -l) -eq 0",
      path    => ['/bin', '/usr/bin'],
      require => File[$file_sync_staging_dir],
    }


    $authorized_certs = pe_union([$certname], $whitelisted_certnames)
    # "storeconfigs" being true is used here to determine if PuppetDB is ready
    # to accept queries. This only matters during a PE installation when
    # templates are applied. This setting is typically false then, since a
    # manifest might otherwise attempt to query PuppetDB before it was running.
    if $settings::storeconfigs {
      $masters_in_puppetdb = map(
        puppetdb_query(['from', 'resources',
                        ['extract', ['certname'],
                         ['and', ['=', 'type', 'Class'],
                          ['=', 'title', 'Puppet_enterprise::Profile::Master'],
                          ['or', ['=', ['parameter', 'file_sync_enabled'], true],
                                 ['=', ['parameter', 'file_sync_enabled'], 'automatic']],
                          ['=', ['node','active'], true]]]])) |$master| { $master['certname'] }
    } else {
      $masters_in_puppetdb = []
    }
    # This may include machines with client tools (eg code manager cli)
    $certs_authorized_to_communicate_with_file_sync = pe_sort(pe_unique(pe_union($authorized_certs, $masters_in_puppetdb)))

    # These are only masters compiling puppet code
    $file_sync_clients = pe_sort(pe_unique(pe_union([$certname], $masters_in_puppetdb)))

    pe_hocon_setting { 'file-sync.client-certnames':
      path    => $file_sync_config_file,
      setting => 'file-sync.client-certnames',
      value   => $file_sync_clients,
      type    => 'array',
    }

    pe_puppet_authorization::rule { 'puppetlabs file sync ca-data repo':
      match_request_path => '/file-sync-git/ca-data',
      match_request_type => 'path',
      allow              => $provisioned_replicas,
      sort_order         => 499,
    }

    pe_puppet_authorization::rule { 'puppetlabs file sync api':
      match_request_path   => '/file-sync/v1/',
      match_request_type   => 'path',
      allow                => $certs_authorized_to_communicate_with_file_sync,
      sort_order           => 500,
    }

    pe_puppet_authorization::rule { 'puppetlabs file sync repo':
      match_request_path   => '/file-sync-git/',
      match_request_type   => 'path',
      allow                => $certs_authorized_to_communicate_with_file_sync,
      sort_order           => 500,
    }
  }

  #Note that a directory with the same name as file_sync_repo_name should exist
  #in files/master/file_sync, with a gitignore file inside the directory

  $ha_ssl_dir = '/opt/puppetlabs/server/data/primary-ca-data'

  puppet_enterprise::file_sync_directory { 'ssl directory':
    live_dir              => $ha_ssl_dir,
    staging_dir           => '/etc/puppetlabs/puppet/ssl',
    file_sync_config_file => $file_sync_config_file,
    file_sync_repo_name   => 'ca-data',
    replication_mode      => $replication_mode,
  }

  puppet_enterprise::file_sync_directory { 'enterprise conf.d directory':
    live_dir => '/etc/puppetlabs/enterprise/conf.d',
    staging_dir => '/etc/puppetlabs/enterprise/conf.d',
    file_sync_config_file => $file_sync_config_file,
    file_sync_repo_name => 'confd-data',
    replication_mode => $replication_mode,
  }
}
