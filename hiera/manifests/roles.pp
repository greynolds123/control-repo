# This is the yaml config for roles.

class hiera::role {
      file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/role/common.eyaml':
      ensure  => present,
      content => template('hiera/common.eyaml.erb'),
      }
      file {'/etc/puppetlabs/code/environments/production/hieradata/environment/role/common.yaml':
      ensure  => present,
      content => template('hiera/common.yaml.erb'),
      }
      }
      file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/common.eyaml':
      ensure  => present,
      content => template('hiera/common.eyaml.erb'),
      }
    }
