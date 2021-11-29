define puppet_enterprise::pg::grant_connect(
  String $database,
  String $schema,
  String $user,
) {
  puppet_enterprise::psql {"${title}/sql":
    db      => $database,
    command => "GRANT CONNECT ON DATABASE \"${database}\"
                TO \"${user}\"",
    unless  => "SELECT * FROM has_database_privilege(
                 '${user}',
                 '${database}',
                 'connect')
               WHERE has_database_privilege = true",
  }
}
