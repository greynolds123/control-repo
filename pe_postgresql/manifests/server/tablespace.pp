# This module creates tablespace. See README.md for more details.
define pe_postgresql::server::tablespace(
  $location,
  $owner   = undef,
  $spcname = $title
) {
  $user      = $pe_postgresql::server::user
  $group     = $pe_postgresql::server::group
  $port      = $pe_postgresql::server::port
  $psql_path = $pe_postgresql::server::psql_path

  Pe_postgresql_psql {
    db         => $pe_postgresql::server::default_database,
    psql_user  => $user,
    psql_group => $group,
    psql_path  => $psql_path,
    port       => $port,
  }

  if ($owner == undef) {
    $owner_section = ''
  } else {
    $owner_section = "OWNER \"${owner}\""
  }

  $create_tablespace_command = "CREATE TABLESPACE \"${spcname}\" ${owner_section} LOCATION '${location}'"

  file { $location:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  $create_ts = "Create tablespace '${spcname}'"
  pe_postgresql_psql { "Create tablespace '${spcname}'":
    command => $create_tablespace_command,
    unless  => "SELECT spcname FROM pg_tablespace WHERE spcname='${spcname}'",
    require => [Class['pe_postgresql::server'], File[$location]],
  }

  if($owner != undef and defined(Pe_postgresql::Server::Role[$owner])) {
    Pe_postgresql::Server::Role[$owner]->Pe_postgresql_psql[$create_ts]
  }
}
