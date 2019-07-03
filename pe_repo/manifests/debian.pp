define pe_repo::debian(
  $codename,
  $agent_version   = $::aio_agent_build,
  $installer_build = $title,
  $pe_version      = $pe_repo::default_pe_build,
) {
  include pe_repo

  # These variables are needed by this template
  $prefix = $pe_repo::prefix
  $master = $pe_repo::master
  $port = $settings::masterport
  $pc_version = $::pe_repo::pc_version
  $repo_base_url = "https://${master}:${port}${prefix}"
  $packages_url  = "https://${master}:${port}${prefix}/${pe_version}/${installer_build}"

  file { "${pe_repo::public_dir}/${pe_version}/${installer_build}.bash":
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('pe_repo/deb.bash.erb'),
  }

  $agent_version_sans_sha = split($agent_version, /\.g/)[0]
  pe_repo::repo { "${installer_build} ${pe_version}":
    agent_version   => $agent_version_sans_sha,
    installer_build => $installer_build,
    pe_version      => $pe_version,
    tarball_creates => 'conf',
    tarball_strip   => '3',
  }
}
