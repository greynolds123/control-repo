# This class allows for r10k installation without configuration
class pe_r10k::package {
  package { 'pe-r10k':
    ensure => latest,
  }
}
