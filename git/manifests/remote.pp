# This class manages and builds the remote repo for github and bitbucket.

  class git::remote {
  file { "/etc/puppetlabs/code/environments/$<=% @environment %>/modudles":
  ensure => present,
  }
  }


