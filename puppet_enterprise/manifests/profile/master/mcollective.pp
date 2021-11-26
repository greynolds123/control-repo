# MCollective and Activemq have been removed in 2019.0
# This is a stub class to warn if the PE Master mcollective class is still being applied.
class puppet_enterprise::profile::master::mcollective(
  $user_clients = undef,
) {
  notify { 'puppet_enterprise::profile::master::mcollective-still-applied':
    message  => 'MCollective and Activemq have been removed from PE 2019.0+, but the puppet_enterprise::profile::master::mcollective class is still being applied. Please remove this class from your classification.',
    loglevel => 'warning',
  }
}
