define pe_repo::aix(
  $agent_version   = $::aio_agent_version,
  $installer_build = $title,
  $pe_version      = $pe_repo::default_pe_build,
) {
  include pe_repo

  File {
    ensure => file,
    mode   => '0644',
    owner  => root,
    group  => root,
  }

  $target_dir = "${pe_repo::public_dir}/${pe_version}/${installer_build}-${agent_version}"
  $tarball_test = "test -f ${target_dir}/puppet-agent*.rpm"

  # We don't know the actual package filenames until we have our hands on the
  # build... This will generate the exact list of packages.
  exec { "generate_package_listing ${installer_build} ${pe_version}":
    command   => "ls *.rpm > packages.txt",
    cwd       => "${target_dir}",
    creates   => "${target_dir}/packages.txt",
    onlyif    => $tarball_test,
    path      => "/bin:/usr/bin",
    logoutput => on_failure,
  }

  # These variables are needed by the templates
  $prefix = $pe_repo::prefix
  $master = $pe_repo::master
  $port = $settings::masterport

  file { "${pe_repo::public_dir}/${pe_version}/${installer_build}.bash":
    content => template('pe_repo/aix.bash.erb'),
  }

  pe_repo::repo { "${installer_build} ${pe_version}":
    agent_version   => $agent_version,
    installer_build => $installer_build,
    tarball_creates => "repodata",
    pe_version      => $pe_version,
    tarball_unless  => $tarball_test,
    tarball_strip   => '5',
    before          => Exec["generate_package_listing ${installer_build} ${pe_version}"],
  }
}
