# A helper for converting pem-formatted certificates (like we use in most
# places) to pk8 format, which is required by the posgrestsql jdbc driver for
# client cert authentication.
#
# @param pem_file [String] The path to the source pem file to be converted
# @param owner [String] The owner of the output pk8 file
# @param group [String] The group of the output pk8 file
# @param mode [String] The mode of the output pk8 file
# @param pk8_file [String] ($title) The path to the output pk8 file.
define puppet_enterprise::certs::pk8_cert(
  String $pem_file,
  String $owner,
  String $group,
  String $mode,
  String $pk8_file = $title
) {
  exec { $pk8_file:
    path    => [ '/opt/puppetlabs/puppet/bin', $::facts['path'] ],
    command => "openssl pkcs8 -topk8 -inform PEM -outform DER -in ${pem_file} -out ${pk8_file} -nocrypt",
    # Generate a .pk8 key if one doesn't exist or is older than the .pem input.
    # NOTE: bash file time checks, like -ot, can't always discern sub-second
    # differences.
    onlyif => "test ! -e '${pk8_file}' -o '${pk8_file}' -ot '${pem_file}'"
  }

  file { $pk8_file:
    ensure => present,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
}
