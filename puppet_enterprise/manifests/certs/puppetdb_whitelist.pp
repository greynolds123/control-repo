
# == Class: puppet_enterprise::certs::puppetdb_whitelist
#
# A class for managing the puppetdb certificate whitelist. In addition to
# explicitly specified certnames, this does a query to puppetdb to add any nodes
# which are classified as Puppetdb, Master, Console, or Orchestrator.
#
# A certificate whitelist is a basic text file with one certificate
# per line that an application will load and parse.
#
# === Parameters
#
# [*certnames*]
#   Array of Strings. The names of the certificates which should be always be
#   added to the whitelist, in addition those from the dynamic puppetdb query.
#
# === Examples
#
#   puppet_enterprise::certs::puppetdb_whitelist_entry { "${certificate_whitelist_target}":
#     whitelisted_certnames => ['mom.infra.net', 'console.infra.net']
#   }
#
class puppet_enterprise::certs::puppetdb_whitelist(
  String $cert_whitelist_path = '/etc/puppetlabs/puppetdb/certificate-whitelist',
  Array $certnames = [],
) {
  include puppet_enterprise::params

  # "storeconfigs" being true is used here to determine if PuppetDB is ready
  # to accept queries. This only matters during a PE installation when
  # templates are applied. This setting is typically false then, since a
  # manifest might otherwise attempt to query PuppetDB before it was running.
  if $settings::storeconfigs {
    $whitelist_query_result =
      puppetdb_query(['from', 'resources',
                      ['extract', 'certname',
                       ['and',
                        ['=', 'type', 'Class'],
                        ['=', ['node','active'], true],
                        ['or',
                         ['=', 'title', 'Puppet_enterprise::Profile::Puppetdb'],
                         ['=', 'title', 'Puppet_enterprise::Profile::Master'],
                         ['=', 'title', 'Puppet_enterprise::Profile::Orchestrator'],
                         ]]]])

    $default_whitelist_certnames = $whitelist_query_result.map |$row| { $row['certname'] }
  }
  else {
    $default_whitelist_certnames = []
  }

  pe_union($default_whitelist_certnames, $certnames).each |$cn| {
    puppet_enterprise::certs::whitelist_entry { "${title} entry: ${cn}":
      certname => $cn,
      target   => $cert_whitelist_path,
      require  => File[$cert_whitelist_path],
    }
  }
}
