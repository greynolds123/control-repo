# == Class: pe_r10k
#
# This class will manage the configuration of R10k for Puppet Enterprise
#
# == Parameters
#
# If a parameter is not specified, it will default to the value in
# pe_r10k::params. See that class for values
#
# [*configfile*]
#
# [*cachedir*]
#
# [*proxy*]
#
# [*remote*]
#
# [*sources*]
#
# [*git_settings*]
#
# [*forge_settings*]
#
# [*deploy_settings*]
#
# [*postrun*]
#
# [*r10k_basedir*]
#
# [*r10k_user*]
#
# [*r10k_group*]
#
#
# == Examples
#
#   # Manage R10k with defaults and a provided control repository remote
#   class { 'pe_r10k':
#     remote => 'https://github.com/glarizza/puppet_repository.git',
#   }
#
#   # Manage R10k with a provided control repository remote and alternate basedir
#   class { 'pe_r10k':
#     remote       => 'https://github.com/glarizza/puppet_repository.git',
#     r10k_basedir => '/etc/puppetlabs/puppet/my_environments',
#   }
#
#   # Manage R10k with multiple sources
#   class { 'pe_r10k':
#     sources => {
#       'puppet' => {
#         'basedir' => '/etc/puppetlabs/puppet/environments',
#         'remote'  => 'https://github.com/glarizza/puppet_repository.git',
#       },
#       'hiera' => {
#         'basedir' => '/etc/puppetlabs/puppet/hiera',
#         'remote'  => 'https://github.com/glarizza/hiera_environment',
#       },
#     }
#   }
#
#
#
# == Copyright
#
# Copyright 2015 Puppet Labs Inc.
#
# == License
#
# Licensed under the same terms as Puppet Enterprise. Please refer to the
# LICENSE.pdf file included with the Puppet Enterprise distribution for
# licensing information.
#
class pe_r10k (
  $configfile      = $pe_r10k::params::configfile,
  $cachedir        = $pe_r10k::params::cachedir,
  $proxy           = $pe_r10k::params::proxy,
  $remote          = $pe_r10k::params::remote,
  $sources         = $pe_r10k::params::sources,
  $git_settings    = $pe_r10k::params::git_settings,
  $forge_settings  = $pe_r10k::params::forge_settings,
  $deploy_settings = $pe_r10k::params::deploy_settings,
  $postrun         = $pe_r10k::params::postrun,
  $r10k_basedir    = $pe_r10k::params::r10k_basedir,
  $r10k_user       = $pe_r10k::params::r10k_user,
  $r10k_group      = $pe_r10k::params::r10k_group,
) inherits pe_r10k::params {

  class { '::pe_r10k::config':
    configfile      => $configfile,
    cachedir        => $cachedir,
    proxy           => $proxy,
    remote          => $remote,
    sources         => $sources,
    git_settings    => $git_settings,
    forge_settings  => $forge_settings,
    deploy_settings => $deploy_settings,
    postrun         => $postrun,
    r10k_basedir    => $r10k_basedir,
    r10k_user       => $r10k_user,
    r10k_group      => $r10k_group,
    require         => Class['pe_r10k::package'],
  }

  include pe_r10k::package
}
