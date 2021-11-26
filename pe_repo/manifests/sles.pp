define pe_repo::sles(
  $agent_version   = $::aio_agent_build,
  $installer_build = $title,
  $pe_version      = $pe_repo::default_pe_build,
) {
  include pe_repo

  # These variables are needed by this template
  $prefix = $pe_repo::prefix
  $master = $pe_repo::master
  $port = $settings::masterport

  file { "${pe_repo::public_dir}/${pe_version}/${installer_build}.bash":
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('pe_repo/sles.bash.erb'),
  }

  $agent_version_sans_sha = split($agent_version, /\.g/)[0]
  pe_repo::repo { "${installer_build} ${pe_version}":
    agent_version   => $agent_version_sans_sha,
    installer_build => $installer_build,
    pe_version      => $pe_version,
    tarball_creates => "repodata",
    tarball_strip   => '5',
  }
}

