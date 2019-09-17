# Credit to Adam Jahn:
# https://github.com/ajjahn/puppet-samba
#
# == Class pe_razor::samba::params
#
class pe_razor::samba::params {
  $incl    = '/etc/samba/smb.conf'
  $context = '/files/etc/samba/smb.conf'
  $target  = 'target[. = "global"]'

  case $::osfamily {
    'Redhat': {
      $service_name = 'smb'
      $nmbd_name = undef
    }
    'Debian': {
      case $::operatingsystem {
        'Debian': {
          case $::operatingsystemmajrelease {
            '8' : { $service_name = 'smbd' }
            default: { $service_name = 'samba' }
          }
          $nmbd_name = undef
        }
        'Ubuntu': {
          $service_name = 'smbd'
          $nmbd_name = 'nmbd'
        }
        default: {
          $service_name = 'samba'
          $nmbd_name = undef
        }
      }
    }
    'Gentoo': {
      $service_name = 'samba'
      $nmbd_name = undef
    }
    'Archlinux': {
      $service_name = 'smbd'
      $nmbd_name = 'nmbd'
    }

    # Currently Gentoo has $::osfamily = "Linux". This should change in
    # Factor 1.7.0 <http://projects.puppetlabs.com/issues/17029>, so
    # adding workaround.
    'Linux': {
      case $::operatingsystem {
        'Gentoo':  {
          $service_name = 'samba'
          $nmbd_name = undef
        }
        default: { fail("${::operatingsystem} is not supported by this module.") }
      }
    }
    default: { fail("${::osfamily} is not supported by this module.") }
  }
}
