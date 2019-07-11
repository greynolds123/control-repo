function puppet_enterprise::active_puppetdb_hosts() {
  if $settings::storeconfigs {
    $active_puppetdb_hosts =
                puppetdb_query('resources[certname] {
                    type = "Class" and
                    title = "Puppet_enterprise::Profile::Puppetdb" and
                    nodes {
                      deactivated is null and
                      expired is null
                    }
                  }').map |$data| { $data['certname'] }
  } else {
    $active_puppetdb_hosts = []
  }

  pe_sort($active_puppetdb_hosts)
}
