# This is the yaml config for roles.

class hiera::role {
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 65278082df726ecc5bc5bf5888db3bb047ac06d4
      file {'/etc/puppetlabs/code/environments/stage/hieradata/environment/role/common.eyaml':
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
<<<<<<< HEAD
=======
=======
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
      file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/common.eyaml':
      ensure  => present,
      content => template('hiera/common.eyaml.erb'),
      }
      file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/common.yaml':
      ensure  => present,
      content => template('hiera/common.yaml.erb'),
      }
      file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/liferay_ext_app_server.eyaml':
      ensure  => present,
      content => template('hiera/liferay_ext_app_server.eyaml.erb'),
      }
file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/solr_app_server.yaml':
      ensure  => present,
      content => template('hiera/solr_app_server.yaml.erb'),
      }
      file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/vanilla_liferay_app_server.eyaml':
      ensure  => present,
      content => template('hiera/vanilla_liferay_server.eyaml.erb'),
     }
     file {'/etc/puppetlabs/code/environments/dev/hieradata/environment/role/vanilla_liferay_server.yaml':
<<<<<<< HEAD
=======
>>>>>>> 5e468abb61fdb21f96c229f413b658c9451e7a7e
>>>>>>> 65278082df726ecc5bc5bf5888db3bb047ac06d4
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
     ensure  => present,
     content => template('hiera/vanilla_liferay_server.yaml.erb'),
       }
    }
