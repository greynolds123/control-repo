What is it?
===========

A Puppet module that manages logrotate and associated rules

Released under the Apache 2.0 licence

Usage:
------

To install:
<pre>
  include logrotate
</pre>

To add a logrotate config file:
<pre>
  logrotate::file {
    'puppet':
      log         => '/var/log/puppet/*log',
      options     => [ 'missingok', 'notifempty', 'create 0644 puppet puppet', 'sharedscripts', 'weekly' ],
       postrotate  => [  '[ -e /etc/init.d/puppetmaster ] && /etc/init.d/puppetmaster condrestart >/dev/null 2>&1 || true',
                         '[ -e /etc/init.d/puppet ] && /etc/init.d/puppet reload > /dev/null 2>&1 || true' ],
       ensure      => 'present';
  }
</pre>


Known Issues:
-------------

Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR

