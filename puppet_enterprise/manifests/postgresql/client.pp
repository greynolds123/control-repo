# This class abstracts the requirement for postgresql client tools to be
# installed on a node.  It is required because historically we have installed
# the client tools on the master node as well for external postgres
# verification.
#
# Note: inclusion is order dependent in the case of the
# puppet_enterprise::master::database profile since that class declares
# pe_postgresql::globals, and pe_postgresql::client inherits from this
# (effectively declaring it).  The database profile thus would need to be
# declared first.  For that reason, the pe_install module makes the decision
# whether or not to include this class on a master that is lacking the database
# role.
class puppet_enterprise::postgresql::client {
  class { '::pe_postgresql::client':
    package_ensure => $puppet_enterprise::postgresql_ensure,
    package_name   => $puppet_enterprise::postgresql_client_package_name,
    bindir         => $puppet_enterprise::server_bin_dir,
  }
  include puppet_enterprise::packages
  Package <| tag == 'pe-database-packages' |> {
    before +> [
      Class['pe_postgresql::client'],
    ],
  }
  if $puppet_enterprise::params::postgres_multi_version_packaging {
    Package <| tag == 'pe-psql-common' |> {
      before +> [
        Class['pe_postgresql::client'],
      ],
    }
  }
}
