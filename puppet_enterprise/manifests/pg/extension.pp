# Manage database extensions
define puppet_enterprise::pg::extension(
  String $database,
  String $extension,
  String $version = 'latest',
  Enum['present','absent'] $ensure = 'present',
) {

  if $ensure == 'present' {
    $command     = "CREATE EXTENSION \"${extension}\""
    $unless_mod  = ''
  } else {
    $command     = "DROP EXTENSION \"${extension}\""
    $unless_mod  = 'NOT '
  }

  # Create the extension if it's not there already
  puppet_enterprise::psql { "${title}/create-or-drop-extension-${extension}":
    command => $command,
    unless  => "SELECT 1 WHERE ${unless_mod}EXISTS (SELECT 1 FROM pg_extension WHERE extname = '${extension}')",
    require => Pe_postgresql::Server::Db[$database],
  }

  if $ensure == 'present' {
    $extension_existance = "SELECT 1 FROM pg_extension WHERE extname='${extension}'"

    if $version == 'latest' {
      $alter_command = "ALTER EXTENSION \"${extension}\" UPDATE"
      $alter_unless = "SELECT 1 FROM pg_available_extensions WHERE name = '${extension}' AND default_version = installed_version"
    } else {
      $alter_command = "ALTER EXTENSION \"${extension}\" UPDATE TO '${version}'"
      $alter_unless = "${extension_existance} AND extversion='${version}'"
    }

    # Update the extension to the desired version if this is out of sync
    puppet_enterprise::psql { "${title}/update-extension-${extension}":
      command => $alter_command,
      unless  => $alter_unless,
      require => [Pe_postgresql::Server::Db[$database],
                  Puppet_enterprise::Psql["${title}/create-or-drop-extension-${extension}"]],
    }
  }
}
