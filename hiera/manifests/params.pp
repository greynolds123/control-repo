# == Class: hiera::params
#
# This class handles OS-specific configuration of the hiera module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class hiera::params {
  $confdir          = $::settings::confdir
  $hiera_version    = '5'
  $hiera5_defaults  = {'datadir' => 'data', 'data_hash' => 'yaml_data'}
  $package_ensure   = 'present'
  $package_name     = 'hiera'
  $hierarchy        = []
  # Configure for AIO packaging.
  if $facts['pe_server_version'] {
    $master_service = 'rootserver'
    $provider       = 'puppetserver_gem'
    $user           = 'root'
    $owner          = 'root'
    $group          = 'root'
    $eyaml_owner    = 'root'
    $eyaml_group    = 'root'
  } else {
    # It would probably be better to assume this is puppetserver, but that
    # would be a backwards-incompatible change.
    $master_service = 'puppetmaster'
    $provider       = 'puppet_gem'
    $user           = 'root'
    $owner          = 'root'
    $group          = 'root'
    $eyaml_owner    = 'root'
    $eyaml_group    = 'root' 

    file { '/etc/puppetlabs/code/environments/dev/data':
    ensure  => 'directory',
    }    

    file { '/etc/puppetlabs/code/environments/dev/data/secure':
    ensure  => 'directory',
    }

    }
  }
  $cmdpath        = ['/opt/puppetlabs/puppet/bin', '/usr/bin', '/usr/local/bin']
  $datadir        = '/etc/puppetlabs/code/environments/dev/data/'
  $keysdir        = '/etc/puppetlabs/code/environment/data/secure/'
  $manage_package = true
  
  $gitconfig  = @("GITCONFIG"/L)
     [user]
       name  = ${displayname}
       email = ${email}
     [color]
        ui = true
     [alias]
       lg = "log --pretty=format:'%C(yellow)%h%C(reset) %s \
    %C(cyan)%cr%C(reset) %C(blue)%an%C(reset) %C(green)%d%C(reset)' --graph"
        wdiff = diff --word-diff=color --ignore-space-at-eol \
    --word-diff-regex='[[:alnum:]]+|[^[:space:][:alnum:]]+'
    [merge]
        defaultToUpstream = true
    [push]
        default = upstream
    | GITCONFIG

file { "${homedir}/.gitconfig":
  ensure  => file,
  content => $gitconfig,
} 
  file { '/etc/puppetlabs/code/environments/dev/hiera.yaml':
    ensure  => file,
    content => @("END"),
              #Data for hiera.ymal for the dev environment
               -----
               version: 5

               defaults:
               datadir: data
               data_hash: yaml_data
               data_hash: json_data

               hierarchy:
               - name: "Nodes"
                 backend: yaml
                  paths: 
                    - "nodes/%{::trusted.certname}"
                    - "%{environment}/%{calling_modules}"
                    - "%{environment}/%{calling_class}"
                    - "%{environment}/%{role}"
                    - "%{role}"
                    - "%{role}/%{::profile}"
                    - "%{profile}"
                    - "%{environment}"
                    - "%{fqdn}"

              - name: "Exported JSON nodess"
                 backend: json 
                  paths:  
                    - "nodes/%{::trusted.certname}"
                    - "insecure_nodes/%{facts.fqdn}"

              - name: "global"
                 backend: yaml
                   paths:
                    - "%{global}"
                    - "%{fqdn}"                 

              - name: "secure"
                 backend: eyaml
                   paths: 
                    - "%{role}"
                    - "%{profile}"
                    - "%{role}/%{profile}/"
                    - "%{fqdn}"

              - name: "common" 
                 backend: eyaml
                   paths:
                    - "%{role}"
                    - "%{profile}"
                    - "%{role}/%{profile}/"
                    - "%{fqdn}"

              - name: "Eymal Key(s)" 
                lookup_key: eyaml_lookup_key 
                backend: eymal
                 paths:
                    options: 
                    - pkcs7_private_key: /etc/puppetlabs/code/environment/$<%- environments %>/data/secure/keys/private_key.pkcs7.pem
                    - pkcs7_public_key:  /etc/puppetlabs/code/environment/$<%- environments %>/data/secure/keys/public_key.pkcs7.pem                          
              |END
       owner   => 'root',
      #user    => 'root',
       mode    =>  '0644',
  }


  $hiera_yaml = '/etc/puppetlabs/code/environment/dev/hiera.yaml'
