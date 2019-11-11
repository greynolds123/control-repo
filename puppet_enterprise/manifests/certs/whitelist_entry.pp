# == Define: puppet_enterprise::certs::whitelist::entry
#
# A defined type for adding a certificate to an existing certificate whitelist.
# If a file_line has already been defined with the same target and certname, it
# will not be defined again.
#
# A certificate whitelist is a basic text file with one certificate
# per line that an applciation will load and parse.
#
# Example consumers would be puppetdb and rbac.
#
# === Parameters
#
# [*certname*]
#   String. The name of the certificate to add to this file.
#
# [*target*]
#   String. Absolute target to where the certificate file should be created.
#
# === Examples
#
#   puppet_enterprise::certs::whitelist::entry { "${certificate_whitelist_target}:#{certname}":
#     certname => 'example.local.vm'
#     target   => '/etc/puppetlabs/puppetdb/certificate-whitelist'
#   }
#
define puppet_enterprise::certs::whitelist_entry(
  $target,
  $certname = $title
) {
  if ! defined(Pe_file_line["${target}:${certname}"]) {
    pe_file_line { "${target}:${certname}":
      path => $target,
      line => $certname,
    }
  }
}

