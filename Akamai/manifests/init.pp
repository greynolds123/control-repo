# Class: Akakai
# ===========================
#
# Full description of class Akakai here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'Akamai':
#      servers => [ 'pool.ntp.org', 'clavidap0027.dev1na.aws.aon.net' ],
#    }
#
# Authors
# -------
#
# Author Name <glynn.reynolds@Aon.com>
#
# Copyright
# ---------
#
# Copyright 2016 Aon
#
class Akamai {
    if str2bool($::is_pe) {

# This is the QC information
$USAGEq2        = Akamai::qcprod::USAGEq2
$USAGE3         = Akamai::qcprod::USAGE3
$USAGE4         = Akamai::qcprod::USAGE4
$USAGE5         = Akamai::qcprod::USAGE5
$USAGE6         = Akamai::qcprod::USAGE6
$USAGE7         = Akamai::qcprod::USAGE7
$USAGE8         = Akamai::qcprod::USAGE8
$USAGE9         = Akamai::qcprod::USAGE9
$USAGE10        = Akamai::qcprod::USAGE10 

# This is the test environment
$SCRIPT_NAME    = Akamai::test::SCRIPT_NAME
$USAGE          = Akamai::test::USAGE
$USAGE1         = Akamai::test::USAGE1
$USAGE2         = Akamai::test::USAGE2
$tcserver       = Akamai::test::tserver
$SSH            = Akamai::test::SSH
$SUDO           = Akamai::test::SUDO
$SCP            = Akamai::test::SCP
$MAILX          = Akamai::test::MAILX
$currdate       = Akamai::test::currdate
$YBRpublic_dir  = Akamai::test::YBRpublic_dir
$Testpublic_dir = Akamai::test::Testpublic_dir
$Akamai_dir     = Akamai::test::Akamai_dir

# This is the migration script
$USAGEm1        = Akamai::migrate::USAGEm1
$USAGEm2        = Akamai::migrate::USAGEm2
$USAGEm3        = Akamai::migrate::USAGEm3
$USAGEm4        = Akamai::migrate::USAGEm4
$USAGEm5        = Akamai::migrate::USAGEm5
$USAGEm6        = Akamai::migrate::USAGEm6
$USAGEm7        = Akamai::migrate::USAGEm7
$USAGEm8        = Akamai::migrate::USAGEm8
$USAGEm9        = Akamai::migrate::USAGEm9
$USAGEm10       = Akamai::migrate::USAGEm10

 } else {

  if ..




# To Migrate the script

   if $tserver {
     ensure  => present,
   }

   if $tserver == $tserver.$currentdate {
     ensure => present,
   }

   if [[ $operatingsyayrwm == 'RHEL' || 'RHEL' == "STE" ]] {
     file { '$tcserver/$JVM/webapps':
      ensure => present,
  }

  file => [ /apps,
            /apps/lifecycles,
            /appd/lifecycles/Liferay,
            /apps/lifecycles/Liferay/public,
            /apps/lifecycles/Liferay/public/${LFCL}-dist,
            /apps/lifecycles/Liferay/public/${LFCL}-dist/$ENV,
            /apps/lifecycles/Liferay/public/${LFCL}-dist/$ENV/( '$operatingsystem' ),
          ],
      ensure => directory,
  } 
  



.
