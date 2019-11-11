define pe_repo::sol10(
  $agent_version   = $::aio_agent_version,
  $installer_build = $title,
  $pe_version      = $pe_repo::default_pe_build,
) {
  include pe_repo

  File {
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  $target_dir = "${pe_repo::public_dir}/${pe_version}/${installer_build}-${agent_version}"
  $tarball_test = "test -f ${target_dir}/puppet-agent*.pkg.gz"

  # We don't know the actual package filenames until we have our hands on the
  # build... This will generate the exact list of packages.
  exec { "generate_package_listing ${installer_build} ${pe_version}":
    command   => "ls *.pkg.gz > packages.txt",
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
    content => template('pe_repo/sol10.bash.erb'),
  }

  # Avoids a puppet error on a compile master when solaris10 platform is specified
  # but the primary hasn't yet generated the base target_dir.
  if !pe_compile_master() {
    file { "${target_dir}/solaris-noask":
      content => template('pe_repo/solaris-noask'),
    }
  }

  pe_repo::repo { "${installer_build} ${pe_version}":
    agent_version   => $agent_version,
    installer_build => $installer_build,
    pe_version      => $pe_version,
    tarball_unless  => $tarball_test,
    tarball_strip   => '4',
    before          => Exec["generate_package_listing ${installer_build} ${pe_version}"],
  }
}
