$caller_module_name = 'demo'

class { 'pe_staging':
  path => '/tmp/staging',
}

pe_staging::file { 'sample.tar.gz':
  source => 'puppet:///modules/staging/sample.tar.gz'
}

pe_staging::extract { 'sample.tar.gz':
  target  => '/tmp/staging',
  creates => '/tmp/staging/sample',
  require => Staging::File['sample.tar.gz'],
}
