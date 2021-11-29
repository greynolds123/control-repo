# puppet_enterprise

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet_enterprise](#setup)
    * [What puppet_enterprise affects](#what-puppet_enterprise-affects)
    * [Beginning with puppet_enterprise](#beginning-with-puppet_enterprise)
4. [Usage - The available classes and profiles](#usage)
    * [Class: puppet_enterprise](#class-puppet_enterprise)
    * [Available profiles](#available-profiles)
        * [Certificate Authority](#certificate-authority)
        * [Console](#console)
        * [Database](#database)
        * [Master](#master)
        * [Agent](#agent)
        * [PuppetDB](#puppetdb)
5. [Development - Guide for contributing to the module](#development)
    * [Contributing](#contributing)
    * [How to run spec tests](#spec-tests)
    * [Components vs Profiles](#components-vs-profiles)
      * [Why did you rewrite modules](#why-did-you-rewrite-modules)
    * [Parameters](#parameters)
      * [what belongs at the profile level vs component level](#parameters---profile-vs-component)
      * [init.pp vs params.pp](#initpp-vs-paramspp)

## Overview

The `puppet_enterprise` module is for the configuration of all the individual components that make up the
Puppet Enterprise stack.

If you have any questions that are not covered in this readme, you can ask in the `PE Installer and Management` Slack
room.

## Module Description

Puppet Enterprise contains a wide variety of software that needs to be configured to interact in a certain
way.  The software stack in PE currently involves the following:

```
ace-server
bolt-server
console-services
orchestration-services
plan-executor
PostgreSQL
Puppet Server
PuppetDB
```

## Setup
### What puppet_enterprise affects
As mentioned above, the `puppet_enterprise` module configures a wide variety of software. This includes
everything from packages, config files to certificates and more.

### Beginning with puppet_enterprise
All profiles inherit from the main `puppet_enterprise` class. We consider this the `infrastructure` class and it
should be treated as the source of truth for infrastructure related information such as hostnames and ports.

If you do not include this class, then you must pass the required hostnames and ports to the profile.

## Usage
For end users, the component level classes should be considered private and should not be applied directly.
That said, if the component contains a value that you would like to modify and it is not exposed from the
profile level, you can use a Hiera override.

#### Class: `puppet_enterprise`
The `puppet_enterprise` is the base class that acts as the source of truth for information about a customers
PE stack. Things like hostnames, ports and DB information should go here.

If using the `puppet_enterprise` module in conjunction with the Node Classifier, this class should be
applied to it's own node group. No nodes need to be pinned to this node group. Then all subsequent node
groups that you apply the following profiles to should inherit from this node group.

The `puppet-enterprise-installer` script will do this for you on a fresh install. The only truly required
information that you should need to specify will be hostnames. Everything else has defaults.

This class is where you should define any
[anchors](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/type/anchor.rb). One already
exists for the certificate authority.

A quick explanation of anchors:

```
When building a complex multi-tier model, it is not known up front which profiles will be deployed to a given
node. However, some profiles when deployed together have dependencies which must be expressed. For example,
the CA must be set up and configured before certificates can be requested.  Therefore the CA must be
configured before any certificate-requiring service. Since the profiles cannot express those dependencies
directly against each other, since they may or may not exist in a given node's catalog, we instead have them
express dependencies against common anchors.
```

### Available Profiles
All profiles are designed in such a way that if the `puppet_enterprise` class is configured, you will not need
to specify any additional parameters for that profile to get its component installed and configured for use
in Puppet Enterprise.

#### Certificate Authority
Before discussing the details of the `certificate_authority` profile, it is important to understand that
in the current version of PE, the certificate authority service still has a lot of overlap with the
puppet master service. What this means is that the certificate authority node will always be a master,
but not all masters will be a certificate authority. In future versions the certificate authority will
be completely separated from the puppet master and as such, should decrease the complexity of the
`certificate_authority` profile.

With that said, to minimize code duplication, the `certificate_authority` profile inherits the `master`
profile and performs collector overrides on two resources:

----

1) The [Puppet Server's
bootstrap.cfg](https://github.com/puppetlabs/puppet-server/blob/master/documentation/configuration.markdown#service-bootstrapping).

Puppet Server has three different services when it comes to the certificate authority:

```
puppetlabs.services.ca.certificate-authority-service
puppetlabs.enterprise.services.reverse-proxy.reverse-proxy-ca-service
puppetlabs.services.ca.certificate-authority-disabled-service
```

The `master` profile defaults to the `reverse-proxy-ca-service`, so the `certificate_authority` profile
will override it and set the `certificate-authority-service`.

2) The [ca.conf
file](https://github.com/puppetlabs/puppet-server/blob/master/documentation/configuration.markdown#caconf).


The `master` profile sets the `ca.conf` file to either `ensure => absent` or to the erb template
`ca-proxy.erb` depending on the service its set to use.

The `certificate_authority` profile will override that file resource to lay down a `ca.conf` file to
configure the
[client-whitelist](https://github.com/puppetlabs/puppet-server/blob/master/documentation/configuration.markdown#caconf).

----

Finally, because of the overlap of the certificate authority service and the puppet master service, the profile
has also been overloaded to act as the Master of Masters in a [Large Environment
Installation](https://docs.puppetlabs.com/pe/latest/install_multimaster.html).

This means the profile will also modify Puppet's built in fileserver to serve packages for additional
compile masters. The packages on the Master of Masters will have been configured by the
`puppet-enterprise-installer` script.


To install with the default parameters (assuming the base `puppet_enterprise` class has been configured),

```
class { 'puppet_enterprise::profile::certificate_authority': }
```

#### Console
The Console is comprised of an Ember.js single page application backed by a clojure middleware.

To install with the default parameters (assuming the base `puppet_enterprise` class has been configured),

```
class { 'puppet_enterprise::profile::console': }
```

This will configure the entire console stack using default values.


#### Database
The database profile is used for configuring a PostgreSQL server for use with the PE stack, which means setting
up database tables and configuring connections to use SSL.

The database profile is applied at install time by the `puppet-enterprise-installer` bash script and is not
applied in the Node Classifier due to the fact that it requires usernames and passwords for the database.

If the profile is applied without providing passwords, it will not attempt to manage the tablespace or DB for
that service.


To install with the default parameters (assuming the base `puppet_enterprise` class has been configured),

```
class { 'puppet_enterprise::profile::database': }
```

#### Master
The master profile is responsible for configuring the Puppet Server to talk with PuppetDB and the
console.

It also contains some logic for bootstrapping itself from a Master of Masters so you can spin up
additional [compile masters](https://docs.puppetlabs.com/pe/latest/install_multimaster.html) by
*promoting* an agent instead of SCPing a 300MB tarball to a node and running the bash script.

To install with the default parameters (assuming the base `puppet_enterprise` class has been configured),

```
class { 'puppet_enterprise::profile::master': }
```

If you are using an external CA, you would want to set `enabled_ca_proxy` to false. This will configure
[Puppet Server's
bootstrap.cfg](https://github.com/puppetlabs/puppet-server/blob/master/documentation/configuration.markdown#service-bootstrapping)
to load the `certificate-authority-disabled-service` - a placeholder / noop ca service.

#### Agent
This is the profile that gets applied to every puppet agent node and currently only configures symlinks for PEs
command line components such as `facter` and `puppet` installed into '/opt/puppet/bin'.

To install with the default parameters (assuming the base `puppet_enterprise` class has been
configured),

```
class { 'puppet_enterprise::profile::agent': }
```

The agent class can also (optionally) manage puppet.conf; to do this, set the
`manage_puppet_conf` param to true. This will make the `server_list` param take
effect, to manage the list of masters the agent tries to connect. (The
`manage_puppet_conf` flag does not strictly need to exist, but was implemented
out of an abundance of caution)

The agent class can be configured to support Orchestrator running over compile masters as well
via the `pcp_broker_list` parameter. Set it to a list of hosts (and ports) of compile masters
(or load balancers for those masters) to use them. By default it will attempt to connect to
the primary master. PE Task support also makes use of compile masters for acquiring tasks when
the `server_list` param is set.

#### PuppetDB
The `puppetdb` profile is responsible for the configuration of PuppetDB.

To install with the default parameters (assuming the base `puppet_enterprise` class has been configured),

```
class { 'puppet_enterprise::profile::puppetdb': }
```

If you need to add certificates to PuppetDB's whitelist, you can do so by adding them to the parameter
`whitelisted_certnames`. This will append your list of certificates with those needed by Puppet
Enterprise.

It is also possible to specify the cipher suites accepted by puppetdb's SSL interface using hiera to
set puppet_enterprise::puppetdb::cipher_suites. If this parameter is undefined (default) it will not
add the cipher-suites setting to jetty.ini and the JDK defaults shall be used. Removing the hiera
entry will also remove the setting from jetty.ini.

## Development

### Contributing

The end goal of the `puppet_enterprise` module is to be a self serve type module that each team will
end up owning the component module for. For now, the PE Installation and Management team still owns the module in whole.

We want to keep it as easy as possible to contribute changes so that our modules work together in the
PE environment. There are a few guidelines that we need contributors to follow so that we can have a
chance of keeping on top of things.

Read the complete module contribution guide in [CONTRIBUTING.md](./CONTRIBUTING.md)

### Spec Tests
For more information on how to run the spec tests, see the [CONTRIBUTING.md](./CONTRIBUTING.md)
document.


### Components vs Profiles
The module is currently architected as one monolithic module for ease of bootstrapping it's development.

```
puppet_enterprise
├── manifests
│   ├── component
│   ├── profile
│   │   ├── component
```

Future versions will split each component into it's own module, leaving the `puppet_enterprise` module
with just the profiles.

This means that each component should **not** contain any logic related to Puppet Enterprise. The
component module code should be designed in a state that it could be released on the forge and a user
could use it to set up just that component.

This means any PE logic should go at the profile level - things such as how does a Puppet Server talk
to PuppetDB and the console, configuring PostgreSQL with PE specific DB's etc.

Which leads to the question of:


#### Why did you rewrite modules
Instead of using the FOSS version.

The short answer to this is because of module environment separation. In the past we used the FOSS
version of the modules, however customers may want to use a different version of that module. If that
new version changes the behavior of the class that we are using, the PE module is now broken.

The short term fix for this is to name space everything that the `puppet_enterprise` module uses.
However namespacing is a very expensive (in terms of time) process that must be repeated after every
release. To alleviate that, the component modules contain a bare bones version of the FOSS module for
accomplishing the goal.

Some modules where namespaced completely, those being:

[puppetlabs-pe_postgresql](https://github.com/puppetlabs/puppetlabs-pe_postgresql)
[puppetlabs-pe_java_ks](https://github.com/puppetlabs/puppetlabs-pe_java_ks)
[puppetlabs-pe_inifile](https://github.com/puppetlabs/puppetlabs-pe_inifile)
[puppetlabs-pe_concat](https://github.com/puppetlabs/puppetlabs-pe_concat)

One module we did not choose to namespace was
[puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib). Instead we chose to namespace the
few functions our module use (and the dependencies) use.

### Parameters - profile vs component
There has been a lot of discussion internally about what parameters should be exposed at the profile level. I think Reid Vandewiele sums it up nicely as the following: ``` There are usability problems with exposing a parameter at the profile level. The guiding design
principle we've been using is to present profile parameters that directly relate to the profile or
which have potential to span at least two logical roles (that could be deployed to different nodes).

We don't want to expose all parameters at the profile level because A) it's not possible to do it
sanely without seriously bloating the Puppet code, and B) it would be converting an organized,
structured set of possible tunables into a less organized, unstructured list of parameters.

Because we don't expose all parameters at the profile level, power users will already be aware of the
structured list of parameters they can adjust through Hiera. However, Hiera is not true data binding in
that it only sets defaults, and explicit parameters in code will override those tunings. We've seen
power users struggle with implementations where too many parameters are exposed at the profile level.
Moving parameters up like that introduces more potential for error both by us and by our users, and
makes the code more complicated for questionable benefit.

There are three potential reasons we would choose to expose a parameter at the profile level. The first
is that it belongs there - logically relates to the profile, and not just a subcomponent of it. The
second is that it is a parameter common to multiple components, and so exposing it at the profile
provides a place to set it once, avoiding user duplication of the configuration. The third is
hypothetical, and it would be just so that the parameter is visible in the PE Console GUI.

I would caution against really ever using that third rationale. We want a data binding mechanism
visible in the GUI which can be used for tuning, but class parameters are not it. We shouldn't
constrain the quality of our Puppet code in order to imperfectly provide a GUI tunable. If we do, it
should only be when we expect a significant number of users to be manually tuning it, not just a few.
Hiera is a perfectly acceptable means of accomplishing tuning today for unusual circumstances.

#### init.pp vs params.pp

This section aims to help people decide whether a new parameter default should be added
to `init.pp` or `params.pp`.

First - the disclaimer. The module is in an inconsistent state because we never
have slack time to go and fix these issues as both module best practices and the
product evolve. What I'm outlining below is what we've been trying to move
towards and trying to ensure any new code that lands matches this pattern:

- init.pp should contain parameters that are used for configuring common parts
of Puppet Enterprise - things multiple profiles might need access too - such as
hostnames, ports and database names.  Profile classes can then default to those
parameters and when a user needs to change something, they only need to change
it in one place.

- params.pp should contain variables whose defaults need to be dynamically
calculated - such as file paths due to operating system differences etc. Other
classes - including init.pp - can then reference those as defaults. Any
variable that is defiend in params.pp, the user can never modify.
