# Defined Type java::oracle
#
# Description
# Installs Oracle Java. By using this module you agree to the Oracle licensing
# agreement.
#
# Install one or more versions of Oracle Java.
#
# uses the following to download the package and automatically accept
# the licensing terms.
# wget --no-cookies --no-check-certificate --header \
# "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
<<<<<<< HEAD
# "http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jre-8u25-linux-x64.tar.gz"
#
# Parameters
# [*version*]
# Version of Java to install
=======
# "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"
#
# Parameters
# [*version*]
# Version of Java to install, e.g. '7' or '8'. Default values for major and minor
# versions will be used.
#
# [*version_major*]
# Major version which should be installed, e.g. '8u101'. Must be used together with
# version_minor.
#
# [*version_minor*]
# Minor version which should be installed, e.g. 'b12'. Must be used together with
# version_major.
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
#
# [*java_se*]
# Type of Java Standard Edition to install, jdk or jre.
#
# [*ensure*]
# Install or remove the package.
#
# [*oracle_url*]
# Official Oracle URL to download binaries from.
#
<<<<<<< HEAD
=======
# [*proxy_server*]
# Specify a proxy server, with port number if needed. ie: https://example.com:8080. (passed to archive)
#
# [*proxy_type*]
# Proxy server type (none|http|https|ftp). (passed to archive)
#
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
# Variables
# [*release_major*]
# Major version release number for java_se. Used to construct download URL.
#
# [*release_minor*]
# Minor version release number for java_se. Used to construct download URL.
#
# [*install_path*]
# Base install path for specified version of java_se. Used to determine if java_se
# has already been installed.
#
# [*package_type*]
# Type of installation package for specified version of java_se. java_se 6 comes
# in a few installation package flavors and we need to account for them.
#
# [*os*]
# Oracle java_se OS type.
#
# [*destination*]
# Destination directory to save java_se installer to.  Usually /tmp on Linux and
# C:\TEMP on Windows.
#
# [*creates_path*]
# Fully qualified path to java_se after it is installed. Used to determine if
# java_se is already installed.
#
# [*arch*]
# Oracle java_se architecture type.
#
# [*package_name*]
# Name of the java_se installation package to download from Oracle's website.
#
# [*install_command*]
# Installation command used to install Oracle java_se. Installation commands
# differ by package_type. 'bin' types are installed via shell command. 'rpmbin'
# types have the rpms extracted and then forcibly installed. 'rpm' types are
# forcibly installed.
#
# [*url*]
# Full URL, including oracle_url, release_major, release_minor and package_name, to
<<<<<<< HEAD
# download the Oracle java_se installer.
=======
# download the Oracle java_se installer. Originally present but not used, activated
# to workaround MODULES-5058
#
# [*url_hash*]
# Directory hash used by the download.oracle.com site.  This value is a 32 character string
# which is part of the file URL returned by the JDK download site.
#
# [*jce*]
# Install Oracles Java Cryptographic Extensions into the JRE or JDK
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
#
# ### Author
# mike@marseglia.org
#
define java::oracle (
<<<<<<< HEAD
  $ensure       = 'present',
  $version      = '8',
  $java_se      = 'jdk',
  $oracle_url   = 'http://download.oracle.com/otn-pub/java/jdk/',
=======
  $ensure        = 'present',
  $version       = '8',
  $version_major = undef,
  $version_minor = undef,
  $java_se       = 'jdk',
  $oracle_url    = 'http://download.oracle.com/otn-pub/java/jdk/',
  $proxy_server  = undef,
  $proxy_type    = undef,
  $url           = undef,
  $url_hash      = undef,
  $jce           = false,
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
) {

  # archive module is used to download the java package
  include ::archive

<<<<<<< HEAD
  ensure_resource('class', 'stdlib')

=======
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  # validate java Standard Edition to download
  if $java_se !~ /(jre|jdk)/ {
    fail('Java SE must be either jre or jdk.')
  }

<<<<<<< HEAD
  # determine oracle Java major and minor version, and installation path
  case $version {
    '6' : {
      $release_major = '6u45'
      $release_minor = 'b06'
      $install_path = "${java_se}1.6.0_45"
    }
    '7' : {
      $release_major = '7u80'
      $release_minor = 'b15'
      $install_path = "${java_se}1.7.0_80"
    }
    '8' : {
      $release_major = '8u51'
      $release_minor = 'b16'
      $install_path = "${java_se}1.8.0_51"
    }
    default : {
      $release_major = '8u51'
      $release_minor = 'b16'
      $install_path = "${java_se}1.8.0_51"
=======
  if $jce {
    $jce_download = $version ? {
      '8'     => 'http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip',
      '7'     => 'http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip',
      '6'     => 'http://download.oracle.com/otn-pub/java/jce_policy/6/jce_policy-6.zip',
      default => undef
    }
  }

  # determine Oracle Java major and minor version, and installation path
  if $version_major and $version_minor {

    $release_major = $version_major
    $release_minor = $version_minor
    $release_hash  = $url_hash

    if $release_major =~ /(\d+)u(\d+)/ {
      # Required for CentOS systems where Java8 update number is >= 171 to ensure
      # the package is visible to Puppet
      if $facts['os']['family'] == 'RedHat' and $2 >= '171' {
        $install_path = "${java_se}1.${1}.0_${2}-amd64"
      } else {
        $install_path = "${java_se}1.${1}.0_${2}"
      }
    } else {
      $install_path = "${java_se}${release_major}${release_minor}"
    }
  } else {
    # use default versions if no specific major and minor version parameters are provided
    case $version {
      '6' : {
        $release_major = '6u45'
        $release_minor = 'b06'
        $install_path = "${java_se}1.6.0_45"
        $release_hash  = undef
      }
      '7' : {
        $release_major = '7u80'
        $release_minor = 'b15'
        $install_path = "${java_se}1.7.0_80"
        $release_hash  = undef
      }
      '8' : {
        $release_major = '8u192'
        $release_minor = 'b12'
        $install_path = "${java_se}1.8.0_192"
        $release_hash  = '750e1c8617c5452694857ad95c3ee230'
      }
      default : {
        $release_major = '8u192'
        $release_minor = 'b12'
        $install_path = "${java_se}1.8.0_192"
        $release_hash  = '750e1c8617c5452694857ad95c3ee230'
      }
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    }
  }

  # determine package type (exe/tar/rpm), destination directory based on OS
<<<<<<< HEAD
  case $::kernel {
    'Linux' : {
      case $::operatingsystem {
        'CentOS', 'RedHat' : {
=======
  case $facts['kernel'] {
    'Linux' : {
      case $facts['os']['family'] {
        'RedHat', 'Amazon' : {
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
          # Oracle Java 6 comes in a special rpmbin format
          if $version == '6' {
            $package_type = 'rpmbin'
          } else {
            $package_type = 'rpm'
          }
<<<<<<< HEAD
        }
        default : {
          fail ("unsupported platform ${::operatingsystem}") }
=======
          $creates_path = "/usr/java/${install_path}"
        }
        'Debian' : {
            $package_type = 'tar.gz'
            $creates_path = "/usr/lib/jvm/${install_path}"
        }
        default : {
          fail ("unsupported platform ${$facts['os']['name']}") }
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      }

      $os = 'linux'
      $destination_dir = '/tmp/'
<<<<<<< HEAD
      $creates_path = "/usr/java/${install_path}"
    }
    default : {
      fail ( "unsupported platform ${::kernel}" ) }
  }

  # set java architecture nomenclature
  case $::architecture {
    'i386' : { $arch = 'i586' }
    'x86_64' : { $arch = 'x64' }
    default : {
      fail ("unsupported platform ${::architecture}")
=======
    }
    default : {
      fail ( "unsupported platform ${$facts['kernel']}" ) }
  }

  # Install required unzip packages for jce
  if $jce {
    ensure_resource('package', 'unzip', { 'ensure' => 'present' })
  }

  # set java architecture nomenclature
  case $facts['os']['architecture'] {
    'i386' : { $arch = 'i586' }
    'x86_64' : { $arch = 'x64' }
    'amd64' : { $arch = 'x64' }
    default : {
      fail ("unsupported platform ${$facts['os']['architecture']}")
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    }
  }

  # following are based on this example:
<<<<<<< HEAD
  # http://download.oracle.com/otn/java/jdk/7u80-b15/jre-7u80-linux-i586.rpm
  #
  # JaveSE 6 distributed in .bin format
  # http://download.oracle.com/otn/java/jdk/6u45-b06/jdk-6u45-linux-i586-rpm.bin
  # http://download.oracle.com/otn/java/jdk/6u45-b06/jdk-6u45-linux-i586.bin
=======
  # http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jre-7u80-linux-i586.rpm
  #
  # JaveSE 6 distributed in .bin format
  # http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586-rpm.bin
  # http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586.bin
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  # package name to download from Oracle's website
  case $package_type {
    'bin' : {
      $package_name = "${java_se}-${release_major}-${os}-${arch}.bin"
    }
    'rpmbin' : {
      $package_name = "${java_se}-${release_major}-${os}-${arch}-rpm.bin"
    }
    'rpm' : {
      $package_name = "${java_se}-${release_major}-${os}-${arch}.rpm"
    }
<<<<<<< HEAD
=======
    'tar.gz' : {
      $package_name = "${java_se}-${release_major}-${os}-${arch}.tar.gz"
    }
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    default : {
      $package_name = "${java_se}-${release_major}-${os}-${arch}.rpm"
    }
  }

<<<<<<< HEAD
=======
  # if complete URL is provided, use this value for source in archive resource
  if $url {
    $source = $url
  }
  elsif $release_hash != undef {
    $source = "${oracle_url}/${release_major}-${release_minor}/${release_hash}/${package_name}"
  }
  else {
    $source = "${oracle_url}/${release_major}-${release_minor}/${package_name}"
  }

>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  # full path to the installer
  $destination = "${destination_dir}${package_name}"
  notice ("Destination is ${destination}")

  case $package_type {
    'bin' : {
      $install_command = "sh ${destination}"
    }
    'rpmbin' : {
      $install_command = "sh ${destination} -x; rpm --force -iv sun*.rpm; rpm --force -iv ${java_se}*.rpm"
    }
    'rpm' : {
      $install_command = "rpm --force -iv ${destination}"
    }
<<<<<<< HEAD
=======
    'tar.gz' : {
      $install_command = "tar -zxf ${destination} -C /usr/lib/jvm"
    }
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    default : {
      $install_command = "rpm -iv ${destination}"
    }
  }

  case $ensure {
    'present' : {
      archive { $destination :
        ensure       => present,
<<<<<<< HEAD
        source       => "${oracle_url}${release_major}-${release_minor}/${package_name}",
        cleanup      => false,
        extract_path => '/tmp',
        cookie       => 'gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie',
      }->
      case $::kernel {
        'Linux' : {
          exec { "Install Oracle java_se ${java_se} ${version}" :
            path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
            command => $install_command,
            creates => $creates_path,
          }
        }
        default : {
          fail ("unsupported platform ${::kernel}")
=======
        source       => $source,
        cookie       => 'gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie',
        extract_path => '/tmp',
        cleanup      => false,
        creates      => $creates_path,
        proxy_server => $proxy_server,
        proxy_type   => $proxy_type,
      }
      case $facts['kernel'] {
        'Linux' : {
          case $facts['os']['family'] {
            'Debian' : {
              ensure_resource('file', '/usr/lib/jvm', {
                ensure => directory,
              })
              $install_requires = [Archive[$destination], File['/usr/lib/jvm']]
            }
            default : {
              $install_requires = [Archive[$destination]]
            }
          }
          exec { "Install Oracle java_se ${java_se} ${version} ${release_major} ${release_minor}" :
            path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
            command => $install_command,
            creates => $creates_path,
            require => $install_requires
          }

          if ($jce and $jce_download != undef) {
            $jce_path = $java_se ? {
              'jre' => "${creates_path}/lib/security",
              'jdk' => "${creates_path}/jre/lib/security"
            }
            archive { "/tmp/jce-${version}.zip":
              source        => $jce_download,
              cookie        => 'gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie',
              extract       => true,
              extract_path  => $jce_path,
              extract_flags => '-oj',
              creates       => "${jce_path}/US_export_policy.jar",
              cleanup       => false,
              proxy_server  => $proxy_server,
              proxy_type    => $proxy_type,
              require       => [
                Package['unzip'],
                Exec["Install Oracle java_se ${java_se} ${version} ${release_major} ${release_minor}"]
              ]
            }
          }
        }
        default : {
          fail ("unsupported platform ${$facts['kernel']}")
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
        }
      }
    }
    default : {
      notice ("Action ${ensure} not supported.")
    }
  }

}
