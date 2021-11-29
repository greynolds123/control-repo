class pe_razor(
  $protect_new_nodes   = true,
  $repo_store_root     = $pe_razor::params::repo_dir,
  $task_path           = "${pe_razor::params::razor_etc}/tasks:tasks",
  $broker_path         = "${pe_razor::params::razor_etc}/brokers:brokers",
  $hook_path           = "${pe_razor::params::razor_etc}/hooks:hooks",
  $hook_execution_path = $pe_razor::params::puppet_bin_dir,
  $match_nodes_on      = ['mac'],
  $dbpassword          = 'razor',
  $pe_tarball_base_url = 'https://pm.puppetlabs.com/puppet-enterprise',
  $server_http_port    = 8150,
  $server_https_port   = 8151,
  # The microkernal url expects a x.y.z version number.
  # The pe_version fact no longer exists in 2015.2.0, until the integration team can
  # create a new function to return just the x.y.z, strip the pe_build (x.y.z-rc0-gitsha)
  $microkernel_url     = "https://pm.puppetlabs.com/puppet-enterprise-razor-microkernel-${pe_razor::params::pe_build}.tar",
  # Valid values for the kernel are 'quiet' and 'debug' or <nothing>.
  $microkernel_debug_level = 'quiet',
  $microkernel_kernel_args = '',
  $microkernel_extension_zip = "${pe_razor::params::razor_etc}/mk-extension.zip",
  $database_url        = $pe_razor::params::database_url,
  $auth_enabled        = false,
  $auth_config         = "${pe_razor::params::razor_etc}/shiro.ini",
  $secure_api          = true,
  $checkin_interval    = 15,
  $facts_blacklist     = ['domain', 'filesystems', 'fqdn', 'hostname', 'id',
                          '/kernel.*/', 'memoryfree', 'memorysize',
                          'memorytotal', '/operatingsystem.*/', 'osfamily',
                          'path', 'ps', 'rubysitedir', 'rubyversion', 'selinux',
                          'sshdsakey', '/sshfp_[dr]sa/', 'sshrsakey', '/swap.*/',
                          'timezone', '/uptime.*/'],
  $facts_match_on      = [],
  $api_config_blacklist = ['database_url', 'facts.blacklist'],
  $enable_windows_smb  = false,
  $auth_allow_localhost = false,
  $store_hook_input = false,
  $store_hook_output = false,
  Optional[String] $default_postgresql_database = undef
) inherits pe_razor::params {
  # Assert the platform being used is one validated for this version of Razor.
  if !($pe_razor::params::is_on_el and $pe_razor::params::is_valid_version) {
    fail('Sorry, this version of Razor is only available for Red Hat Enterprise Linux 6 and 7.')
  }

  File {
    ensure => file,
    owner  => 'pe-razor',
    group  => 'pe-razor',
    mode   => '0640'
  }

  pe_razor::server { 'razor':
    protect_new_nodes           => $protect_new_nodes,
    repo_store_root             => $repo_store_root,
    task_path                   => $task_path,
    broker_path                 => $broker_path,
    hook_path                   => $hook_path,
    hook_execution_path         => $hook_execution_path,
    match_nodes_on              => $match_nodes_on,
    dbpassword                  => $dbpassword,
    pe_tarball_base_url         => $pe_tarball_base_url,
    server_http_port            => $server_http_port,
    server_https_port           => $server_https_port,
    microkernel_url             => $microkernel_url,
    microkernel_debug_level     => $microkernel_debug_level,
    microkernel_kernel_args     => $microkernel_kernel_args,
    microkernel_extension_zip   => $microkernel_extension_zip,
    database_url                => $database_url,
    auth_enabled                => $auth_enabled,
    auth_config                 => $auth_config,
    secure_api                  => $secure_api,
    checkin_interval            => $checkin_interval,
    facts_blacklist             => $facts_blacklist,
    facts_match_on              => $facts_match_on,
    api_config_blacklist        => $api_config_blacklist,
    enable_windows_smb          => $enable_windows_smb,
    auth_allow_localhost        => $auth_allow_localhost,
    store_hook_input            => $store_hook_input,
    store_hook_output           => $store_hook_output,
    default_postgresql_database => $default_postgresql_database,
  }
}
