class puppet_enterprise::params {
  $database_listen_addresses      = '*'
  $database_port                  = 5432
  $postgres_version               = '9.4'

  # Postgres Settings
  # this number was taken from the pe-puppetdb module
  $reserved_non_postgresql_memory_in_bytes = 536870912
  $maintenance_work_mem                    = '256MB'
  $wal_buffers                             = '8MB'
  $work_mem                                = '4MB'
  $checkpoint_segments                     = '16'
  $log_min_duration_statement              = '5000'
  $max_connections                         = 200

  $memorysize_in_bytes = pe_to_bytes($::memorysize)
  # Saving a mult operation: (1024*1024) => 1048576
  $memorysize_in_mb = $memorysize_in_bytes / 1048576
  $avail_mem_in_mb = ($memorysize_in_bytes - $reserved_non_postgresql_memory_in_bytes) / 1048576

  # set a min if too low
  $ecs_value = pe_max((($avail_mem_in_mb * 3) / 5), 128)
  $effective_cache_size = "${$ecs_value}MB"

  # Maximum value: 4096, Minimum value: 32
  $sb_value = pe_max(pe_min((($avail_mem_in_mb * 1) / 4), 4096), 32)
  $shared_buffers = "${$sb_value}MB"

  # Where the license key will be written to on all managed nodes.
  $dest_license_key_path = '/etc/puppetlabs/license.key'

  $ssl_dir = $::osfamily ? {
    'windows' => "${::common_appdata}/PuppetLabs/puppet/etc/ssl",
    default   => '/etc/puppetlabs/puppet/ssl',
  }
  $localcacert = "${ssl_dir}/certs/ca.pem"
  $hostcrl     = "${ssl_dir}/crl.pem"

  $plaintext_address = '127.0.0.1'
  $ssl_address       = '0.0.0.0'

  $puppetdb_confdir               = '/etc/puppetlabs/puppetdb/conf.d'
  $puppetdb_database_name         = 'pe-puppetdb'
  $puppetdb_database_user         = 'pe-puppetdb'
  $puppetdb_database_password     = ''
  $puppetdb_gc_interval           = '60'
  $puppetdb_node_purge_ttl        = '0s'
  $puppetdb_node_ttl              = '7d'
  $puppetdb_report_ttl            = '14d'
  $puppetdb_listen_port           = '8080'
  $puppetdb_ssl_listen_port       = '8081'
  $puppetdb_ssl_dir               = '/etc/puppetlabs/puppetdb/ssl'
  $puppetdb_auto_configure_sync   = false

  $console_ssl_listen_port = 443
  $console_services_listen_port     = '4430'
  $console_services_ssl_listen_port = '4431'

  $console_services_api_listen_port     = '4432'
  $console_services_api_ssl_listen_port = '4433'

  $activity_url_prefix           = '/activity-api'
  $activity_database_name        = 'pe-activity'
  $activity_database_user        = 'pe-activity'
  $activity_database_password    = ''

  $classifier_url_prefix             = '/classifier-api'
  $classifier_synchronization_period = 600
  $classifier_prune_threshold        = 7
  $classifier_database_name          = 'pe-classifier'
  $classifier_database_user          = 'pe-classifier'
  $classifier_database_password      = ''

  $rbac_url_prefix               = '/rbac-api'
  $rbac_database_name            = 'pe-rbac'
  $rbac_database_user            = 'pe-rbac'
  $rbac_database_password        = ''

  $orchestrator_database_name     = 'pe-orchestrator'
  $orchestrator_database_user     = 'pe-orchestrator'
  $orchestrator_database_password = ''

  $jdbc_ssl_properties   = "?ssl=true&sslfactory=org.postgresql.ssl.jdbc4.LibPQFactory&sslmode=verify-full&sslrootcert=${localcacert}"

  # pcp-broker defaults
  if ! pe_is_integer($::processorcount) or ($::processorcount + 0) <= 1 {
    $pcp_broker_accept_consumers = 2
    $pcp_broker_delivery_consumers = 2
  } else {
    $pcp_broker_accept_consumers   = $::processorcount
    $pcp_broker_delivery_consumers = $::processorcount
  }

  # pxp-agent paths
  case $::operatingsystem {
    'windows':{
      $pxp_agent_base = "${::common_appdata}/PuppetLabs/pxp-agent"
      $pxp_agent_etc = "${pxp_agent_base}/etc"
    }
    default:{
      $pxp_agent_etc = '/etc/puppetlabs/pxp-agent'
    }
  }

  # Pxp isn't available before version 4.3.0. To prevent errors in puppet agent
  # runs on systems with a previous version, opt out of managing pxp related
  # resources.
  $pxp_compatible = versioncmp($::puppetversion, '4.3.0') >= 0

  # MCO Paths
  case $::operatingsystem {
    'windows':{
      $mco_base               = "${::common_appdata}/PuppetLabs/mcollective"
      $mco_etc                = "${mco_base}/etc"
      $mco_plugin_userdir     = "${mco_base}/plugins"
      $mco_old_plugin_userdir = "${mco_etc}/plugins"
      $mco_plugin_libdir      = "${mco_old_plugin_userdir};${mco_plugin_userdir}"
    }
    default:{
      $mco_base               = '/opt/puppetlabs/mcollective'
      $mco_etc                = '/etc/puppetlabs/mcollective'
      # This is the default AIO puppet-agent mcollective user plugin directory.
      $mco_plugin_userdir     = "${mco_base}/plugins"
      # This is the old mcollective user plugin directory.
      $mco_old_plugin_userdir = "/opt/puppet/libexec/mcollective"
      # This is the path set in mco client.cfg and server.cfg libdir so that
      # mco can find plugins. The /opt/puppet/libexec/mcollective path is the
      # old plugin path which is being left in place in case user plugins were
      # added to this path prior to upgrading.
      $mco_plugin_libdir      = "${mco_old_plugin_userdir}:${mco_plugin_userdir}"
    }
  }

  $mco_logdir = $::operatingsystem ? {
    'windows' => "${::common_appdata}/PuppetLabs/mcollective/var/log",
    default   => '/var/log/puppetlabs'
  }
  $mco_server_log_file = "${mco_logdir}/mcollective.log"
  $mco_audit_log_file  = "${mco_logdir}/mcollective-audit.log"

  # MCO config
  $mco_create_client_user   = true
  $mco_identity             = $::clientcert
  $mco_registerinterval     = 600
  $mco_require_actionpolicy = '1'
  $mco_fact_cache_time      = 300
  $mco_loglevel             = 'info'

  # MCO SSL credentials information
  $mco_ssl_dir                      = "${mco_etc}/ssl"
  $mco_clients_cert_dir             = "${mco_ssl_dir}/clients"
  $mco_credentials_path             = '/etc/puppetlabs/mcollective/credentials'
  $mco_console_keypair_name         = 'pe-internal-puppet-console-mcollective-client'
  $mco_console_client_name          = 'puppet-dashboard'
  $mco_peadmin_keypair_name         = 'pe-internal-peadmin-mcollective-client'
  $mco_peadmin_client_name          = 'peadmin'
  $mco_server_keypair_name          = 'pe-internal-mcollective-servers'
  $mco_server_name                  = 'mcollective'

  # AMQ / Stomp
  $activemq_brokername          = $::clientcert
  $activemq_brokers             = [$::settings::server]
  $activemq_enable_ssl          = true
  $activemq_ssl_protocols       = [ 'TLSv1','TLSv1.1','TLSv1.2' ]
  $activemq_enable_web_console  = false
  $activemq_heap_mb             = '512'
  $activemq_java_ks_password    = 'puppet'
  $activemq_java_ts_password    = 'puppet'
  $activemq_network_ttl         = '2'
  $openwire_protocol            = 'ssl'
  $openwire_port                = 61616
  $stomp_password               = pe_chomp(file($mco_credentials_path, '/dev/null'))
  $stomp_protocol               = 'stomp+ssl'
  $stomp_user                   = 'mcollective'
  $activemq_transport_options = { 'transport.enabledProtocols' => pe_join($activemq_ssl_protocols, ",") }

  $defaults_dir = $::osfamily ? {
    'Debian'      => '/etc/default',
    /RedHat|Suse/ => '/etc/sysconfig',
    default       => undef,
  }

  $puppetdb_java_args = {
    'Xmx' => '256m',
    'Xms' => '256m',
  }

  $activemq_heartbeat_interval = 120

  if $memorysize_in_mb <= 1024 {
    $puppetserver_memory = '512m'
  } elsif $memorysize_in_mb <= 2048 {
    $puppetserver_memory = '1024m'
  } else {
    $puppetserver_memory = '2048m'
  }

  $puppetserver_java_args = {
    'Xmx' => $puppetserver_memory,
    'Xms' => $puppetserver_memory,
  }

  $console_services_java_args = {
    'Xmx' => '256m',
    'Xms' => '256m',
  }

  $orchestrator_java_args = {
    'Xmx' => '192m',
    'Xms' => '192m',
  }

  # add 0 to processorcount to work around 3.3.2 agents reporting the fact
  # as a string.
  if ! pe_is_integer($::processorcount) or ($::processorcount + 0) <= 1 {
    $passenger_pool_size = 4
  } else {
    $passenger_pool_size = $::processorcount * 4
  }

  # Puppet user by OS
  case $::operatingsystem {
    'AIX':{
      $puppet_user    = 'puppet'
      $puppet_group   = 'puppet'
    }
    default:{
      $puppet_user    = 'pe-puppet'
      $puppet_group   = 'pe-puppet'
    }
  }

  # Root user by OS
  $root_user = $::operatingsystem ? {
    'windows' => 'S-1-5-32-544', # Adminstrators
    default => 'root',
  }

  # Root group by OS
  $root_group = $::operatingsystem ? {
    'AIX' => 'system',
    'windows' => 'S-1-5-32-544', # Adminstrators
    'Darwin' => 'wheel',
    default => 'root',
  }

  # Root mode by OS
  $root_mode = $::operatingsystem ? {
    'windows' => '0664',         # Both user and group need write permission
    default => '0644',
  }

  # We would like to run silent with regards to the deprecation warning around
  # the package type's allow_virtual parameter. However, the allow_virtual
  # parameter did not exist prior to Puppet 3.6.1. Therefore we have a few
  # places where we need to set package resource defaults dependent on what
  # version of Puppet the client is running (so long as we support clients
  # older than 3.6.1). Performing the calculation here as it is used in more
  # than one location elsewhere in the module.
  $supports_allow_virtual = versioncmp($::puppetversion,'3.6.1') >= 0
  $allow_virtual_default = $supports_allow_virtual ? {
    true  => true,
    false => undef,
  }

  # Becuase the default for OracleLinux is up2date...
  if $::operatingsystem == 'OracleLinux' {
    $package_options = {
      provider      => 'yum',
      allow_virtual => $allow_virtual_default,
    }
  } elsif $::operatingsystem == 'SLES' {
    $package_options = {
      provider      => 'zypper',
      allow_virtual => $allow_virtual_default,
    }
  } else {
    $package_options = {
      allow_virtual => $allow_virtual_default,
    }
  }

  # Client tool configuration
  $client_tools_confdir = "/etc/puppetlabs/client-tools"
}
