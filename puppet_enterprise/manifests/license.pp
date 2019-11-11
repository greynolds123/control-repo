# Class for copying the license file from the PE Master node to the PE Console node.
#
# @param manage_license_key [Boolean] Allows a user to skip having the license
#        key be managed by PE.  If used then the user is responsible for placing the file
#        on the master and console nodes with the correct permissions.
class puppet_enterprise::license (
  Boolean $manage_license_key = true
) inherits puppet_enterprise {

  # We only want to manage the license file if it actually exists. If it
  # doesn't, the file() function will fail, so we still have to pass /dev/null
  # as a default. So we check whether we have any content before making the
  # resource.
  $license_content = file($puppet_enterprise::license_key_path, '/dev/null')

  if $manage_license_key and !pe_empty($license_content) {
    file { $puppet_enterprise::params::dest_license_key_path:
      ensure  => present,
      content => $license_content,
      mode    => '0644',
    }
  }
}
