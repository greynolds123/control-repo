#puppet_enterprise

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with puppet_enterprise](#setup)
    * [What puppet_enterprise affects](#what-puppet_enterprise-affects)
    * [Beginning with puppet_enterprise](#beginning-with-puppet_enterprise)
4. [Usage - The available classes and profiles](#usage)
    * [Class: puppet_enterprise](#class-puppet_enterprise)
    * [Available profiles](#available-profiles)
        * [ActiveMQ](#activemq)
            * [Broker](#broker)
            * [Spoke](#spoke)
        * [Certificate Authority](#certificate-authority)
        * [Console](#console)
        * [Database](#database)
        * [Master](#master)
        * [Agent](#agent)
        * [MCollective](#mcollective)
            * [agent](#mcollective-agent)
            * [console](#console-1)
            * [peadmin](#peadmin)
        * [PuppetDB](#puppetdb)
5. [Development - Guide for contributing to the module](#development)
    * [Contributing](#contributing)
    * [How to run spec tests](#spec-tests)
    * [Components vs Profiles](#components-vs-profiles)
      * [Why did you rewrite modules](#why-did-you-rewrite-modules)
    * [Parameters - what belongs at the profile level vs component level](#parameters-profile-vs-component)



##Overview

The `puppet_enterprise` module is for the configuration of all the individual components that make up the
Puppet Enterprise stack.

If you have any questions that are not covered in this readme, you can ask in the `Integration` hipchat
room.

##Module Description

Puppet Enterprise contains a wide variety of software that needs to be configured to interact in a certain
way.  The software stack in PE currently involves the following:

```
ActiveMQ
Apache
console-services
MCollective
Passenger
PostgreSQL
Puppet Server
PuppetDB
```

##Setup
###What puppet_enterprise affects
As mentioned above, the `puppet_enterprise` module configures a wide variety of software. This includes
everything from packages, config files to certificates and more.

###Beginning with puppet_enterprise
All profiles inherit from the main `puppet_enterprise` class. We consider this the `infrastructure` class and it
should be treated as the source of truth for infrastructure related information such as hostnames and ports.

If you do not include this class, then you must pass the required hostnames and ports to the profile.

##Usage
For end users, the component level classes should be considered private and should not be applied directly.
That said, if the component contains a value that you would like to modify and it is not exposed from the
profile level, you can use a Hiera override.

####Class: `puppet_enterprise`
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

###Available Profiles
All profiles are designed in such a way that if the `puppet_enterprise` class is configured, you will not need
to specify any additional parameters for that profile to get its component installed and configured for use
in Puppet Enterprise.

####ActiveMQ
ActiveMQ is the message queue for MCollective. In a default install, the master will be configured as a
broker. In more [advanced deployments](https://docs.puppetlabs.com/pe/latest/install_add_activemq.html) where
you may need to scale this component out, we also provide a spoke profile.

#####Broker
To install with the default parameters (assuming the base `puppet_enterprise` class has been
configured),

```
class { 'puppet_enterprise::profile::amq::broker': }
```

#####Spoke
To install with the default parameters (assuming the base `puppet_enterprise` class has been configured),

```
class { 'puppet_enterprise::profile::amq::spoke': }
```

####Certificate Authority
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

####Console
The Console is made up of many parts: Apache, Passenger, Ruby applications and new JVM based applications.

To install with the default parameters (assuming the base `puppet_enterprise` class has been configured),

```
class { 'puppet_enterprise::profile::console': }
```

This will configure the entire console stack using default values.


####Database
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

####Master
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

####Agent
This is the profile that gets applied to every puppet agent node and currently only configures symlinks for PEs
command line components such as `facter` and `puppet` installed into '/opt/puppet/bin'.

To install with the default parameters (assuming the base `puppet_enterprise` class has been
configured),

```
class { 'puppet_enterprise::profile::agent': }
```

####MCollective
[MCollective](https://docs.puppetlabs.com/mcollective/) is an orchestration engine packaged with PE for
use by things like Live Management. MCollective has three main components: servers, clients and the
middleware. In PE, the middleware we ship and configure is ActiveMQ.

**Note** MCollective uses the term `server` and `client` a bit differently then puppet.

An MCollective server (often just called a “node”) is a computer which can be controlled via
MCollective. Servers run the MCollective daemon (mcollectived), and have any number of agent plugins
installed. The server component is installed on all Puppet Agent nodes.

PE ships a handful of [agent
plugins](https://docs.puppetlabs.com/mcollective/overview_components.html#agent-plugins). They are
located in the files folder. For information on how to update them, see
[UPDATING_MCO_PLUGINS.md](./UPDATING_MCO_PLUGINS.md)

An MCollective client can send requests to any number of servers, using a security plugin to encode and
sign the request and a connector plugin to publish it. In PE we ship two clients, `console` and
`peadmin`. Details on these clients are located in their respective profile section.

The PE Module now also has support for advanced MCO configurations such as
[subcollectives](https://docs.puppetlabs.com/mcollective/overview_components.html#subcollectives).
Configuration for this feature is exposed via the `collectives` and `main_collective` parameters on the
profile.

A quick note on certificates. As mentioned above - communication between the mcollective server and
clients is encrypted using the [OpenSSL Security
Plugin](https://docs.puppetlabs.com/mcollective/reference/plugins/security_ssl.html). A brief breakdown
of how this works:

* Each MCO client will need a private/public keypair.
* Every MCO server then needs:
   - All MCO clients public key's
   - The shared MCO public key
   - The CA cert that AMQ uses for encryption
   - A Private key that has been signed by the above CA
   - The corresponding certificate to that private key.

The MCO client keypairs and the shared server keypair is generated by the `puppet-enterprise-installer`
bash script at install time. Two classes then take care of copying the files around to the desired
locations.

`puppet_enterprise::master::keypair` is responsible for copying these files to each compile master.
`puppet_enterprise::mcollective::server::certs` is resposible for copying the client and server
certs into place.

This is done by using the `file` function. Since puppet functions are ran on the master, this means
that every agent catalog will ship the shared server keypair. The same applies for catalogs for any mco
client.

The last important thing to talk about is the stomp password. At install time, the
`puppet_enterprise_installer` will generate a 20 character random password on the master node and store
it in a text file located at `/etc/puppetlabs/mcollective/credentials`. This is the password used for
communicating with the middleware. Since every mcollective server and client needs this password, it is
also loaded by the `file` function and put in every catalog compilation for MCO servers and
clients.

#####Agent (mcollective)
This is a profile that gets applied to every puppet agent node and configures
the MCollective server on that node. This allows MCollective to direct commands to that node.

To install with the default parameters (assuming the base `puppet_enterprise` class has been
configured),

```
class { 'puppet_enterprise::profile::mcollective::agent': }
```

#####Console
This is the first of two MCollective clients that are shipped with PE. This
client is used by the dashboard's Live Management feature to orchestrate
changes across nodes which have the MCollective Agent class applied to them.

To install with the default parameters (assuming the base `puppet_enterprise`
class has been configured),

```
class { 'puppet_enterprise::profile::mcollective::console': }
```

#####Peadmin
This profile will install and configure the `peadmin` MCollective Client. This
profile is installed by default on the Puppet Master node and allows
commandline MCollective orchestration via the peadmin user.

To install with the default parameters (assuming the base `puppet_enterprise`
class has been configured),

```
class { 'puppet_enterprise::profile::mcollective::peadmin': }
```

####PuppetDB
The `puppetdb` profile is responsible for the configuration of PuppetDB.

To install with the default parameters (assuming the base `puppet_enterprise` class has been configured),

```
class { 'puppet_enterprise::profile::puppetdb': }
```

If you need to add certificates to PuppetDB's whitelist, you can do so by adding them to the parameter
`whitelisted_certnames`. This will append your list of certificates with those needed by Puppet
Enterprise.

##Development
###Contributing
The end goal of the `puppet_enterprise` module is to be a self serve type module that each team will
end up owning the component module for. For now, the integration team still owns the module in whole.

We want to keep it as easy as possible to contribute changes so that our modules work together in the
PE environment. There are a few guidelines that we need contributors to follow so that we can have a
chance of keeping on top of things.

Read the complete module contribution guide in [CONTRIBUTING.md](./CONTRIBUTING.md)

###Spec Tests
For more information on how to run the spec tests, see the [CONTRIBUTING.md](./CONTRIBUTING.md)
document.


###Components vs Profiles
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


####Why did you rewrite modules
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

###Parameters - profile vs component
There has been a lot of discussion internally about what parameters should be exposed at the profile
level. I think Reid Vandewiele sums it up nicely as the following:

```
There are usability problems with exposing a parameter at the profile level. The guiding design
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
```
