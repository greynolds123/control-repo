# = Class: pe_r10k::params
#
# This class provides lookup of values for R10k configuration within Puppet Enterprise
#
# == Variable Use
#
# === [*configfile*]
#
# The path to R10k's configuration file. In Puppet Enterprise this is
# /etc/puppetlabs/r10k/r10k.yaml. Before R10k was added to Puppet Enterprise,
# R10k used /etc/r10k.yaml as its configuration file. If /etc/r10k.yaml exists
# and /etc/puppetlabs/r10k/r10k.yaml does not, then the settings in /etc/r10k.yaml
# will be used. If both files exist, the settings in /etc/puppetlabs/r10k/r10k.yaml
# will be used and a warning will be raised by R10k.
#
# * default value: /etc/puppetlabs/r10k/r10k.yaml
#
# === [*cachedir*]
#
# The path to the directory used by R10k for caching data (repositories for
# modules in the Puppetfile)
#
# * default value: $vardir/r10k
#
# === [*proxy*]
#
# Default proxy server to use for all HTTP operations.
#
# * default value: undef
#
# === [*remote*]
#
# The remote control repository URL used to configure R10k to generate dynamic
# directory environments for Puppet. This variable is only used if $sources is
# not being used
#
# * default value: undef
#
# === [*sources*]
#
# A hash containing data sources to be used by R10k. This parameter is used if
# you are managing more than just Puppet environments (for example, if Hiera
# data is also being managed with its own control repository). If $sources
# has been set, $remote and $r10k_basedir is not used.
#
# * default value: undef
#
# === [*r10k_basedir*]
#
# The basedir to where R10k will generate directory environments based on
# branches of the control repository ($remote). If $sources has been set,
# $r10k_basedir and $remote is not used.
#
# * default value: /etc/puppetlabs/puppet/environments
#
## === [*r10k_user*]
#
# The user with permissions to access R10k's configuration file(s) and whom
# will be executing the r10k binary
#
# * default value: root (0)
#
## === [*r10k_group*]
#
# The group with access to R10k's configuration file(s)
#
# * default value: root (0)
#
## === [*git_settings*]
#
# Any Git specific settings (Git provider, SSH username, SSH private key)
# for r10k.
#
# * default value: {}
#
## === [*deploy_settings*]
#
# Any deploy specific settings for r10k, currently limited to the write_lock setting.
#
# * default value: {}
#
# === [*postrun*]
#
# An optional command that will be run after r10k finishes deploying environments.
# The command must be an array of strings that will be used as an argument vector.
#
# * example: ['/usr/bin/curl', '-F', 'deploy=done', 'http://my-app.site/endpoint']
# * default value: undef
#
## === [*forge_settings*]
#
# Any Forge specific settings (forgeurl, proxy) for r10k.
#
# * default value: {}
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
class pe_r10k::params {
  $configfile   = '/etc/puppetlabs/r10k/r10k.yaml'
  $cachedir     = "${::settings::vardir}/r10k"
  $proxy        = undef
  $remote       = undef
  $sources      = undef
  $r10k_basedir = $::settings::environmentpath
  $r10k_user = '0'
  $r10k_group = '0'
  $git_settings = {}
  $forge_settings = {}
  $deploy_settings = {}
  $postrun = undef
}
