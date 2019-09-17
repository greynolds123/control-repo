# Main type for installing and setting up a pe-razor-server
#
#
define pe_razor::server(
  $protect_new_nodes,
  $repo_store_root,
  $task_path,
  $broker_path,
  $hook_path,
  $hook_execution_path,
  $match_nodes_on,
  $dbpassword,
  $pe_tarball_base_url,
  $server_http_port,
  $server_https_port,
  $microkernel_url,
  $microkernel_debug_level,
  $microkernel_kernel_args,
  $microkernel_extension_zip,
  $database_url,
  $auth_enabled,
  $auth_config,
  $secure_api,
  $checkin_interval,
  $facts_blacklist,
  $facts_match_on,
  $api_config_blacklist,
  $enable_windows_smb,
  $auth_allow_localhost,
  $store_hook_input,
  $store_hook_output,
  Optional[String] $default_postgresql_database = undef
){
  include pe_razor::params

  $pe_version = pe_build_version()
  pe_razor::server::repo { 'razor':
    target              => "${pe_razor::params::data_dir}/packages/${pe_version}/razor-repo",
    pe_tarball_base_url => $pe_tarball_base_url,
  }

  $_razor_packages = [
    'pe-razor-server',
    'pe-java',
  ]
  package { $_razor_packages:
    ensure  => latest,
    require => Pe_razor::Server::Repo['razor'],
    notify  => [Pe_razor::Server::Config['razor'],
                Service['pe-razor-server']]
  }

  $package_refs = [
    Package['pe-razor-server'],
    Package['pe-java'],
    Package['postgresql-server'],
    Package['postgresql-client'],
    Package['postgresql-contrib'],
  ]

  pe_razor::server::config { 'razor':
    protect_new_nodes         => $protect_new_nodes,
    repo_store_root           => $repo_store_root,
    task_path                 => $task_path,
    broker_path               => $broker_path,
    hook_path                 => $hook_path,
    hook_execution_path       => $hook_execution_path,
    match_nodes_on            => $match_nodes_on,
    pe_tarball_base_url       => $pe_tarball_base_url,
    server_http_port          => $server_http_port,
    server_https_port         => $server_https_port,
    microkernel_url           => $microkernel_url,
    microkernel_debug_level   => $microkernel_debug_level,
    microkernel_kernel_args   => $microkernel_kernel_args,
    microkernel_extension_zip => $microkernel_extension_zip,
    database_url              => $database_url,
    auth_enabled              => $auth_enabled,
    auth_config               => $auth_config,
    secure_api                => $secure_api,
    checkin_interval          => $checkin_interval,
    facts_blacklist           => $facts_blacklist,
    facts_match_on            => $facts_match_on,
    api_config_blacklist      => $api_config_blacklist,
    auth_allow_localhost      => $auth_allow_localhost,
    store_hook_input          => $store_hook_input,
    store_hook_output         => $store_hook_output,
    require                   => $package_refs,
  }

  $psql_info = $facts['pe_postgresql_info']

  if $psql_info and $psql_info['installed_server_version'] == '9.4' {
    pe_install::stop_service { 'Stop pe-razor-server':
      service          => 'pe-razor-server',
      before_reference => [Class['pe_install::upgrade::postgres']],
    }
    class { 'pe_install::upgrade::postgres':
      old_postgres_version => '9.4',
      new_postgres_version => '9.6',
      require_pglogical    => false,
    }
    $default_database = $default_postgresql_database
  } elsif $psql_info and !('pe-postgresql-common' in pe_keys($psql_info['installed_packages'])) {
    $installed_server_version = $psql_info['installed_server_version']
    $pe_postgresql_pid_file = "${pe_razor::params::pgsqldir}/${installed_server_version}/data/postmaster.pid"
    pe_install::stop_service { 'Stop pe-postgresql before upgrade to pe-postgresql96':
      service          => 'pe-postgresql',
      stop_command     =>  "kill -INT `head -1 ${pe_postgresql_pid_file}` && while [ -e ${pe_postgresql_pid_file} ]; do sleep 1; done",
      before_reference => [Pe_razor::Server::Database['razor']],
    }
    -> class { 'puppet_enterprise::postgresql::remove':
      before => [
        Package['postgresql-client'],
        Package['postgresql-server'],
        Package['postgresql-contrib'],
      ],
    }
    contain puppet_enterprise::postgresql::remove
    $default_database = pe_pick($default_postgresql_database, 'pe-postgres')
  } else {
    $default_database = $default_postgresql_database
  }

  $setup_cert_auth = $database_url == $pe_razor::params::database_url

  pe_razor::server::database { 'razor':
    dbpassword       => $dbpassword,
    setup_cert_auth  => $setup_cert_auth,
    default_database => $default_database,
    require          => Pe_razor::Server::Config['razor'],
  }

  if $setup_cert_auth {
    pe_razor::server::certs { "set-up pe-razor-server's client side certs to connect to the DB" :
      ca_cert     => $pe_razor::params::pgsql_server_cert,
      ca_key      => $pe_razor::params::pgsql_server_key,
      # By default, Postgres' cert-auth requires the common name (CN)
      # of the certificate to be the database username.
      common_name => 'razor',
      require     => Pe_razor::Server::Database['razor'],
      before      => Exec['migrate the razor database'],
    }
  }

  pe_razor::server::torquebox { 'razor':
    require => [
      Pe_razor::Server::Database['razor'],
      Package['pe-razor-server']
    ],
  }

  exec { 'migrate the razor database':
    # Allow up to 60 minutes for this to run.  It should be super-fast, right
    # now, but if we get large installations and a migration that needs to do
    # substantial work and can't be lazy-evaluated, this will help.
    provider => shell,
    timeout  => 3600,
    command  => template('pe_razor/do-migrate.sh.erb'),
    unless   => template('pe_razor/do-check-migrate.sh.erb'),
    notify   => [
      Exec['redeploy the razor application to torquebox'],
      Service['pe-razor-server'],
    ],
    require  => Pe_razor::Server::Database['razor']
  }

  exec { 'unpack the microkernel':
    provider => shell,
    timeout  => 3600,
    command  => template('pe_razor/install-mk.sh.erb'),
    path     => '/usr/local/bin:/bin:/usr/bin',
    creates  => "${pe_razor::params::repo_dir}/microkernel/initrd0.img"
  }

  service { 'pe-razor-server':
    ensure  => running,
    enable  => true,
    require => [Pe_razor::Server::Config['razor'],
                Exec['deploy the razor application to torquebox']]
  }

  if ($enable_windows_smb) {
    pe_razor::samba {'razor':
      require => File[$pe_razor::params::repo_dir],
    }
  }
}
