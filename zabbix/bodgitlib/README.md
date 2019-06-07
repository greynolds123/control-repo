# bodgitlib

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-bodgitlib.svg?branch=master)](https://travis-ci.org/bodgit/puppet-bodgitlib)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-bodgitlib/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-bodgitlib?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/bodgitlib.svg)](https://forge.puppetlabs.com/bodgit/bodgitlib)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-bodgitlib.svg)](https://gemnasium.com/bodgit/puppet-bodgitlib)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with bodgitlib](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

This module is in a similar vein to the stdlib module, a library of resources
for Puppet modules.

## Module Description

This module provides a standard library of resources for the development of
Puppet modules.

## Setup

If you're still using Ruby 1.8.7 then you need to install the Oniguruma gem to
get improved Regexp support. This only needs to be on the Puppetmaster or any
standalone nodes. This could be as simple as `gem install oniguruma` or
installing a package provided by your Operating System.

## Usage

After you've installed bodgitlib, all of its functions are available for module
use or development.

## Reference

### Functions

#### `validate_base64`

Validate a string or array of strings are correctly Base64 encoded.

~~~
validate_base64('Zm9v')
validate_base64(['YmFy', 'YmF6'])
~~~

#### `validate_domain_name`

Validate a string or array of strings are all valid domain names using
`is_domain_name`.

~~~
validate_domain_name('example.com')
validate_domain_name(['example.com', 'example.org'])
~~~

#### `validate_ip_address_array`

Validate an array of IP addresses using `validate_ip_address` to do the
heavy lifting.

~~~
validate_ip_address_array(['1.2.3.4', 'dead::beef'])
~~~

#### `validate_ipv4_address_array`

Validate an array of IPv4 addresses using `validate_ipv4_address` to do the
heavy lifting.

~~~
validate_ipv4_address_array(['1.2.3.4', '5.6.7.8'])
~~~

#### `validate_ipv6_address_array`

Validate an array of IPv6 addresses using `validate_ipv6_address` to do the
heavy lifting.

~~~
validate_ipv6_address_array(['dead::beef', 'feed::beef'])
~~~

#### `validate_ldap_dn`

Validate a string or array of strings are valid LDAP distinguished names.

~~~
validate_ldap_dn('dc=example,dc=com')
validate_ldap_dn(['dc=example, dc=com'])
~~~

#### `validate_ldap_filter`

Validate a string or array of strings are valid LDAP search filters.

~~~
validate_ldap_filter('(!(cn=Tim Howes))')
validate_ldap_filter(['(&(objectClass=Person)(|(sn=Jensen)(cn=Babs J*)))'])
~~~

#### `validate_ldap_sub_dn`

Validate a string or array of strings are valid LDAP distinguished names and
that they are all either an exact match or a subtree of another given
distinguished name.

~~~
validate_ldap_sub_dn('dc=example,dc=com', 'ou=groups,dc=example,dc=com')
validate_ldap_sub_dn('dc=example,dc=com', ['ou=people,dc=example,dc=com'])
~~~

#### `validate_ldap_uri`

Validate a string or array of strings are valid LDAP URI's. If there is a DN
or filter passed then these are validated with `validate_ldap_dn` and
`validate_ldap_filter` respectively.

~~~
validate_ldap_uri('ldap://example.com')
validate_ldap_uri(['ldapi://%2fsome%2fpath'])
validate_ldap_uri('ldap:///dc=example,dc=com?uidNumber?sub?(sn=e*)')
~~~

## Limitations

This module has been built on and tested against Puppet 3.0 and higher.

The module should work pretty much anywhere as the custom functions are all
pure Ruby.

## Development

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-bodgitlib).
