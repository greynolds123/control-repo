# MCollective and Activemq have been removed in 2019.0
# This is a stub class to warn if the PE MCollective peadmin class is still being applied.
class puppet_enterprise::profile::mcollective::peadmin(
  $activemq_brokers        = undef,
  $collectives             = ['mcollective'],
  $create_user             = undef,
  $home_dir                = '/var/lib/peadmin',
  Optional[String] $mco_loglevel     = undef,
  $main_collective         = 'mcollective',
  $randomize_activemq      = false,
  $stomp_password          = undef,
  $stomp_port              = undef,
  $stomp_user              = undef,
  Optional[Boolean] $manage_symlinks = undef,
  Optional[Integer]       $mco_discovery_timeout       = undef,
  Optional[Integer]       $mco_publish_timeout       = undef,
  Optional[Array[String]] $mco_arbitrary_client_config = undef,
) {
  notify { 'puppet_enterprise::profile::mcollective::peadmin-still-applied':
    message  => 'MCollective and Activemq have been removed from PE 2019.0+, but the puppet_enterprise::profile::mcollective::peadmin class is still being applied. Please remove this class from your classification.',
    loglevel => 'warning',
  }
}
