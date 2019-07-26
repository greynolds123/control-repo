# Defined type for creating and managing an mcollective client.
# An mcollective client consists of several parts:
#   - The mcollective-client package
#   - The system user
#   - The certificates for communicating with amq and signing messages
#   - The mcollective client config file
#
# If you would like to manage the system user by yourself, you can pass in
# `create_user => false`. If you do this, make sure that you pass in a valid `home_dir`.
#
# @param activemq_brokers [Array] List of ActiveMQ brokers.
# @param log_file [String] Path to where the mcollective client should log to.
# @param cert_name [String] The name to use for the clients certificate. This should be a unique name
#         across your infrastructure.
# @param client_name [String] The name of the mcollective client.
# @param collectives [Array] List of collectives that this client should talk to.
# @param create_user [String] Whether or not we should create and manage this users account on disk.
# @param home_dir [String] The home directory of the mcollective client system user.
# @param main_collective [String] The collective this client should direct Registration messages to.
# @param randomize_activemq [Boolean] Whether to randomize the order of the connection pool before connecting.
# @param stomp_passowrd [String] The stomp password.
# @param stomp_port [Integer] The port that the stomp service is listening on.
# @param stomp_user [String] The username for sending messages over the stomp protocol.
# @param manage_symlinks [Boolean] Flag to enable creation of convenience links
# @param $mco_disovery_timeout Optional[Integer] Control the timeout for how long to discover nodes
# @param mco_arbitrary_client_config Optional[Array[String]] takes settings like ['foo = bar', 'baz = bah']
define puppet_enterprise::mcollective::client(
  $activemq_brokers,
  $logfile,
  $cert_name              = $title,
  $client_name            = $title,
  $keypair_name           = $title,
  $create_user            = $puppet_enterprise::params::mco_create_client_user,
  $home_dir               = "/var/lib/${title}",
  $main_collective        = 'mcollective',
  $randomize_activemq     = false,
  $stomp_password         = $puppet_enterprise::params::stomp_password,
  $stomp_port             = $puppet_enterprise::mcollective_middleware_port,
  $stomp_user             = $puppet_enterprise::params::stomp_user,
  $collectives            = ['mcollective'],
  $manage_symlinks        = true,
  Optional[Integer]       $mco_discovery_timeout       = undef,
  Optional[Array[String]] $mco_arbitrary_client_config = undef,
){
  include puppet_enterprise::packages
  include puppet_enterprise::params
  include puppet_enterprise::symlinks

  $mco_server_name = $puppet_enterprise::params::mco_server_name
  $mco_plugin_libdir = $puppet_enterprise::params::mco_plugin_libdir

  if $manage_symlinks {
    File <| tag == 'pe-mco-symlinks' |>
  }

  if $create_user {
    puppet_enterprise::mcollective::client::user { $client_name:
      home_dir => $home_dir,
    }
  }

  $cert_dir = "${home_dir}/.mcollective.d"

  puppet_enterprise::mcollective::client::certs { $cert_name:
    client_name     => $client_name,
    keypair_name    => $keypair_name,
    destination_dir => $cert_dir,
  }

  File {
    owner => $client_name,
    group => $client_name,
    mode  => '0600'
  }

  file { $logfile:
    ensure => file
  }

  # Template uses:
  # - $activemq_brokers
  # - $cert_dir
  # - $cert_name
  # - $logfile
  # - $main_collective
  # - $randomize_activemq
  # - $stomp_password
  # - $stomp_port
  # - $stomp_user
  # - $collectives
  # - $mco_server_name
  # - $mco_plugin_libdir
  # - $mco_discovery_timeout
  # - $mco_arbitrary_client_config
  file { "${home_dir}/.mcollective":
    content => template('puppet_enterprise/mcollective/client.cfg.erb'),
  }

  # Previous versions of PE used to lay down client.cfg in /etc/puppetlabs/mcollective/client.cfg
  # Remove it since its now placed in the clients homedir. Since this is a defined type, it could be used
  # multiple times on one node (for example an all in one master will have the profile console and peadmin).
  # to prevent duplicate declarations, check if this hasn't already been defined.
  if ! defined(File['/etc/puppetlabs/mcollective/client.cfg']) {
    file { '/etc/puppetlabs/mcollective/client.cfg':
      ensure => absent,
    }
  }
  include puppet_enterprise::mcollective::service
  include puppet_enterprise::mcollective::cleanup
}
