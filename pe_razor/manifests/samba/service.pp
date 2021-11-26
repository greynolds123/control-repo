# Credit to Adam Jahn:
# https://github.com/ajjahn/puppet-samba
#
# == Type pe_razor::samba::service
#
define pe_razor::samba::service (
  $ensure = running,
  $enable = true
) {
  include pe_razor::samba::params

  service { $pe_razor::samba::params::service_name :
    ensure     => $ensure,
    hasstatus  => true,
    hasrestart => true,
    enable     => $enable,
    require    => Pe_razor::Samba::Config['razor']
  }

  if $pe_razor::samba::params::nmbd_name != undef {
    service { $pe_razor::samba::params::nmbd_name :
      ensure     => $ensure,
      hasrestart => false,
      enable     => $enable,
      require    => Pe_razor::Samba::Config['razor']
    }
  }
}
