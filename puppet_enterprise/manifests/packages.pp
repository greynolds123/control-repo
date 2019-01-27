# == Class: puppet_enterprise::packages
#
# This class contains virtual resources for all packages managed by PE.
# This is necessary as a single node may contain multiple profiles
# where each profile could want to install the same package, e.g.
# pe-java, causing a compilation error.
#
# === Examples
#
# include puppet_enterprise::packages
#
# Package <| tag == 'master' |>
#
class puppet_enterprise::packages{
  include puppet_enterprise::params

  Package {
    ensure => latest,
    *      => $puppet_enterprise::params::package_options,
  }

  @package { 'pe-postgresql-pglogical':
    tag => [
      'pe-psql-pglogical',
    ],
  }

  @package { 'pe-java':
    tag => [
      'pe-master-packages',
      'pe-puppetdb-packages',
      'pe-activemq-packages',
      'pe-console-packages'
    ],
  }

  @package { 'pe-puppetdb':
    tag => 'pe-puppetdb-packages',
  }

  @package { 'pe-console-services':
    tag => 'pe-console-packages',
  }

  @package { 'pe-client-tools':
    tag => 'pe-controller-packages',
  }

  @package { [
    'pe-license',
    'pe-puppet-license-cli',
    'pe-puppetdb-termini',
    'pe-console-services-termini',
    'pe-puppetserver',
  ]:
    tag => 'pe-master-packages',
  }

  @package { 'pe-orchestration-services':
    tag => 'pe-orchestrator-packages',
  }

  @package { 'pe-activemq':
    tag => 'pe-activemq-packages',
  }

  @package { 'pe-puppet-enterprise-release':
    tag => [
      'pe-activemq-packages',
      'pe-console-packages',
      'pe-master-packages',
      'pe-puppetdb-packages',
    ],
  }
}
