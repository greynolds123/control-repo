# This defined type is a utility for adding sections to Puppet's fileserver.conf.
# It is not intended as an exhaustive interface to the fileserver.conf settings,
# and only provides for the limited needs of Puppet Enterprise to access PE
# modules and puppet-agent packages through the master's fileserver.
#
# @param mountpoint [String] The name of the mount section to be configured in
#   fileserver.conf, and to be used in File source references.
# @param path [String] The path on disk to the directory Puppet will be serving.
# @param allow [String] The permissions on the mount; defaults to '*' (open).
#   Anything more restrictive is deprecated and should be handled in auth.conf.
define puppet_enterprise::fileserver_conf(
  $mountpoint,
  $path,
  $allow = "*",
) {
  $fileserver = '/etc/puppetlabs/puppet/fileserver.conf'

  augeas { "fileserver.conf ${mountpoint}":
    changes   => [
      "set /files${fileserver}/${mountpoint}/path ${path}",
      "set /files${fileserver}/${mountpoint}/allow *",
    ],
    incl      => $fileserver,
    load_path => "${puppet_enterprise::puppet_share_dir}/augeas/lenses/dist",
    lens      => 'PuppetFileserver.lns',
  }

}
