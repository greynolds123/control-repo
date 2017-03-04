# == Class: hiera
#
# This class handles installing the hiera.yaml for Puppet's use.
#
# === Parameters:
#
#   See README.
#
# === Actions:
#
# Installs either /etc/puppet/hiera.yaml or /etc/puppetlabs/puppet/hiera.yaml.
# Links /etc/hiera.yaml to the above file.
# Creates $datadir (if $datadir_manage == true).
#
# === Requires:
#
# puppetlabs-stdlib >= 4.3.1
#
# === Sample Usage:
#
#   class { 'hiera':
#     hierarchy => [
#       '%{environment}',
#       'common',
#     ],
#   }
#
# === Authors:
#
# Hunter Haugen <h.haugen@gmail.com>
# Mike Arnold <mike@razorsedge.org>
# Terri Haber <terri@puppetlabs.com>
# Greg Kitson <greg.kitson@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2012 Hunter Haugen, unless otherwise noted.
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
#
class hiera (
  $hierarchy          = [],
  $backends           = ['yaml'],
  $hiera_yaml         = $hiera::params::hiera_yaml,
  $create_symlink     = true,
  $datadir            = $hiera::params::datadir,
  $hieraenv           = $hiera::params::hieraenv,
  $datadir_manage     = true,
  $mdir               = $hiera::params::mdir,
  $server_info        = $hiera::params::server_info,
  $owner              = $hiera::params::owner,
  $group              = $hiera::params::group,
  $provider           = $hiera::params::provider,
  $eyaml              = false,
  $eyaml_datadir      = undef,
  $eyaml_extension    = undef,
  $confdir            = $hiera::params::confdir,
  $puppet_conf_manage = true,
  $logger             = 'console',
  $cmdpath            = $hiera::params::cmdpath,
  $create_keys        = true,
  $keysdir            = undef,
  $gem_source         = undef,
  $eyaml_version      = undef,
  $merge_behavior     = undef,
  $extra_config       = '',
  $master_service     = $hiera::params::master_service,
) inherits hiera::params {
  if $keysdir {
    $_keysdir = $keysdir
  } else {
    $_keysdir = "${confdir}/keys"
  }
  File {
    owner => $owner,
    group => $group,
    mode  => '0644',
  }
  if ($datadir !~ /%\{.*\}/) and ($datadir_manage == true) {
    file { $datadir:
      ensure => directory,
    }
  }
  if $merge_behavior {
    unless $merge_behavior in ['native', 'deep', 'deeper'] {
      fail("${merge_behavior} merge behavior is invalid. Valid values are: native, deep, deeper")
    }
  }
  if $eyaml {
    require hiera::eyaml
    $eyaml_real_datadir = empty($eyaml_datadir) ? {
      false => $eyaml_datadir,
      true  => $datadir,
    }
  }
  # Template uses:
  # - $eyaml
  # - $backends
  # - $logger
  # - $hierarchy
  # - $datadir
  # - $eyaml_real_datadir
  # - $eyaml_extension
  # - $_keysdir
  # - $confdir
  # - $merge_behavior
  # - $extra_config
 file {'/etc/puppetlabs/code/upoint_foundation.yaml':
    ensure  => present,
    content => template('hiera/upoint_foundation.yaml.erb'),
  }

  # Symlink for hiera command line tool
  #if $create_symlink {
    #file { '/etc/puppetlabs/puppet':
      #ensure => symlink,
      #target => $hiera_yaml,
    #}
  #}
    
  file {'/etc/puppetlabs/code/environments/stage/hieradata/stage.yaml':
  ensure   =>  present,
  content  =>  template('hiera/stage.yaml.erb'),
  file {'/etc/puppetlabs/code/environments/dev/hieradata/defaults.yaml':
  ensure   =>  present,
  content  =>  template('hiera/defaults.yaml.erb'),
      }
      
 
   if [ '%{environment}' == $hieraenv ]  {
      if ('$mdir stage !~ /%\{.*\}/')  {
      file {[ '/etc/puppetlabs/code/environments/stage','/etc/puppetlabs/code/environments/stage/hieradata/environment','/etc/puppetlabs/code/environments/stage/hieradata/role' ]:
      if ('$mdir dev !~ /%\{.*\}/')  {
      file {[ '/etc/puppetlabs/code/environments/dev','/etc/puppetlabs/code/environments/dev/hieradata/environment','/etc/puppetlabs/code/environments/dev/hieradata/role' ]:
      ensure => directory,
      }
     }
    }
 
     file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/upoint_dv.yaml':
     file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/upoint_dv.yaml':
     ensure  => present,
     content => template('hiera/upoint_dv.yaml.erb'),
     }

#include $::roles



      file {  [ '/etc/puppetlabs/code/environments/stage/hieradata','/etc/puppetlabs/code/environments/dev/hieradata' ]: 
      ensure  => 'directory',
      owner  => 'root',
      group  => 'wheel',
      mode   => '0755',
      #path   => "/etc/puppetlabs/code/",
      #section => 'main',
      #setting => 'hiera_config',
      #value   => $hieraenv,
      }
     } 


    #if $puppet_conf_manage {
    #ini_setting { 'puppet.conf hiera_config main section' :
      #ensure  => directory,
      #path    => "${confdir}/puppet.conf",
      #section => 'main',
      #setting => 'hiera_config',
      #value   => $hiera_yaml,
    #}
    #$master_subscribe = [
      #File[$hiera_yaml],
      #Ini_setting['puppet.conf hiera_config main section'],
    #]
  #} else {
    #$master_subscribe = File[$hiera_yaml]
  #}

   #Restart master service
   #Service <| title == $master_service |> {
   #subscribe +> $master_subscribe,
 #}
