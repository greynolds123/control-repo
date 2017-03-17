$caller_module_name = 'demo'

class { 'pe_staging':
  path => '/tmp/staging',
}

pe_staging::file { 'sample':
  source => 'puppet:///modules/staging/sample',
}

pe_staging::file { 'passwd':
  source => '/etc/passwd',
}

pe_staging::file { 'manpage.html':
  source => 'http://curl.haxx.se/docs/manpage.html',
}
