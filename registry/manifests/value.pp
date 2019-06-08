# = Define: registry::value
#
# This defined resource type provides a higher level of abstraction on top of
# the registry_key and registry_value resources.  Using this defined resource
# type, you do not need to explicitly manage the parent key for a particular
# value.  Puppet will automatically manage the parent key for you.
#
# == Parameters:
#
# key:: The path of key the value will placed inside.
#
# value:: The name of the registry value to manage.  This will be copied from
#         the resource title if not specified.  The special value of
#         '(default)' may be used to manage the default value of the key.
#
# type:: The type the registry value.  Defaults to 'string'.  See the output of
#        `puppet describe registry_value` for a list of supported types in the
#        "type" parameter.
#
# data:: The data to place inside the registry value.
#
# == Actions:
#   - Manage the parent key if not already managed.
#   - Manage the value
#
# == Requires:
#   - Registry Module
#   - Stdlib Module
#
# == Sample Usage:
#
# This example will automatically manage the key.  It will also create a value
# named 'puppetmaster' inside this key.
#
#   class myapp {
#     registry::value { 'puppetmaster':
#       key => 'HKLM\Software\Vendor\PuppetLabs',
#       data => 'puppet.puppetlabs.com',
#     }
#   }
#
define registry::value (
<<<<<<< HEAD
  $key,
  $value = undef,
  $type  = 'string',
  $data  = undef,
=======
  Pattern[/^\w+/]           $key,
  Optional[String]          $value = undef,
  Optional[Pattern[/^\w+/]] $type = 'string',
  Optional[Variant[
    String,
    Numeric,
    Array[String]
  ]]                       $data  = undef,
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
) {

  # ensure windows os
  if $::operatingsystem != 'windows'{
    fail("Unsupported OS ${::operatingsystem}")
  }

<<<<<<< HEAD
  # validate our inputs.
  validate_re($key, '^\w+',
    "key parameter must not be empty but it is key => '${key}'")
  validate_re($type, '^\w+',
    "type parameter must not be empty but it is type => '${type}'")



=======
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  $value_real = $value ? {
    undef       => $name,
    '(default)' => '',
    default     => $value,
  }

  # Resource defaults.
  Registry_key { ensure => present }
  Registry_value { ensure => present }

  if !defined(Registry_key[$key]) {
    registry_key { $key: }
  }

  # If value_real is an empty string then the default value of the key will be
<<<<<<< HEAD
  # managed.
  registry_value { "${key}\\${value_real}":
=======
  # managed.  Use a double backslash so value names with a backslash are supported
  registry_value { "${key}\\\\${value_real}":
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    type => $type,
    data => $data,
  }
}

