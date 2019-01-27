# This class manages a master's node's auth.conf file, which controls which
# routes are authenticated on the master.
#
# This class is called internally by the Master profile, and should not be called
# directly.
#
# @param console_client_certname [String] The name on the certificate used by the console.
# @param classifier_client_certname [String] The name on the certificate used by the classifier.
# @param orchestrator_client_certname [String] The name on the certificate used by the orchestrator.
class puppet_enterprise::profile::master::auth_conf(
  String $console_client_certname,
  String $classifier_client_certname,
  String $orchestrator_client_certname,
) {
  class { 'puppet_enterprise::master::tk_authz':
    console_client_certname      => $console_client_certname,
    classifier_client_certname   => $classifier_client_certname,
    orchestrator_client_certname => $orchestrator_client_certname,
    require                      => Package['pe-puppetserver'],
    notify                       => Service['pe-puppetserver'],
  }
}
