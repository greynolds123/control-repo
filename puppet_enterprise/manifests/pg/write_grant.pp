# Grant write permissions to $table_writer for all objects in $schema of
# $database
define puppet_enterprise::pg::write_grant(
  String $database,
  String $schema,
  String $table_writer,
) {
  puppet_enterprise::psql {"${title}/tables":
    db      => $database,
    command => "GRANT ALL PRIVILEGES
                ON ALL TABLES IN SCHEMA \"${schema}\"
                TO \"${table_writer}\"",
    # query that returns rows if all tables are writable.
    unless  => "SELECT * FROM (
                  SELECT COUNT(*)
                  FROM pg_tables
                  WHERE schemaname='public'
                    AND has_table_privilege('${table_writer}', schemaname || '.' || tablename, 'INSERT')=false
                ) x
                WHERE x.count=0",

  }

  puppet_enterprise::psql {"${title}/sequences":
    db      => $database,
    command => "GRANT ALL PRIVILEGES
                ON ALL SEQUENCES IN SCHEMA \"${schema}\"
                TO \"${table_writer}\"",
    unless  => "SELECT * FROM (
                  SELECT COUNT(*)
                  FROM information_schema.sequences
                  WHERE sequence_schema='public'
                    AND has_sequence_privilege('${table_writer}', sequence_schema || '.' || sequence_name, 'UPDATE')=false
                ) x
                WHERE x.count=0",
  }

  puppet_enterprise::psql {"${title}/functions":
    db      => $database,
    command => "GRANT ALL PRIVILEGES
                ON ALL FUNCTIONS IN SCHEMA \"${schema}\"
                TO \"${table_writer}\"",
    unless  => "SELECT * FROM (
                  SELECT COUNT(*)
                  FROM pg_catalog.pg_proc p
                  LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
                  WHERE n.nspname='public'
                    AND has_function_privilege('${table_writer}', p.oid, 'execute')=false
                ) x
                WHERE x.count=0",
  }
}



