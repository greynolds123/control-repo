# Declare Apt key for apt.puppetlabs.com source
apt::key { 'puppetlabs':
  id      => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
<<<<<<< HEAD
  server  => 'hkps.pool.sks-keyservers.net',
=======
  server  => 'pgp.mit.edu',
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
  options => 'http-proxy="http://proxyuser:proxypass@example.org:3128"',
}
