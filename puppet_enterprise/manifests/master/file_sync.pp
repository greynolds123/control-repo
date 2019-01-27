# Internal class for Puppet Enterprise to configure File Sync
#
# @param puppet_master_host [String] The host against which the agent is running
# @param master_of_masters_certname [String] The certname of the Master of Masters
# @param localcacert [String] The path to the local CA cert used for generating SSL certs.
# @param puppetserver_jruby_puppet_master_code_dir [String] The path to the code directory to be used by puppetserver
# @param puppetserver_webserver_ssl_port [String] The port to be used by puppetserver
# @param compile_master [Boolean] Whether or not puppet is being run on a compile master
# @param certname [String] The cert name the Server will use.
# @param file_sync_poll_interval [Integer] The interval, in seconds, at which a file sync client should poll the storage server
# @param file_sync_staging_dir [String] The path to the staging directory to be used by file sync
# @param whitelisted_certnames [Array[String]] Array of certnames that should
#    granted access to the file-sync API and git repo.  Note that any nodes
#    assigned to the "puppet_enterprise::profile::master" class are
#    automatically granted access to the file-sync endpoints, so this would
#    just be a list of any additional nodes that would need to be granted
#    access.  Defaults to [].
class puppet_enterprise::master::file_sync(
  $puppet_master_host,
  $master_of_masters_certname,
  $localcacert,
  $puppetserver_jruby_puppet_master_code_dir,
  $puppetserver_webserver_ssl_port,
  $compile_master,
  $certname                                              = $::clientcert,
  $file_sync_poll_interval                               = 5,
  $file_sync_staging_dir                                 = '/etc/puppetlabs/code-staging',
  $file_sync_submodules_dir                              = 'environments',
  $file_sync_locking_enabled                             = true,
  Array[String] $whitelisted_certnames                   = [],
  $file_sync_enable_forceful_sync                        = true,
  $file_sync_preserve_deleted_submodules                 = false,
) inherits puppet_enterprise::params {

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

  #PE File Sync configuration
  file { "${confdir}/conf.d/file-sync.conf" :
    ensure => present,
  }

  pe_hocon_setting { 'file-sync.data-dir':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.data-dir',
    value   => '/opt/puppetlabs/server/data/puppetserver/filesync',
  }
  pe_hocon_setting { 'file-sync.client.poll-interval':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.client.poll-interval',
    value   => $file_sync_poll_interval,
  }
  pe_hocon_setting { 'file-sync.client.server-api-url':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.client.server-api-url',
    value   => "https://${puppet_master_host}:${puppetserver_webserver_ssl_port}/file-sync/v1",
  }
  pe_hocon_setting { 'file-sync.client.server-repo-url':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.client.server-repo-url',
    value   => "https://${puppet_master_host}:${puppetserver_webserver_ssl_port}/file-sync-git",
  }
  pe_hocon_setting { 'file-sync.client.ssl-cert':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.client.ssl-cert',
    value   => "/etc/puppetlabs/puppet/ssl/certs/${certname}.pem",
  }
  pe_hocon_setting { 'file-sync.client.ssl-key':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.client.ssl-key',
    value   => "/etc/puppetlabs/puppet/ssl/private_keys/${certname}.pem",
  }
  pe_hocon_setting { 'file-sync.client.ssl-ca-cert':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.client.ssl-ca-cert',
    value   => $localcacert,
  }
  pe_hocon_setting { 'file-sync.client.enable-forceful-sync':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.client.enable-forceful-sync',
    value   => $file_sync_enable_forceful_sync,
  }

  pe_hocon_setting { 'file-sync.repos.puppet-code.live-dir':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.repos.puppet-code.live-dir',
    value   => $puppetserver_jruby_puppet_master_code_dir,
  }

  pe_hocon_setting { 'file-sync.preserve-deleted-submodules':
    path    => "${confdir}/conf.d/file-sync.conf",
    setting => 'file-sync.preserve-deleted-submodules',
    value   => $file_sync_preserve_deleted_submodules,
  }

  pe_hocon_setting { 'file-sync.repos.puppet-code.submodules-dir':
    path    => "${confdir}/conf.d/file-sync.conf",
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
    command => "/bin/chown -R pe-puppet:pe-puppet ${puppetserver_jruby_puppet_master_code_dir}",
    unless  => "/usr/bin/test \$(stat -c %U ${puppetserver_jruby_puppet_master_code_dir}/environments/production) = 'pe-puppet'",
    require => File[$puppetserver_jruby_puppet_master_code_dir],
  }

  $auth_conf = "${confdir}/conf.d/auth.conf"

  Pe_puppet_authorization::Rule {
    path   => $auth_conf,
    notify => Service["pe-${container}"],
  }

  if $compile_master {
    pe_hocon_setting { 'file-sync.repos.puppet-code.staging-dir':
      path    => "${confdir}/conf.d/file-sync.conf",
      setting => 'file-sync.repos.puppet-code.staging-dir',
      ensure  => absent,
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
    puppet_enterprise::trapperkeeper::bootstrap_cfg { 'filesystem-watch-service' :
      namespace => 'puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service',
    }
    pe_hocon_setting { 'file-sync.repos.puppet-code.staging-dir':
      path    => "${confdir}/conf.d/file-sync.conf",
      setting => 'file-sync.repos.puppet-code.staging-dir',
      value   => $file_sync_staging_dir,
    }
    file { $file_sync_staging_dir:
      ensure => 'directory',
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
                          ["=", ["node","active"], true]]]])) |$master| { $master['certname'] }
    } else {
      $masters_in_puppetdb = []
    }
    # This may include machines with client tools (eg code manager cli)
    $certs_authorized_to_communicate_with_file_sync = pe_sort(pe_unique(pe_union($authorized_certs, $masters_in_puppetdb)))

    # These are only masters compiling puppet code
    $file_sync_clients = pe_sort(pe_unique(pe_union([$certname], $masters_in_puppetdb)))

    pe_hocon_setting { 'file-sync.client.client-certnames':
      path    => "${confdir}/conf.d/file-sync.conf",
      setting => 'file-sync.client-certnames',
      value   => $file_sync_clients,
      type    => 'array',
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
}
