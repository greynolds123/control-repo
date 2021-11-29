#pe\_r10k

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
  * [Single source: managing Puppet environments only](#single-source-managing-puppet-environments-only)
  * [Multiple sources: managing Hiera data and Puppet environments](#multiple-sources-managing-hiera-data-and-puppet-environments)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module manages the configuration of r10k within Puppet Enterprise.

##Module Description

The pe\_r10k module specifically manages the supported implementation of r10k on
Puppet Enterprise.

##Usage

###Single source: managing Puppet environments only

To setup r10k to target a Git repository for the purpose of creating
dynamic Puppet environments, simply pass the `remote` attribute:

~~~puppet
class { 'pe_r10k':
  remote => 'https://github.com/glarizza/puppet_repository.git',
}
~~~

The above declaration uses the current Puppet master server's `environmentpath`
setting as the base directory by which directory environments will be created.
To target a different directory, pass the `r10k_basedir` attribute:

~~~puppet
class { 'pe_r10k':
  remote       => 'https://github.com/glarizza/puppet_repository.git',
  r10k_basedir => '/etc/puppetlabs/puppet/my_environments',
}
~~~

###Multiple sources: managing Hiera datadir **and** Puppet environments

To pass multiple sources to r10k, use the `sources` attribute instead of either
`remote` or `r10k_basedir`. The reason for this is because `sources` should be a hash of r10k sources which each need to contain 'basedir' AND 'remote' keys. See the following example:

~~~puppet
class { 'pe_r10k':
  sources => {
    'puppet' => {
      'basedir' => '/etc/puppetlabs/puppet/environments',
      'remote'  => 'https://github.com/glarizza/puppet_repository.git',
    },
    'hiera' => {
      'basedir' => '/etc/puppetlabs/puppet/hiera',
      'remote'  => 'https://github.com/glarizza/hiera_environment',
    },
  }
}
~~~

This type of declaration is commonly used when managing Hiera data independently
from the control repository meant for tracking dynamic Puppet environments.

##Reference

###Classes

####Public Classes

* [`pe_r10k`](#class-per10k): The module's main class, which includes all other classes.

####Private Classes

* `pe_r10k::config`: Handles the r10k config file.

###Parameters

####Class: pe\_r10k

#####`configfile`

The path to r10k's configuration file. By default, this location is `/etc/puppetlabs/r10k/r10k.yaml`.

PE Upgrade Note: Prior to r10k's inclusion in Puppet Enterprise, r10k used `/etc/r10k.yaml` as its configuration file. If you were previously using r10k with open source Puppet, and you've recently upgraded to PE, you might need to change the location of your r10k.yaml. If `/etc/r10k.yaml` exists and `/etc/puppetlabs/r10k/r10k.yaml` does not, then the settings in `/etc/r10k.yaml` are used. If both files exist, the settings in `/etc/puppetlabs/r10k/r10k.yaml` are used, and r10k raises a warning.

#####`cachedir`

The path to the directory used by r10k for caching data, such as the repositories for
modules in the Puppetfile.

#####`proxy`

Proxy server to use for all HTTP operations. Can be set or overridden in git\_settings or
forge\_settings to limit to certain types of operations.

#####`remote`

The remote control repository URL used to configure r10k to generate dynamic
directory environments for Puppet. This variable is only used if `sources` is
not being used.

#####`sources`

A hash containing data sources to be used by r10k. This parameter is used if
you are managing more than just Puppet environments (for example, if Hiera
data is also being managed with its own control repository). If `sources`
has been set, `remote` and `r10k_basedir` are not used.

#####`git_settings`

A hash containing Git specific settings. This parameter is used if you're
configuring the r10k Git provider, Git default SSH username, or Git SSH private
key.

#####`forge_settings`

A hash containing Puppet Forge specific settings. This parameter is used if you're
configuring a private forge, or must access the Puppet Forge through a proxy server.

#####`deploy_settings`

A hash containing settings controlling how r10k runs deploys.

#####`postrun`

An optional command that will be run after r10k finishes deploying environments.
The command must be an array of strings that will be used as an argument vector.

#####`r10k_basedir`

The basedir to which r10k generates directory environments based on
branches of the control repository (`remote`). If `sources` has been set,
`r10k_basedir` and `remote` are not used.

#####`r10k_user`

The user who executes the r10k binary. This user must have permissions to access r10k's configuration file(s), as well as write access to the basedirs configured in `r10k_basedir`.

#####`r10k_group`

The group with access to r10k's configuration file(s).

##Limitations

This module is available only for Puppet Enterprise 4.0 and later.

## Development

This module was built by Puppet Labs specifically for use with Puppet Enterprise (PE).

If you run into an issue with this module, or if you would like to request a feature, please [file a ticket](https://tickets.puppetlabs.com/browse/MODULES/).

If you are having problems getting this module up and running, please [contact Support](http://puppetlabs.com/services/customer-support).
