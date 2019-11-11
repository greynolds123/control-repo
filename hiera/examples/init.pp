<<<<<<< HEAD
class { '::hiera':
=======
class { 'hiera':
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  datadir   => '/etc/puppetlabs/puppet/hieradata',
  hierarchy => [
    '%{environment}/%{calling_class}',
    '%{environment}',
    'common',
  ],
}
