# This is the class for ensuring that the PuppetDB service is running on a node.  This class also
# subscribes to puppet_enterprise::puppetdb::database_ini and
# puppet_enterprise::puppetdb::database_ini to make sure that the PuppetDB service is restarted on
# changes to either configuration file.
class puppet_enterprise::puppetdb::service {

  puppet_enterprise::trapperkeeper::pe_service { 'puppetdb' :
    service_subscribe => [ Class[
      'puppet_enterprise::puppetdb::rbac_consumer_conf',
      'puppet_enterprise::puppetdb::database_ini',
      'puppet_enterprise::puppetdb::jetty_ini',
      'puppet_enterprise::puppetdb::config_ini'
    ], Puppet_enterprise::Puppetdb::Shared_database_settings['read-database'] ],
  }

}
