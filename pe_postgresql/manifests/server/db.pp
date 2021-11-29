# Define for conveniently creating a role, database and assigning the correct
# permissions. See README.md for more details.
define pe_postgresql::server::db (
  $user,
  $password,
  $dbname     = $title,
  $encoding   = $pe_postgresql::server::encoding,
  $locale     = $pe_postgresql::server::locale,
  $ctype      = $pe_postgresql::server::ctype,
  $collate    = $pe_postgresql::server::collate,
  $grant      = 'ALL',
  $tablespace = undef,
  $template   = 'template0',
  $istemplate = false,
  $owner      = undef
) {

  if ! defined(Pe_postgresql::Server::Database[$dbname]) {
    pe_postgresql::server::database { $dbname:
      encoding   => $encoding,
      tablespace => $tablespace,
      template   => $template,
      locale     => $locale,
      ctype      => $ctype,
      collate    => $collate,
      istemplate => $istemplate,
      owner      => $owner,
    }
  }

  if ! defined(Pe_postgresql::Server::Role[$user]) {
    pe_postgresql::server::role { $user:
      password_hash => $password,
    }
  }

  if ! defined(Pe_postgresql::Server::Database_grant["GRANT ${user} - ${grant} - ${dbname}"]) {
    pe_postgresql::server::database_grant { "GRANT ${user} - ${grant} - ${dbname}":
      privilege => $grant,
      db        => $dbname,
      role      => $user,
    }
  }

  if($tablespace != undef and defined(Pe_postgresql::Server::Tablespace[$tablespace])) {
    Pe_postgresql::Server::Tablespace[$tablespace]->Pe_postgresql::Server::Database[$name]
  }
}
