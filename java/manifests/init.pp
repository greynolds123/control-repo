# Class: java
#
# This module manages the Java runtime package
#
# Parameters:
#
#  [*distribution*]
#    The java distribution to install. Can be one of "jdk" or "jre",
#    or other platform-specific options where there are multiple
#    implementations available (eg: OpenJDK vs Oracle JDK).
#
<<<<<<< HEAD
#
=======
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
#  [*version*]
#    The version of java to install. By default, this module simply ensures
#    that java is present, and does not require a specific version.
#
#  [*package*]
#    The name of the java package. This is configurable in case a non-standard
#    java package is desired.
#
#  [*package_options*]
#    Array of strings to pass installation options to the 'package' Puppet resource.
#    Options available depend on the 'package' provider for the target OS.
#
#  [*java_alternative*]
#    The name of the java alternative to use on Debian systems.
#    "update-java-alternatives -l" will show which choices are available.
#    If you specify a particular package, you will almost always also
#    want to specify which java_alternative to choose. If you set
#    this, you also need to set the path below.
#
#  [*java_alternative_path*]
#    The path to the "java" command on Debian systems. Since the
#    alternatives system makes it difficult to verify which
#    alternative is actually enabled, this is required to ensure the
#    correct JVM is enabled.
#
<<<<<<< HEAD
=======
#  [*java_home*]
#    The path to where the JRE is installed. This will be set as an
#    environment variable.
#
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
# Actions:
#
# Requires:
#
# Sample Usage:
#
class java(
<<<<<<< HEAD
  $distribution          = 'jdk',
  $version               = 'present',
  $package               = undef,
  $package_options       = undef,
  $java_alternative      = undef,
  $java_alternative_path = undef
) {
  include java::params

  validate_re($version, 'present|installed|latest|^[.+_0-9a-zA-Z:~-]+$')
  
  if $package_options != undef {
    validate_array($package_options)
  }

  if has_key($java::params::java, $distribution) {
    $default_package_name     = $java::params::java[$distribution]['package']
    $default_alternative      = $java::params::java[$distribution]['alternative']
    $default_alternative_path = $java::params::java[$distribution]['alternative_path']
    $java_home                = $java::params::java[$distribution]['java_home']
  } else {
    fail("Java distribution ${distribution} is not supported.")
=======
  String $distribution                                              = 'jdk',
  Pattern[/present|installed|latest|^[.+_0-9a-zA-Z:~-]+$/] $version = 'present',
  Optional[String] $package                                         = undef,
  Optional[Array] $package_options                                  = undef,
  Optional[String] $java_alternative                                = undef,
  Optional[String] $java_alternative_path                           = undef,
  Optional[String] $java_home                                       = undef
) {
  include ::java::params

  $default_package_name = has_key($java::params::java, $distribution) ? {
    false   => undef,
    default => $java::params::java[$distribution]['package'],
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  }

  $use_java_package_name = $package ? {
    undef   => $default_package_name,
    default => $package,
  }

<<<<<<< HEAD
=======

  ## Weird logic........
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  ## If $java_alternative is set, use that.
  ## Elsif the DEFAULT package is being used, then use $default_alternative.
  ## Else undef
  $use_java_alternative = $java_alternative ? {
<<<<<<< HEAD
    undef   => $use_java_package_name ? {
      $default_package_name => $default_alternative,
=======
    undef                   => $use_java_package_name ? {
      $default_package_name => has_key($java::params::java, $distribution) ? {
        default => $java::params::java[$distribution]['alternative'],
        false => undef,
      },
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      default               => undef,
    },
    default => $java_alternative,
  }

  ## Same logic as $java_alternative above.
  $use_java_alternative_path = $java_alternative_path ? {
<<<<<<< HEAD
    undef   => $use_java_package_name ? {
      $default_package_name => $default_alternative_path,
=======
    undef                   => $use_java_package_name ? {
      $default_package_name => has_key($java::params::java, $distribution) ? {
      default               => $java::params::java[$distribution]['alternative_path'],
      false                 => undef,
      },
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      default               => undef,
    },
    default => $java_alternative_path,
  }

<<<<<<< HEAD
=======
  $use_java_home = $java_home ? {
    undef                   => $use_java_package_name ? {
      $default_package_name => has_key($java::params::java, $distribution) ? {
        default             => $java::params::java[$distribution]['java_home'],
        false               => undef,
      },
      default               => undef,
    },
    default => $java_home,
  }

  ## This should only be required if we did not override all the information we need.
  # One of the defaults is missing and its not intentional:
  if ((
      $use_java_package_name == undef or $use_java_alternative == undef or
      $use_java_alternative_path == undef or $use_java_home == undef
    ) and (
      ! has_key($::java::params::java, $distribution)
    )) {
    fail("Java distribution ${distribution} is not supported. Missing default values.")
  }

>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  $jre_flag = $use_java_package_name ? {
    /headless/ => '--jre-headless',
    default    => '--jre'
  }

  if $::osfamily == 'Debian' {
    # Needed for update-java-alternatives
    package { 'java-common':
      ensure => present,
      before => Class['java::config'],
    }
  }

  anchor { 'java::begin:': }
<<<<<<< HEAD
  ->
  package { 'java':
=======
  -> package { 'java':
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    ensure          => $version,
    install_options => $package_options,
    name            => $use_java_package_name,
  }
<<<<<<< HEAD
  ->
  class { 'java::config': }
=======
  -> class { 'java::config': }
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  -> anchor { 'java::end': }

}
