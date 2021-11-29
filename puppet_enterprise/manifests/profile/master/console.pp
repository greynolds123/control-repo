# WARNING: This class is obsolete and will be removed in a future version
# of Puppet Enterprise.  Please remove it from your classification.
#
# This class sets up console.conf for the master. Which essentially defines
# where the master should look to find the console, which certificate it should
# use, and how to send reports to the console.
#
# This class is called internally by the Master profile, and should not be called
# directly.
#
# @param console_host [String] The hostname of the console.
# @console_server_certname [String] The name on the certificate used by the console.
# @dashboard_port [Integer] The port that the dashboard service listens on.
class puppet_enterprise::profile::master::console(
  $console_host,
  $console_server_certname,
  $dashboard_port,
) inherits puppet_enterprise::params {
}
