<<<<<<< HEAD
class { '::hiera':
=======
class { 'hiera':
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  datadir   => '/etc/puppetlabs/puppet/hieradata',
  hierarchy => [
    '%{environment}/%{calling_class}',
    '%{environment}',
    'common',
  ],
}
