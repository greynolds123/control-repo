# Credit to Adam Jahn:
# https://github.com/ajjahn/puppet-samba
#
# == Define samba::server::option
#
define pe_razor::samba::option ( $value = '' ) {
  $incl    = $pe_razor::samba::params::incl
  $context = $pe_razor::samba::params::context
  $target  = $pe_razor::samba::params::target

  $changes = $value ? {
    ''      => "rm ${target}/${name}",
    default => "set \"${target}/${name}\" \"${value}\"",
  }

  augeas { "samba-${name}":
    incl    => $pe_razor::samba::params::incl,
    lens    => 'Samba.lns',
    context => $pe_razor::samba::params::context,
    changes => $changes,
    require => Augeas['global-section'],
    notify  => Pe_razor::Samba::Service['razor'],
  }
}
