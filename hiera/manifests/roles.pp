# This is the yaml config for roles.

class hiera::role {
      file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/role/common.eyaml':
<<<<<<< HEAD
=======
      ensure  => present,
      content => template('hiera/common.eyaml.erb'),
      }
      file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/role/common.yaml':
      ensure  => present,
      content => template('hiera/common.yaml.erb'),
      }
      file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/role/liferay_ext_app_server.eyaml':
      ensure  => present,
      content => template('hiera/liferay_ext_app_server.eyaml.erb'),
      }
file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/role/solr_app_server.yaml':
      ensure  => present,
      content => template('hiera/solr_app_server.yaml.erb'),
      }
      file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/role/vanilla_liferay_app_server.eyaml':
      ensure  => present,
      content => template('hiera/vanilla_liferay_server.eyaml.erb'),
     }
     file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/role/vanilla_liferay_server.yaml':
      file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/common.eyaml':
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
      ensure  => present,
      content => template('hiera/common.eyaml.erb'),
      }
      file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/common.yaml':
      ensure  => present,
      content => template('hiera/common.yaml.erb'),
     }
      file {'/etc/puppetlabs/code/environments/production/hieradata/environment/role/common.yaml':
      ensure  => present,
      content => template('hiera/common.yaml.erb'),
     }

