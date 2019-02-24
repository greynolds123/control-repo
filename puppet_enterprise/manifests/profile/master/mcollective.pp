# This class should be applied to all puppet enterprise masters.
#
# This class is called internally by the Master profile, and should not be called
# directly.
#
# Due to the way mcollective security currently works, all compiling masters
# must have a copy of the following files:
# - A shared mco keypair
# - The peadmin clients keypair
# - The dashboard clients keypair
# - The stomp password
#
# These files are generated during the initial install of the first
# PE master. When classifying additional masters, the first master will create
# the catalog with these files in it, which the second master will then use to create
# these files on disk. Then when an agent checks in and asks for any of the files, it will
# have access to them, regardless of the compiling master.
#
# @param user_clients [Array]
#   If you have created additional MCO clients that you would like PE to manage,
#   include the names in this list. The certificates for these additional clients should
#   already exist on the CA. In a multi-master environment, you will need to manually copy the
#   certs over from the CA node, or temporarily change the additional master's to use the CA
#   as the compiling master.
#
class puppet_enterprise::profile::master::mcollective(
  $user_clients = undef,
){
  include puppet_enterprise::params
  include puppet_enterprise::mcollective::service

  # MCO Credentials
  file { $puppet_enterprise::params::mco_credentials_path:
    content => file($puppet_enterprise::params::mco_credentials_path, '/dev/null'),
    owner   => $puppet_enterprise::params::puppet_user,
    group   => $puppet_enterprise::params::puppet_group,
    mode    => '0600',
    notify  => Service['mcollective'],
  }

  $keypairs = [
    $puppet_enterprise::params::mco_server_keypair_name,
    $puppet_enterprise::params::mco_console_keypair_name,
    $puppet_enterprise::params::mco_peadmin_keypair_name
  ]

  $_keypairs = $user_clients ? {
    undef   => $keypairs,
    default => pe_union($keypairs, $user_clients)
  }

  puppet_enterprise::master::keypair { $_keypairs: }
}
