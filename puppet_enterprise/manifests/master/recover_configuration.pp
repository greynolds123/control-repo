# Install a cron job to run recover_configuration
#
# @summary Installs a cron job to run puppet 
#          infra recover_configuration
#
# @param recover_configuration_interval how often the recover_configuration
#        cron job will run.  Set to 0 to remove the cron job.
# @param recover_configuration_interval_offset a random number between 1 and
#        59.  Makes sure the start time of the cron job is random.  If
#        recover_configuration_interval is 0 then the offset doesn't matter
#        so we set the offset to 1 to allow the catalog to compile.
# @param pe_environment the environment your PE infrastructure nodes run in.
#        This makes sure that hieradata is collected from the correct environment.
# @example
#   include puppet_enterprise::master::recover_configuration
class puppet_enterprise::master::recover_configuration (
  Integer[0,1440] $recover_configuration_interval      = 30,
  Integer[0,59] $recover_configuration_interval_offset = fqdn_rand(pe_clamp(1,$recover_configuration_interval, 60)),
  String  $pe_environment = lookup(pe_install::install::classification::pe_node_group_environment, { 'default_value' => 'production' })
) {

  $log_file_path = '/var/log/puppetlabs/puppet_infra_recover_config_cron.log'
  $bin_dir   = $::puppet_enterprise::puppetlabs_bin_dir
  $cron_time = $recover_configuration_interval ? {
    0       => {},
    default => interval_and_offset_to_cron_time($recover_configuration_interval, $recover_configuration_interval_offset),
  }
  $recover_configuration_ensure = $recover_configuration_interval ? {
    0       => 'absent',
    default => 'present',
  }

  file { $log_file_path:
    ensure => file,
    mode   => '0640',
  }

  cron { 'puppet infra recover_configuration':
    ensure   => $recover_configuration_ensure,
    command  => "$(command -v bash) -c 'PATH=${bin_dir}:\$PATH PREV=\$(tail -10000 ${log_file_path}) DATE=\$(date +\\%Y-\\%m-\\%dT\\%H:\\%M:\\%S\\%:z) OUT=\$(${bin_dir}/puppet infrastructure recover_configuration --pe-environment ${pe_environment} 2>&1) && { echo \"\$PREV\"; echo -n \"\$DATE\"; echo \" \$OUT\"; } > ${log_file_path}'",
    user     => $puppet_enterprise::params::root_user,
    hour     => $cron_time['hour'],
    minute   => $cron_time['minute'],
    require  => File[$log_file_path],
  }
}
