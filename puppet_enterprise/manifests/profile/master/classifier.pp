# This class lays down the config files necessary for the master to communicate
# with the node classifier.
#
# This class is called internally by the Master profile, and should not be called
# directly.
#
# @param classifier_host [String] The hostname of the classifier, typically co-located with the console.
# @param classifier_port [Integer] The port that the classifier listens on.
# @param classifier_url_prefix [String] What to prefix to the generated URLs of all classifier requests.
# @param node_terminus [String] Specify a custom node_terminus. Note that changing this parameter is UNSUPPORTED.
class puppet_enterprise::profile::master::classifier(
  $classifier_host,
  $classifier_port,
  $classifier_url_prefix,
  $node_terminus = 'classifier',
) {

  $confdir = '/etc/puppetlabs/puppet'

  pe_ini_setting { 'node_terminus' :
    ensure  => present,
    path    => "${confdir}/puppet.conf",
    section => 'master',
    setting => 'node_terminus',
    value   => $node_terminus,
  }

  # Uses
  #  $classifier_host
  #  $classifier_port
  #  $classifier_url_prefix
  file { "${confdir}/classifier.yaml" :
    content => template('puppet_enterprise/master/classifier.yaml.erb'),
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
  }

}
