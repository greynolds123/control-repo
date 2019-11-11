# MCollective and Activemq have been removed in 2019.0
# This is a stub class to warn if the PE MCollective agent class is still being applied.
class puppet_enterprise::profile::mcollective::agent (
  Optional[Array[String]] $activemq_brokers = undef,
  Optional[String]  $allow_no_actionpolicy  = undef,
  Hash[String, Array[String]] $allowed_actions = {'package' => ['status', 'update', 'yum_clean', 'apt_update',
                                                                'yum_checkupdates', 'apt_checkupdates', 'checkupdates']},
  Array[String] $collectives      = ['mcollective'],
  String  $main_collective        = 'mcollective',
  Boolean $manage_metadata_cron   = true,
  Optional[Integer] $mco_fact_cache_time    = undef,
  Optional[String]  $mco_identity           = undef,
  Optional[String]  $mco_loglevel           = undef,
  Optional[Integer] $mco_registerinterval   = undef,
  Boolean $randomize_activemq     = false,
  Optional[String]  $stomp_password         = undef,
  Optional[Integer] $stomp_port             = undef,
  Optional[String]  $stomp_user             = undef,
  Optional[Array[String]] $mco_arbitrary_server_config = undef,
) {
  notify { 'puppet_enterprise::profile::mcollective::agent-still-applied':
    message  => 'MCollective and Activemq have been removed from PE 2019.0+, but the puppet_enterprise::profile::mcollective::agent class is still being applied. Please remove this class from your classification.',
    loglevel => 'warning',
  }
}
