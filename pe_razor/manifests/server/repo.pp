# Creates a repo for serving up razor packages and downloads the PE tarball
#
# @todo Change the exec statement to use pe_staging?
#
# @param target [String] Absolute path to where the repo should be created.
# @param url  [String] The URL to download the Puppet Enterprise tarball from
define pe_razor::server::repo (
  $target,
  $pe_tarball_base_url,
) {
  include pe_razor::params


  # @todo danielp 2013-12-31: This listing will need to be adjusted when more
  # platforms are validated for use with Razor.
  $pe_version = pe_build_version()
  $build   = "puppet-enterprise-${pe_version}-${::platform_tag}"
  $file    = "${build}.${pe_razor::params::file_extension}"
  $root    = "${build}/packages/${::platform_tag}"
  $url     = "${pe_tarball_base_url}/${pe_version}/${file}"


  # Template uses:
  # - $target
  # - $file
  # - $url
  # - $root
  exec { 'unpack the razor repo':
    # That should allow someone on a 1Mbit link to succeed at this, without
    # hanging *forever* if the network is screwed.  A long time, sure, but
    # not forever.
    provider => shell,
    timeout  => 3600,
    command  => template('pe_razor/install-repo.sh.erb'),
    path     => '/usr/local/bin:/bin:/usr/bin',
    creates  => "${target}/repodata/repomd.xml.asc"
  }

  yumrepo { 'pe-razor':
    baseurl  => "file://${target}",
    descr    => 'Puppet Enterprise Razor Packages',
    enabled  => 1,
    gpgcheck => 0,
    require  => Exec['unpack the razor repo'],
  }
}
