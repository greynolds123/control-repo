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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  line => 'dan is awesome',
  path => '/tmp/dansfile',
}
