class puppet_enterprise::mcollective::cleanup {
  include puppet_enterprise::params

  # Clean up old PE MCO plugins
  # We do not remove the whole directories because a user may have installed
  # their own plugins to these directories.
  $mco_plugin_files = {
    'agent' => [
      'discovery.rb',
      'package.ddl', 'package.rb',
      'puppet.ddl', 'puppet.rb',
      'puppetral.ddl', 'puppetral.rb',
      'rpcutil.ddl', 'rpcutil.rb',
      'service.ddl', 'service.rb',
    ],
    'aggregate' => [
      'average.ddl', 'average.rb',
      'boolean_summary.ddl', 'boolean_summary.rb',
      'sum.ddl', 'sum.rb',
      'summary.ddl', 'summary.rb',
    ],
    'application' => [
      'completion.rb',
      'facts.rb',
      'find.rb',
      'help.rb',
      'inventory.rb',
      'package.rb',
      'ping.rb',
      'plugin.rb',
      'puppet.rb',
      'rpc.rb',
      'service.rb',
    ],
    'audit' => [
      'logfile.rb',
    ],
    'connector' => [
      'activemq.ddl', 'activemq.rb',
      'rabbitmq.ddl', 'rabbitmq.rb',
    ],
    'data' => [
      'agent_data.ddl', 'agent_data.rb',
      'collective_data.ddl', 'collective_data.rb',
      'fact_data.ddl', 'fact_data.rb',
      'fstat_data.ddl', 'fstat_data.rb',
      'puppet_data.ddl', 'puppet_data.rb',
      'resource_data.ddl', 'resource_data.rb',
      'service_data.ddl', 'service_data.rb',
    ],
    'discovery' => [
      'flatfile.ddl', 'flatfile.rb',
      'mc.ddl', 'mc.rb',
      'stdin.ddl', 'stdin.rb',
    ],
    'facts' => [
      'yaml_facts.rb',
    ],
    'registration' => [
      'meta.rb',
    ],
    'security' => [
      'sshkey.rb',
    ],
    'util' => [
      'package', 'puppet_agent_mgr', 'service',
      'actionpolicy.rb',
      'puppet_agent_mgr.rb',
      'puppet_server_address_validation.rb',
      'puppetrunner.rb',
    ],
    'validator' => [
      'puppet_resource_validator.ddl',
      'puppet_resource_validator.rb',
      'puppet_server_address_validator.ddl',
      'puppet_server_address_validator.rb',
      'puppet_tags_validator.ddl',
      'puppet_tags_validator.rb',
      'puppet_variable_validator.ddl',
      'puppet_variable_validator.rb',
      'service_name.ddl',
      'service_name.rb',
    ]
  }

  $mco_plugin_files.each |$dir, $files| {
    $files.each |$file| {
      file { "${::puppet_enterprise::params::mco_old_plugin_userdir}/mcollective/${dir}/${file}":
        ensure => absent,
        force  => true,
        notify => Service['mcollective'],
      }
    }
  }
}
