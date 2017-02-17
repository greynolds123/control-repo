# Declare the apt class to manage /etc/apt/sources.list and /etc/sources.list.d
class { 'apt': }

# Install the puppetlabs apt source
# Release is automatically obtained from lsbdistcodename fact if available.
apt::source { 'puppetlabs':
  location => 'http://apt.puppetlabs.com',
  repos    => 'main',
  key      => {
    id     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
<<<<<<< HEAD
    server => 'hkps.pool.sks-keyservers.net',
=======
    server => 'pgp.mit.edu',
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
  },
}

# test two sources with the same key
apt::source { 'debian_testing':
  location => 'http://debian.mirror.iweb.ca/debian/',
  release  => 'testing',
  repos    => 'main contrib non-free',
  key      => {
    id     => 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553',
<<<<<<< HEAD
    server => 'hkps.pool.sks-keyservers.net',
=======
    server => 'subkeys.pgp.net',
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
  },
  pin      => '-10',
}
apt::source { 'debian_unstable':
  location => 'http://debian.mirror.iweb.ca/debian/',
  release  => 'unstable',
  repos    => 'main contrib non-free',
  key      => {
    id     => 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553',
<<<<<<< HEAD
    server => 'hkps.pool.sks-keyservers.net',
=======
    server => 'subkeys.pgp.net',
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
  },
  pin      => '-10',
}
