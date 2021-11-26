# Credit to Adam Jahn:
# https://github.com/ajjahn/puppet-samba
#
# == Type pe_razor::samba::server
#
define pe_razor::samba::server($interfaces = '',
  $security = '',
  $server_string = '',
  $unix_password_sync = '',
  $netbios_name = '',
  $workgroup = '',
  $socket_options = '',
  $deadtime = '',
  $keepalive = '',
  $load_printers = '',
  $printing = '',
  $printcap_name = '',
  $map_to_guest = 'Never',
  $guest_account = '',
  $disable_spoolss = '',
  $kernel_oplocks = '',
  $pam_password_change = '',
  $os_level = '',
  $preferred_master = '',
  $bind_interfaces_only = 'yes',
  $shares = {},
  $users = {}, ) {
  include pe_razor::samba::params

  pe_razor::samba::install{'razor':}
  pe_razor::samba::config{'razor':}
  pe_razor::samba::service{'razor':}

  augeas { 'global-section':
    incl    => $pe_razor::samba::params::incl,
    lens    => 'Samba.lns',
    context => $pe_razor::samba::params::context,
    changes => "set ${pe_razor::samba::params::target} global",
    require => Pe_razor::Samba::Config['razor'],
    notify  => Pe_razor::Samba::Service['razor'],
  }

  pe_razor::samba::option {
    'interfaces':           value => $interfaces;
    'bind interfaces only': value => $bind_interfaces_only;
    'security':             value => $security;
    'server string':        value => $server_string;
    'unix password sync':   value => $unix_password_sync;
    'netbios name':         value => $netbios_name;
    'workgroup':            value => $workgroup;
    'socket options':       value => $socket_options;
    'deadtime':             value => $deadtime;
    'keepalive':            value => $keepalive;
    'load printers':        value => $load_printers;
    'printing':             value => $printing;
    'printcap name':        value => $printcap_name;
    'map to guest':         value => $map_to_guest;
    'guest account':        value => $guest_account;
    'disable spoolss':      value => $disable_spoolss;
    'kernel oplocks':       value => $kernel_oplocks;
    'pam password change':  value => $pam_password_change;
    'os level':             value => $os_level;
    'preferred master':     value => $preferred_master;
  }

  create_resources(pe_razor::samba::share, $shares)
}
