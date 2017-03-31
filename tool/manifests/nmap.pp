#  This class will install the package nmap

  class tool::nmap {
  package { 'nmap':
  ensure  => 'present',
  }
  }
