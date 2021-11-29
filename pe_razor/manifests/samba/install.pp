# Credit to Adam Jahn:
# https://github.com/ajjahn/puppet-samba
#
# == Type pe_razor::samba::install
#
define pe_razor::samba::install {
  package { 'samba':
    ensure => installed
  }
}
