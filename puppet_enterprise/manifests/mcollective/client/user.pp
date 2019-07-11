# Used for creating a local system user for use as an mcollective
# client.
#
# @example
#   puppet_enterprise::mcollective::client::user { 'peadmin': }
#
# @param user_name [String] The system users name.
# @param home_dir [String] The directory to use for the users home directory.
define puppet_enterprise::mcollective::client::user(
  $user_name = $title,
  $home_dir  = "/var/lib/${title}",
){

  $puppet_bin_dir = '/opt/puppetlabs/puppet/bin'

  pe_accounts::user { $user_name:
    ensure   => present,
    password => '!!',
    home     => $home_dir,
  }

  # Because the accounts module is managing the .bashrc, we use
  # .bashrc.custom, which is included by default in the managed .bashrc
  file { "${home_dir}/.bashrc.custom":
    ensure => file,
    owner  => $user_name,
    group  => $user_name,
    mode   => '0600',
  }

  pe_file_line { "${user_name}:path":
    ensure => present,
    path   => "${home_dir}/.bashrc.custom",
    line   => "export PATH=\"${puppet_bin_dir}:\${PATH}\"",
  }
}
