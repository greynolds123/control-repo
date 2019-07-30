# A wrapper for pe_postgres_psql with some reasonable defaults.
define puppet_enterprise::psql(
  String $db,
  String $command,
  Integer $port      = Integer($puppet_enterprise::database_port),
  String $psql_user  = $puppet_enterprise::pg_user,
  String $psql_group = $puppet_enterprise::pg_group,
  String $psql_path  = $puppet_enterprise::pg_psql_path,
  $unless = undef
) {

  pe_postgresql_psql { $title:
    port       => $port,
    psql_user  => $psql_user,
    psql_group => $psql_group,
    psql_path  => $psql_path,
    db         => $db,
    command    => $command,
    unless     => $unless,
  }
}
