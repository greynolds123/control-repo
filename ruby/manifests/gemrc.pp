# Manage global gemrc configuration
#
# This class allows the management of entries in /etc/gemrc
# That can be useful when, e.g. configuring a rubygems proxy.

# === Parameters
#
#  [*sources*]
#    A YAML array of remote gem repositories to install gems from
#
#  [*verbose*]
#    Verbosity of the gem command. false, true, and :really are the levels
#
#  [*update_sources*]
#    Enable/disable automatic updating of repository metadata
#
#  [*backtrace*]
#    Print backtrace when RubyGems encounters an error
#
#  [*gempath*]
#    The paths in which to look for gems
#
#  [*disable_default_gem_server*]
#    Force specification of gem server host on push
#
#  [*gem_command*]
#    A string containing arguments for the specified gem command
#    This takes an array of Hashes, i.e.:
#
#    gem_command => {
#      'gem'  => [ 'no-ri', 'http-proxy=http://waf-proxy' ],
#      'push' => [ 'host=https://our.rubygems.host' ],
#    }

class ruby::gemrc (
<<<<<<< HEAD
<<<<<<< HEAD
  $sources                    = undef,
  $verbose                    = undef,
  $update_sources             = undef,
  $backtrace                  = undef,
  $gempath                    = undef,
  $gem_command                = undef,
  $gemrc                      = $::ruby::params::gemrc,
  $owner                      = 'root',
  $group                      = 'root',
  $mode                       = '0644',
  $disable_default_gem_server = undef
) inherits ruby::params {

  if $verbose != undef and $verbose != ':really' {
    validate_bool($verbose)
  }
  if $update_sources {
    validate_bool($update_sources)
  }
  if $backtrace {
    validate_bool($backtrace)
  }
  if $disable_default_gem_server {
    validate_bool($disable_default_gem_server)
  }

=======
  $sources                                              = undef,
  Optional[Variant[Boolean, Enum[':really']]] $verbose  = undef,
  Optional[Boolean] $update_sources                     = undef,
  Optional[Boolean] $backtrace                          = undef,
  Optional[Array[String]] $gempath                      = undef,
  Optional[Hash] $gem_command                           = undef,
  Stdlib::Absolutepath $gemrc                           = $::ruby::params::gemrc,
  String $owner                                         = 'root',
  String $group                                         = 'root',
  Pattern[/[0-7]{4}/] $mode                             = '0644',
  Optional[Boolean] $disable_default_gem_server         = undef
) inherits ruby::params {

>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
=======
  $sources                                              = undef,
  Optional[Variant[Boolean, Enum[':really']]] $verbose  = undef,
  Optional[Boolean] $update_sources                     = undef,
  Optional[Boolean] $backtrace                          = undef,
  Optional[Array[String]] $gempath                      = undef,
  Optional[Hash] $gem_command                           = undef,
  Stdlib::Absolutepath $gemrc                           = $::ruby::params::gemrc,
  String $owner                                         = 'root',
  String $group                                         = 'root',
  Pattern[/[0-7]{4}/] $mode                             = '0644',
  Optional[Boolean] $disable_default_gem_server         = undef
) inherits ruby::params {

>>>>>>> b234704ac85e5944ab85d8a528657f7c75be3c6d
  $ensure = pick ($sources
      , $verbose
      , $update_sources
      , $backtrace
      , $gempath
      , $disable_default_gem_server
      , $gem_command
      , 'No need for gemrc.'
  ) ? {
    'No need for gemrc.' => 'absent',
    default              => 'file',
  }

  file { 'gemrc':
    ensure  => $ensure,
    path    => $::ruby::params::gemrc,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    content => template('ruby/gemrc.yaml.erb'),
  }
}
