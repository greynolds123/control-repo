# Internal class for Puppet Enterprise MEEP on a master node
#
# Ensures that the MEEP configuration directory is readable by the puppet user
# so that puppetserver can access it during catalog runs.
class puppet_enterprise::master::meep inherits puppet_enterprise::params {

  # Ensure that puppetserver can read all of meep's enterprise data.
  # This relies on the file resource syncing enterprise dir (in
  # pe_infrastructure::enterprise::sync::configuration) always being in a
  # separate (agent) catalog to avoid conflicts.
  #
  # We can't put this in the pe-modules package (the package which owns this
  # file) because the pe-puppet user doesn't exist yet.
  file { $puppet_enterprise::params::enterprise_conf_path:
    ensure  => directory,
    owner   => 'pe-puppet',
    mode    => '0600',
    recurse => true,
    require => Package['pe-puppetserver'],
  }
}
