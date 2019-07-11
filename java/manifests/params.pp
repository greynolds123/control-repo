<<<<<<< HEAD
# Class: java::params
#
# This class builds a hash of JDK/JRE packages and (for Debian)
# alternatives.  For wheezy/precise, we provide Oracle JDK/JRE
# options, even though those are not in the package repositories.
#
# For more info on how to package Oracle JDK/JRE, see the Debian wiki:
# http://wiki.debian.org/JavaPackage
#
# Because the alternatives system makes it very difficult to tell
# which Java alternative is enabled, we hard code the path to bin/java
# for the config class to test if it is enabled.
=======
# @summary
#   This class builds a hash of JDK/JRE packages and (for Debian)
#   alternatives.  For wheezy/precise, we provide Oracle JDK/JRE
#   options, even though those are not in the package repositories.
#
# @api private
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
class java::params {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
<<<<<<< HEAD
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific', 'OEL': {
          if (versioncmp($::operatingsystemrelease, '5.0') < 0) {
            $jdk_package = 'java-1.6.0-sun-devel'
            $jre_package = 'java-1.6.0-sun'
          }
          elsif (versioncmp($::operatingsystemrelease, '6.3') < 0) {
            $jdk_package = 'java-1.6.0-openjdk-devel'
            $jre_package = 'java-1.6.0-openjdk'
          }
          elsif (versioncmp($::operatingsystemrelease, '7.1') < 0) {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
=======
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific', 'OEL', 'SLC', 'CloudLinux': {
          if (versioncmp($::operatingsystemrelease, '5.0') < 0) {
            $jdk_package = 'java-1.6.0-sun-devel'
            $jre_package = 'java-1.6.0-sun'
            $java_home   = '/usr/lib/jvm/java-1.6.0-sun/jre/'
          }
          # See cde7046 for why >= 5.0 < 6.3
          elsif (versioncmp($::operatingsystemrelease, '6.3') < 0) {
            $jdk_package = 'java-1.6.0-openjdk-devel'
            $jre_package = 'java-1.6.0-openjdk'
            $java_home   = '/usr/lib/jvm/java-1.6.0/'
          }
          # See PR#160 / c8e46b5 for why >= 6.3 < 7.1
          elsif (versioncmp($::operatingsystemrelease, '7.1') < 0) {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
            $java_home   = '/usr/lib/jvm/java-1.7.0/'
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
          }
          else {
            $jdk_package = 'java-1.8.0-openjdk-devel'
            $jre_package = 'java-1.8.0-openjdk'
<<<<<<< HEAD
=======
            $java_home   = '/usr/lib/jvm/java-1.8.0/'
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
          }
        }
        'Fedora': {
          if (versioncmp($::operatingsystemrelease, '21') < 0) {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
<<<<<<< HEAD
=======
            $java_home   = "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/"
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
          }
          else {
            $jdk_package = 'java-1.8.0-openjdk-devel'
            $jre_package = 'java-1.8.0-openjdk'
<<<<<<< HEAD
=======
            $java_home   = "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/"
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
          }
        }
        'Amazon': {
          $jdk_package = 'java-1.7.0-openjdk-devel'
          $jre_package = 'java-1.7.0-openjdk'
<<<<<<< HEAD
=======
          $java_home   = "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/"
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        }
        default: { fail("unsupported os ${::operatingsystem}") }
      }
      $java = {
<<<<<<< HEAD
        'jdk' => { 'package' => $jdk_package, },
        'jre' => { 'package' => $jre_package, },
      }
    }
    'Debian': {
=======
        'jdk' => {
          'package'   => $jdk_package,
          'java_home' => $java_home,
        },
        'jre' => {
          'package'   => $jre_package,
          'java_home' => $java_home,
        },
      }
    }
    'Debian': {
      $oracle_architecture = $::architecture ? {
        'amd64' => 'x64',
        default => $::architecture
      }
      $openjdk_architecture = $::architecture ? {
        'aarch64' => 'arm64',
        'armv7l'  => 'armhf',
        default   => $::architecture
      }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      case $::lsbdistcodename {
        'lenny', 'squeeze', 'lucid', 'natty': {
          $java  = {
            'jdk' => {
              'package'          => 'openjdk-6-jdk',
<<<<<<< HEAD
              'alternative'      => "java-6-openjdk-${::architecture}",
=======
              'alternative'      => "java-6-openjdk-${openjdk_architecture}",
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
              'alternative_path' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-openjdk/jre/',
            },
            'jre' => {
              'package'          => 'openjdk-6-jre-headless',
<<<<<<< HEAD
              'alternative'      => "java-6-openjdk-${::architecture}",
=======
              'alternative'      => "java-6-openjdk-${openjdk_architecture}",
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
              'alternative_path' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-openjdk/jre/',
            },
            'sun-jre' => {
              'package'          => 'sun-java6-jre',
              'alternative'      => 'java-6-sun',
              'alternative_path' => '/usr/lib/jvm/java-6-sun/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-sun/jre/',
            },
            'sun-jdk' => {
              'package'          => 'sun-java6-jdk',
              'alternative'      => 'java-6-sun',
              'alternative_path' => '/usr/lib/jvm/java-6-sun/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-sun/jre/',
            },
          }
        }
<<<<<<< HEAD
        'wheezy', 'jessie', 'precise','quantal','raring','saucy', 'trusty', 'utopic': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
=======
        'wheezy', 'jessie', 'precise', 'quantal', 'raring', 'saucy', 'trusty', 'utopic': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${openjdk_architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${openjdk_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${openjdk_architecture}/",
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
            },
            'jre' => {
              'package'          => 'openjdk-7-jre-headless',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
<<<<<<< HEAD
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
=======
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${openjdk_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${openjdk_architecture}/",
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
            },
            'oracle-jre' => {
              'package'          => 'oracle-j2re1.7',
              'alternative'      => 'j2re1.7-oracle',
              'alternative_path' => '/usr/lib/jvm/j2re1.7-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2re1.7-oracle/',
            },
            'oracle-jdk' => {
              'package'          => 'oracle-j2sdk1.7',
              'alternative'      => 'j2sdk1.7-oracle',
              'alternative_path' => '/usr/lib/jvm/j2sdk1.7-oracle/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/j2sdk1.7-oracle/jre/',
            },
            'oracle-j2re' => {
              'package'          => 'oracle-j2re1.8',
              'alternative'      => 'j2re1.8-oracle',
              'alternative_path' => '/usr/lib/jvm/j2re1.8-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2re1.8-oracle/',
            },
            'oracle-j2sdk' => {
              'package'          => 'oracle-j2sdk1.8',
              'alternative'      => 'j2sdk1.8-oracle',
              'alternative_path' => '/usr/lib/jvm/j2sdk1.8-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2sdk1.8-oracle/',
<<<<<<< HEAD
              },
          }
        }
        'vivid', 'wily', 'xenial': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-8-jdk',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
            },
            'jre' => {
              'package'          => 'openjdk-8-jre-headless',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
=======
            },
            'oracle-java8-jre' => {
              'package'          => 'oracle-java8-jre',
              'alternative'      => "jre-8-oracle-${oracle_architecture}",
              'alternative_path' => "/usr/lib/jvm/jre-8-oracle-${oracle_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/jre-8-oracle-${oracle_architecture}/",
            },
            'oracle-java8-jdk' => {
              'package'          => 'oracle-java8-jdk',
              'alternative'      => "jdk-8-oracle-${oracle_architecture}",
              'alternative_path' => "/usr/lib/jvm/jdk-8-oracle-${oracle_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/jdk-8-oracle-${oracle_architecture}/",
            },
          }
        }
        'stretch', 'vivid', 'wily', 'xenial', 'yakkety', 'zesty', 'artful': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-8-jdk',
              'alternative'      => "java-1.8.0-openjdk-${openjdk_architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${openjdk_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${openjdk_architecture}/",
            },
            'jre' => {
              'package'          => 'openjdk-8-jre-headless',
              'alternative'      => "java-1.8.0-openjdk-${openjdk_architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${openjdk_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${openjdk_architecture}/",
            }
          }
        }
        'bionic': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-11-jdk',
              'alternative'      => "java-1.11.0-openjdk-${openjdk_architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.11.0-openjdk-${openjdk_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.11.0-openjdk-${openjdk_architecture}/",
            },
            'jre' => {
              'package'          => 'openjdk-11-jre-headless',
              'alternative'      => "java-1.11.0-openjdk-${openjdk_architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.11.0-openjdk-${openjdk_architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.11.0-openjdk-${openjdk_architecture}/",
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
            }
          }
        }
        default: { fail("unsupported release ${::lsbdistcodename}") }
      }
    }
    'OpenBSD': {
      $java = {
<<<<<<< HEAD
        'jdk' => { 'package' => 'jdk', },
        'jre' => { 'package' => 'jre', },
=======
        'jdk' => {
          'package'   => 'jdk',
          'java_home' => '/usr/local/jdk/',
        },
        'jre' => {
          'package'   => 'jre',
          'java_home' => '/usr/local/jdk/',
        },
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      }
    }
    'FreeBSD': {
      $java = {
<<<<<<< HEAD
        'jdk' => { 'package' => 'openjdk', },
        'jre' => { 'package' => 'openjdk-jre', },
=======
        'jdk' => {
          'package'   => 'openjdk',
          'java_home' => '/usr/local/openjdk7/',
        },
        'jre' => {
          'package'   => 'openjdk-jre',
          'java_home' => '/usr/local/openjdk7/',
        },
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      }
    }
    'Solaris': {
      $java = {
<<<<<<< HEAD
        'jdk' => { 'package' => 'developer/java/jdk-7', },
        'jre' => { 'package' => 'runtime/java/jre-7', },
=======
        'jdk' => {
          'package'   => 'developer/java/jdk-7',
          'java_home' => '/usr/jdk/instances/jdk1.7.0/',
        },
        'jre' => {
          'package'   => 'runtime/java/jre-7',
          'java_home' => '/usr/jdk/instances/jdk1.7.0/',
        },
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      }
    }
    'Suse': {
      case $::operatingsystem {
        'SLES': {
<<<<<<< HEAD
          if (versioncmp($::operatingsystemrelease, '12') >= 0) {
            $jdk_package = 'java-1_7_0-openjdk-devel'
            $jre_package = 'java-1_7_0-openjdk'
          } elsif (versioncmp($::operatingsystemrelease, '11.4') >= 0) {
            $jdk_package = 'java-1_7_0-ibm-devel'
            $jre_package = 'java-1_7_0-ibm'
          } else {
            $jdk_package = 'java-1_6_0-ibm-devel'
            $jre_package = 'java-1_6_0-ibm'
=======
          if (versioncmp($::operatingsystemrelease, '12.1') >= 0) {
            $jdk_package = 'java-1_8_0-openjdk-devel'
            $jre_package = 'java-1_8_0-openjdk'
            $java_home   = '/usr/lib64/jvm/java-1.8.0-openjdk-1.8.0/'
          } elsif (versioncmp($::operatingsystemrelease, '12') >= 0) {
            $jdk_package = 'java-1_7_0-openjdk-devel'
            $jre_package = 'java-1_7_0-openjdk'
            $java_home   = '/usr/lib64/jvm/java-1.7.0-openjdk-1.7.0/'
          } elsif (versioncmp($::operatingsystemrelease, '11.4') >= 0) {
            $jdk_package = 'java-1_7_1-ibm-devel'
            $jre_package = 'java-1_7_1-ibm'
            $java_home   = '/usr/lib64/jvm/java-1.7.1-ibm-1.7.1/'
          } else {
            $jdk_package = 'java-1_6_0-ibm-devel'
            $jre_package = 'java-1_6_0-ibm'
            $java_home   = '/usr/lib64/jvm/java-1.6.0-ibm-1.6.0/'
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
          }
        }
        'OpenSuSE': {
          $jdk_package = 'java-1_7_0-openjdk-devel'
          $jre_package = 'java-1_7_0-openjdk'
<<<<<<< HEAD
=======
          $java_home   = '/usr/lib64/jvm/java-1.7.0-openjdk-1.7.0/'
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        }
        default: {
          $jdk_package = 'java-1_6_0-ibm-devel'
          $jre_package = 'java-1_6_0-ibm'
<<<<<<< HEAD
        }
      }
      $java = {
        'jdk' => { 'package' => $jdk_package, },
        'jre' => { 'package' => $jre_package, },
=======
          $java_home   = '/usr/lib64/jvm/java-1.6.0-ibd-1.6.0/'
        }
      }
      $java = {
        'jdk' => {
          'package'   => $jdk_package,
          'java_home' => $java_home,
        },
        'jre' => {
          'package'   => $jre_package,
          'java_home' => $java_home,
        },
      }
    }
    'Archlinux': {
      $jdk_package = 'jdk8-openjdk'
      $jre_package = 'jre8-openjdk'
      $java_home   = '/usr/lib/jvm/java-8-openjdk/jre/'
      $java = {
        'jdk' => {
          'package'   => $jdk_package,
          'java_home' => $java_home,
        },
        'jre' => {
          'package'   => $jre_package,
          'java_home' => $java_home,
        },
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      }
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }
}
