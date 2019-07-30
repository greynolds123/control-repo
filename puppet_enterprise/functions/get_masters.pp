
function puppet_enterprise::get_masters() {
  $compile_masters =
           puppetdb_query("nodes[certname] {
                     resources {
                         type = 'Class' and
                         title = 'Puppet_enterprise::Profile::Master'
                     } and deactivated is null and expired is null }").map |$node| {
                        $node['certname']
                     }
  pe_sort($compile_masters)
}
