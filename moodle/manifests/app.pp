#
define moodle::app (
  $install_dir,
  $download_url,
  $default_lang,
  $wwwrooturl,
  $www_owner,
  $www_group,
  $dataroot,
  $dbtype,
  $dbhost,
  $dbname,
  $dbuser,
  $dbpass,
  $dbport,
  $dbsocket,
  $prefix,
  $fullname,
  $shortname,
  $summary,
  $adminuser,
  $adminpass,
  $adminemail,
) {

  if !($install_dir =~ /\/moodle$/) {
    fail("${install_dir} is not valid... install_dir must end with /moodle")
  }

  # manage the staging class
  class { 'staging':
    path  => '/var/staging',
  }

  # download the staged file
  staging::file { 'moodle.tgz':
    source => $download_url,
  }

  # manage the moodle data directory
  file { $dataroot:
    ensure => directory,
    owner  => $www_owner,
    group  => $www_group,
    mode   => '2777',
  }

  # ensure that the directory
  if !defined(File[$install_dir]) {
    file { $install_dir:
      ensure => directory,
      owner  => $www_owner,
      group  => $www_group,
      mode   => '0755',
    }
  }

  # get the parent directory... the moodle distribution
  # gets extracted to a 'moodle' directory
  $install_parent = getparent($install_dir)

  staging::extract { 'moodle.tgz':
    target  => $install_parent,
    user    => $www_owner,
    group   => $www_group,
    creates => "${install_dir}/install.php",
    require => [Staging::File['moodle.tgz'],File[$install_dir, $dataroot]],
  }

  # run the moode cli installer in non-interactive mode. the parameters for the installer
  # are configured in the template install_cmd.erb (to make variable substitution easier)
  exec { 'run-installer':
    command   => template('moodle/install_cmd.erb'),
    user      => $www_owner,
    group     => $www_group,
    logoutput => true,
    path      => '/usr/bin:/usr/local/bin',
    creates   => "${install_dir}/config.php",
    require   => Staging::Extract['moodle.tgz'],
  }

}
