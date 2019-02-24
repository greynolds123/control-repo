# The is class deines the variables for ntp.

  class ntp::params {
  ensure     => present,
  enable     => true,
  name       => ntp,
  provider   => ntpd
}
    
