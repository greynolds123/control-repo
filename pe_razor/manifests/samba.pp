# Credit to Adam Jahn:
# https://github.com/ajjahn/puppet-samba
#
# == Define pe_razor::samba
#
define pe_razor::samba {
  include pe_razor::params

  pe_razor::samba::server { 'razor':
    server_string => 'Razor Samba Server for Windows Installs',
    security      => 'user',
    map_to_guest  => 'Bad User',
    guest_account => 'nobody',
  }

  pe_razor::samba::share { 'razor':
    comment    => 'Razor Share',
    path       => $pe_razor::params::repo_dir,
    guest_only => true,
    guest_ok   => true,
    public     => true,
    browsable  => true,
    writable   => false,
  }
}