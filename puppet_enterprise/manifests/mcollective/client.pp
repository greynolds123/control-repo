define puppet_enterprise::mcollective::client(
  $activemq_brokers,
  $logfile,
  $cert_name              = $title,
  $client_name            = $title,
  $keypair_name           = $title,
  $create_user            = $puppet_enterprise::params::mco_create_client_user,
  $home_dir               = "/var/lib/${title}",
  $main_collective        = 'mcollective',
  $stomp_password         = $puppet_enterprise::params::stomp_password,
  $stomp_port             = $puppet_enterprise::mcollective_middleware_port,
  $stomp_user             = $puppet_enterprise::params::stomp_user,
  $collectives            = ['mcollective'],
  $manage_symlinks        = true  
) {

  if $create_user {
    user { $title:
      ensure => present,
      home   => $home_dir,
    }

    group { $title:
      ensure => present,
    }
  }
}
