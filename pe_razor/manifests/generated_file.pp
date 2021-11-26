# This is a defined type for files that are generated
# from a script/command. It captures the pattern
# of:
#  (1) Generate the file using a command/script if the
#  file does not exist. This is done with an Exec resource.
#
#  (2) Ensure that the generated file contains the right
#  metadata, such as the right owner/group, permissions,
#  etc. This part is done with a File resource. Note for
#  pe_razor's use-case, defaults for owner/group and
#  permissions are set by the caller. We could add extra
#  params. for those values (e.g. owner/group, mode) here
#  at some point in the future if we need to, but this is
#  unnecessary clutter for a highly specific use case.
# 
# As a concrete example, we use this defined type when generating
# SSL certs and keys. Although modules on the Forge provide Puppet
# types for SSL certs and keys, we cannot use them as external
# dependencies due to potential namespace conflicts. Since we generate
# only a small number of certs and keys, it is best to just use an Exec
# resource with openssl as the command, and then declare the generated
# cert/key file as a File resource to ensure that it contains the right
# file metadata (e.g. owner/group, permissions). That is exactly the pattern
# captured by the generated_file type.
define pe_razor::generated_file(
  $command,
  $file_path = $title,
  $path_env_var = '/usr/bin',
){
  $file_resource_title = "generated file for ${title}"

  exec { "generate file ${title}":
    command => $command,
    creates => $file_path,
    path    => $path_env_var,
    before  => File[$file_resource_title],
  }

  file { $file_resource_title :
    ensure => file,
    path   => $file_path,
  }
}
