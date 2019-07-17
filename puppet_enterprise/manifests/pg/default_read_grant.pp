# Grant read permissions to table_reader by default, for new tables created by
# table_creator.
define puppet_enterprise::pg::default_read_grant(
  String $database,
  String $schema,
  String $table_creator,
  String $table_reader,
) {
  puppet_enterprise::psql {"${title}/sql":
    db      => $database,
    command => "ALTER DEFAULT PRIVILEGES
                  FOR USER \"${table_creator}\"
                  IN SCHEMA \"${schema}\"
                GRANT SELECT ON TABLES
                  TO \"${table_reader}\"",
    unless  => "SELECT
                  ns.nspname,
                  acl.defaclobjtype,
                  acl.defaclacl
                FROM pg_default_acl acl
                JOIN pg_namespace ns ON acl.defaclnamespace=ns.oid
                WHERE acl.defaclacl::text ~ '.*\\\\\"${table_reader}\\\\\"=r/\\\\\"${table_creator}\\\\\".*'
                AND nspname = '${schema}'",
  }
}
