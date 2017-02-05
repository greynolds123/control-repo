# Class for distrubuting the mcollective plugins from the master to all servers.
#
# These plugins live in the lib dir of the module.
class puppet_enterprise::mcollective::server::plugins {

  File {
    owner  => $puppet_enterprise::params::root_user,
    group  => $puppet_enterprise::params::root_group,
    mode   => $puppet_enterprise::params::root_mode,
  }

  if $::osfamily != 'windows' {
    file { $puppet_enterprise::params::mco_base: ensure => directory }
  }
  file { $puppet_enterprise::params::mco_plugin_userdir: ensure => directory }

  # The modules file directory is laid out such that all the directories under
  # files/mcollective/plugins need to be placed in an 'mcollective' dir to
  # provide for their Ruby namespacing.
  $mco_plugin_namespace_dir = "${puppet_enterprise::params::mco_plugin_userdir}/mcollective"
  file { $mco_plugin_namespace_dir:
    ensure  => directory,
    recurse => remote,
    source  => 'puppet:///modules/puppet_enterprise/mcollective/plugins',
    notify  => Service['mcollective'],
  }

  include 'puppet_enterprise::mcollective::service'
}
