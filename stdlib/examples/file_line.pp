# This is a simple smoke test
# of the file_line resource type.
file { '/tmp/dansfile':
  ensure => file,
<<<<<<< HEAD
} ->
file_line { 'dans_line':
=======
}
-> file_line { 'dans_line':
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  line => 'dan is awesome',
  path => '/tmp/dansfile',
}
