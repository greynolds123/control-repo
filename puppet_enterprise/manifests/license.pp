# Class for copying the license file from the PE Master node to the PE Console node.
#
# @param $license_key [String] Deprecated. Use puppet_enterprise::license_key_path.
class puppet_enterprise::license(
  $license_key = undef,
) inherits puppet_enterprise {

  if $license_key != undef {
    $message =  "puppet_enterprise::license::license_key is deprecated and will be removed in the next
    PE version. Please use puppet_enterprise::license_key_path. If using the Node Manager, the class
    is located in the PE Infrastructure node group."

    notify { "puppet_enterprise::license::license_key deprecation":
      message   => $message,
      loglevel  => warning,
    }
  }

  # Support using the deprecated parameter for now so things don't break
  $_license_key = pe_pick($license_key, $puppet_enterprise::license_key_path)

  # We only want to manage the license file if it actually exists. If it
  # doesn't, the file() function will fail, so we still have to pass /dev/null
  # as a default. So we check whether we have any content before making the
  # resource.
  $license_content = file($_license_key, '/dev/null')

  if !pe_empty($license_content) {
    file { $puppet_enterprise::params::dest_license_key_path:
      ensure  => present,
      content => $license_content,
      mode    => '0644',
    }
  }
}
