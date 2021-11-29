# == Class: pe_r10k::config
#
# This class will manage R10k's configuration (specifically r10k.yaml)
#
# == Parameters
#
# [*configfile*]
#
# [*cachedir*]
#
# [*remote*]
#
# [*sources*]
#
# [*git_settings*]

# [*postrun*]
#
# [*r10k_basedir*]
#
# [*r10k_user*]
#
# [*r10k_group*]
#
#
# Copyright 2015 Puppet Labs Inc.
#
# == License
#
# Licensed under the same terms as Puppet Enterprise. Please refer to the
# LICENSE.pdf file included with the Puppet Enterprise distribution for
# licensing information.
#
class pe_r10k::config (
  $configfile,
  $cachedir,
  $proxy,
  $remote,
  $sources,
  $git_settings,
  $forge_settings,
  $deploy_settings,
  $postrun,
  $r10k_basedir,
  $r10k_user,
  $r10k_group,
) {
  pe_validate_absolute_path($configfile)
  pe_validate_absolute_path($cachedir)

  if $postrun {
    pe_validate_array($postrun)
  }

  if $sources {
    pe_validate_hash($sources)
    $_sources = $sources
  }
  elsif $remote {
    pe_validate_absolute_path($r10k_basedir)
    pe_validate_string($remote)

    $_sources = {
      'puppet' => {
        'remote'  => $remote,
        'basedir' => $r10k_basedir,
      },
    }
  }
  else {
    $_sources = {}
  }

  file { 'r10k.yaml':
    ensure  => file,
    owner   => $r10k_user,
    group   => $r10k_group,
    mode    => '0644',
    path    => $configfile,
    content => template('pe_r10k/r10k.yaml.erb'),
  }
}
