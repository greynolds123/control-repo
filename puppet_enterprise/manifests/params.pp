class puppet_enterprise::params {
  $database_listen_addresses      = '*'

  ######################
  # Postgresql Variables

  # The version of postgresql to be installed in the absence of any development
  # or testing overrides
  $default_postgres_version       = '9.6'

  # Settings (postgresql.conf)
  # this number was taken from the pe-puppetdb module
  $reserved_non_postgresql_memory_in_bytes = 536870912
  $wal_buffers                             = '8MB'
  $log_min_duration_statement              = '5000'

  # Variables that may vary by package version

  # *NOTE* this parameter is a development feature flag that is not suitable
  # for production. Do not use it for anything other than testing bidirectional
  # replication in development builds. It is currently only implemented as a
  # lookup(), and so must be set in pe.conf or another production hiera layer.
  # (This was done to prevent the parameter from showing up in the classifier)
  $postgres_version_override = lookup('puppet_enterprise::postgres_version_override', { 'default_value' => undef })

  # If puppet_enterprise::postgres_version_override is set at all, then we assume
  # that newer multi-version pe-postgresql<ver> packaging is being used. This only
  # matters when the version is 9.6, and we have to choose between installing and
  # configuring pe-postgresql versus pe-postgresl96 packages.
  $postgres_multi_version_packaging = true

  $postgres_version = pe_pick($postgres_version_override, $default_postgres_version)

  # This is a bit confusing, because '9.6' and '9.4' are both major versions, but
  # we need something to easily allow us to distinguish between 9 and 10+, so we're
  # splitting so as to be able to compare just the first number.
  $postgres_version_array = split($postgres_version, '\.')
  $postgres_first_version_number = Integer($postgres_version_array[0])

  # The newer pe-postgresql packages can be installed side by side, so the packages
  # have the version in the package name.
  $postgres_package_prefix = $postgres_multi_version_packaging ? {
    true    => "pe-postgresql${join($postgres_version_array,'')}",
    default => 'pe-postgresql',
  }

  # Determines which shared libraries to preload when starting up the postgresql
  # server. For versions before Postgresql 10, we include pglogical. For 10+
  # we do not, and rely on the logical replication provided natively.
  $postgres_shared_preload_libraries = ($postgres_first_version_number < 10) ? {
    true  => ['pglogical'],
    false => [],
  }

  # The original pe-postgresql packaging patches postgresql so that the
  # default database created and is 'pe-postgres', which matches the pe-postgres
  # user and slightly simplifies default connections using psql, for instance.
  #
  # We're experimenting with dropping that patch, and just relying on creating
  # a 'postgres' database in the multi-version packages.
  $postgresql_default_database = $postgres_multi_version_packaging ? {
    true    => 'postgres',
    default => 'pe-postgres',
  }

  # The actual OS package names for the various postgresql packages.
  # (May vary by postgres major version)
  $postgresql_client_package_name = $postgres_package_prefix
  $postgresql_server_package_name = "${postgres_package_prefix}-server"
  $postgresql_contrib_package_name = "${postgres_package_prefix}-contrib"
  $postgresql_pglogical_package_name = "${postgres_package_prefix}-pglogical"
  $postgresql_pgrepack_package_name = "${postgres_package_prefix}-pgrepack"

  # End Postgresql Variables
  ##########################

  # Ciphers chosen based on Mozilla recommendations.
  # Appropriate when we control all clients and know these ciphers will be supported.
  # https://wiki.mozilla.org/Security/Server_Side_TLS#Modern_compatibility
  $secure_ciphers = [
    'ECDHE-ECDSA-AES256-GCM-SHA384',
    'ECDHE-RSA-AES256-GCM-SHA384',
    'ECDHE-ECDSA-CHACHA20-POLY1305',
    'ECDHE-RSA-CHACHA20-POLY1305',
    'ECDHE-ECDSA-AES128-GCM-SHA256',
    'ECDHE-RSA-AES128-GCM-SHA256',
    'ECDHE-ECDSA-AES256-SHA384',
    'ECDHE-RSA-AES256-SHA384',
    'ECDHE-ECDSA-AES128-SHA256',
    'ECDHE-RSA-AES128-SHA256'
  ]

  # Appropriate when the service needs to be able to talk to a variety of browsers
  # https://wiki.mozilla.org/Security/Server_Side_TLS#Intermediate_compatibility_.28default.29
  $browser_ciphers = [
    'ECDHE-RSA-AES128-GCM-SHA256',
    'ECDHE-ECDSA-AES128-GCM-SHA256',
    'ECDHE-RSA-AES256-GCM-SHA384',
    'ECDHE-ECDSA-AES256-GCM-SHA384',
    'DHE-RSA-AES128-GCM-SHA256',
    'DHE-DSS-AES128-GCM-SHA256',
    'kEDH+AESGCM',
    'ECDHE-RSA-AES128-SHA256',
    'ECDHE-ECDSA-AES128-SHA256',
    'ECDHE-RSA-AES128-SHA',
    'ECDHE-ECDSA-AES128-SHA',
    'ECDHE-RSA-AES256-SHA384',
    'ECDHE-ECDSA-AES256-SHA384',
    'ECDHE-RSA-AES256-SHA',
    'ECDHE-ECDSA-AES256-SHA',
    'DHE-RSA-AES128-SHA256',
    'DHE-RSA-AES128-SHA',
    'DHE-DSS-AES128-SHA256',
    'DHE-RSA-AES256-SHA256',
    'DHE-DSS-AES256-SHA',
    'DHE-RSA-AES256-SHA',
    'ECDHE-RSA-DES-CBC3-SHA',
    'ECDHE-ECDSA-DES-CBC3-SHA',
    '!aNULL',
    '!eNULL',
    '!EXPORT',
    '!DES',
    '!RC4',
    '!MD5',
    '!PSK',
    '!aECDH',
    '!EDH-DSS-DES-CBC3-SHA',
    '!EDH-RSA-DES-CBC3-SHA',
    '!KRB5-DES-CBC3-SHA',
  ]

  $memorysize_in_bytes = pe_to_bytes($facts['memorysize'])
  # Saving a mult operation: (1024*1024) => 1048576
  $memorysize_in_mb = $memorysize_in_bytes / 1048576
  $avail_mem_in_mb = ($memorysize_in_bytes - $reserved_non_postgresql_memory_in_bytes) / 1048576
  $avail_mem_in_gb = $avail_mem_in_mb / 1024
  $work_mem_calculation = pe_clamp( 4, Integer((($avail_mem_in_gb / 8.0) + 0.5)), 16)

  $work_mem = "${work_mem_calculation}MB"

  # set a min if too low
  $ecs_value = pe_max((($avail_mem_in_mb * 3) / 5), 128)
  $effective_cache_size = "${$ecs_value}MB"

  # Maximum value: 4096, Minimum value: 32
  $sb_value = pe_max(pe_min((($avail_mem_in_mb * 1) / 4), 4096), 32)
  $shared_buffers = "${$sb_value}MB"

  # Where the license key will be written to on all managed nodes.
  $dest_license_key_path = '/etc/puppetlabs/license.key'

  # Puppet path
  case $facts['os']['family'] {
    'windows': {
      $ssl_dir = "${facts['common_appdata']}/PuppetLabs/puppet/etc/ssl"
      $confdir = "${facts['common_appdata']}/PuppetLabs/puppet/etc"
    }
    default: {
      $ssl_dir = '/etc/puppetlabs/puppet/ssl'
      $confdir = '/etc/puppetlabs/puppet'
    }
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
  $puppetdb_node_ttl              = '7d'
  $puppetdb_report_ttl            = '14d'
  $puppetdb_listen_port           = '8080'
  $puppetdb_ssl_listen_port       = '8081'
  $puppetdb_ssl_dir               = '/etc/puppetlabs/puppetdb/ssl'
  $puppetdb_auto_configure_sync   = false

  $console_ssl_listen_port              = 443
  $console_services_listen_port         = '4430'
  $console_services_ssl_listen_port     = '4431'
  $console_services_api_listen_port     = '4432'
  $console_services_api_ssl_listen_port = '4433'
  $console_services_query_cache_ttl     = 30000

  $activity_url_prefix           = '/activity-api'
  $activity_database_name        = 'pe-activity'
  $activity_database_password    = ''

  $classifier_url_prefix             = '/classifier-api'
  $classifier_synchronization_period = 600
  $classifier_prune_threshold        = 7
  $classifier_database_name          = 'pe-classifier'
  $classifier_database_password      = ''
  $classifier_allow_config_data      = lookup('puppet_enterprise_classifier_data_backend_present', {default_value => false})

  $rbac_url_prefix               = '/rbac-api'
  $rbac_database_name            = 'pe-rbac'
  $rbac_database_password        = ''

  $jdbc_ssl_properties   = "?ssl=true&sslfactory=org.postgresql.ssl.jdbc4.LibPQFactory&sslmode=verify-full&sslrootcert=${localcacert}"

  # pcp-broker defaults
  if ! pe_is_integer($facts['processorcount']) or ($facts['processorcount'] + 0) <= 1 {
    $pcp_broker_accept_consumers = 2
    $pcp_broker_delivery_consumers = 2
  } else {
    $pcp_broker_accept_consumers   = $facts['processorcount']
    $pcp_broker_delivery_consumers = $facts['processorcount']
  }

  # pxp-agent paths
  case $facts['os']['family'] {
    'windows':{
      $pxp_agent_base = "${facts['common_appdata']}/PuppetLabs/pxp-agent"
      $pxp_agent_etc = "${pxp_agent_base}/etc"
    }
    default:{
      $pxp_agent_etc = '/etc/puppetlabs/pxp-agent'
    }
  }

  # Pxp isn't available before version 4.3.0. To prevent errors in puppet agent
  # runs on systems with a previous version, opt out of managing pxp related
  # resources.
  $pxp_compatible = versioncmp($facts['puppetversion'], '4.3.0') >= 0

  # Guard puppet settings and pxp-agent settings for the versions they become
  # available. This is used prevent errors in puppet agent runs on systems with
  # a previous version.

  $spool_ttl_compatible = versioncmp($facts['puppetversion'], '4.4.0') >= 0
  $agent_failover_compatible = versioncmp($facts['puppetversion'], '4.6.0') >= 0
  $ping_interval_compatible = versioncmp($facts['puppetversion'], '4.9.0') >= 0
  $pcp_v2_compatible = versioncmp($facts['puppetversion'], '4.9.0') >= 0
  $_agent_version = pe_pick($facts['aio_agent_version'], '0.0.1')
  $pxp_task_compatible = versioncmp($_agent_version, '5.2.0') >= 0
  $task_cache_ttl_compatible = versioncmp($_agent_version, '5.4.0') >= 0
  # TODO: Remove the check for prerelease versions once 5.5.2 is released.
  $task_download_timeout_compatible = versioncmp($_agent_version, '5.5.2') >= 0 or $_agent_version !~ /^\d+\.\d+\.\d+$/
  $pxp_proxy_compatible = versioncmp($_agent_version, '5.5.4') >= 0

  $defaults_dir = $facts['os']['family'] ? {
    'Debian'      => '/etc/default',
    /RedHat|Suse/ => '/etc/sysconfig',
    default       => undef,
  }

  $puppetdb_java_args = {
    'Xmx' => '256m',
    'Xms' => '256m',
  }

  if $memorysize_in_mb <= 1024 {
    $puppetserver_memory = '512m'
    $puppetserver_code_cache = undef
  } elsif $memorysize_in_mb <= 2048 {
    $puppetserver_memory = '1024m'
    $puppetserver_code_cache = undef
  } else {
    $puppetserver_memory = '2048m'
    $puppetserver_code_cache = '512m'
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
    'Xmx' => '704m',
    'Xms' => '704m',
  }

  # Puppet user by OS
  case $facts['os']['family'] {
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
  $root_user = $facts['os']['family'] ? {
    'windows' => 'S-1-5-32-544', # Adminstrators
    default => 'root',
  }

  # Root group by OS
  $root_group = $facts['os']['family'] ? {
    'AIX' => 'system',
    'windows' => 'S-1-5-32-544', # Adminstrators
    'Darwin' => 'wheel',
    default => 'root',
  }

  # Root mode by OS
  $root_mode = $facts['os']['family'] ? {
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
  $supports_allow_virtual = versioncmp($facts['puppetversion'],'3.6.1') >= 0
  $allow_virtual_default = $supports_allow_virtual ? {
    true  => true,
    false => undef,
  }

  # Becuase the default for OracleLinux is up2date...
  if $facts['os']['name'] == 'OracleLinux' {
    $package_options = {
      provider      => 'yum',
      allow_virtual => $allow_virtual_default,
    }
  } elsif $facts['os']['name']== 'SLES' {
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
  $client_tools_confdir = '/etc/puppetlabs/client-tools'


  # PE Configuration Mount Point
  $enterprise_conf_path = '/etc/puppetlabs/enterprise'
  $enterprise_conf_mountpoint = 'enterprise_conf'

  # PE Inventory
  $package_inventory_enabled_file = $facts['os']['family'] ? {
    'windows' => "${facts['common_appdata']}/PuppetLabs/puppet/cache/state/package_inventory_enabled",
    default   => '/opt/puppetlabs/puppet/cache/state/package_inventory_enabled',
  }
}
