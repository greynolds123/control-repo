# Enforce the ownership of all tables and functions in the given schema.
# (sequence ownership automatically follows that of the linked table, so it is
# automatically updated)
define puppet_enterprise::pg::enforce_ownership (
  String $database,
  String $schema,
  String $owner
) {
  Puppet_enterprise::Psql {
    db => $database
  }

  puppet_enterprise::psql {"${title}/tables":
    command => "
      DO $$
        DECLARE r record;
        BEGIN
          FOR r IN
            SELECT 'ALTER TABLE \"${schema}\".\"' || tablename || '\" OWNER TO \"${owner}\";'
              AS a
              FROM pg_tables
              WHERE schemaname = '${schema}'
          LOOP
            EXECUTE r.a;
          END LOOP;
        END
      $$;
    ",

    # query that returns rows if there are *no* tables owned by other users
    unless => "
      SELECT * FROM
        (SELECT COUNT(*) FROM pg_tables
           WHERE schemaname = '${schema}'
           AND tableowner != '${owner}') a
      WHERE a.count = 0
    "
  }

  # for functions, ignore any that are owned by pe-postgres; these seem to show
  # up in the public schema sometimes, perhaps put there by pg extensions.
  puppet_enterprise::psql {"${title}/functions":
    command => "
      DO $$
        DECLARE r record;
        BEGIN
          FOR r IN
            SELECT 'ALTER FUNCTION \"${schema}\".\"' || p.proname || '\"(' || pg_get_function_identity_arguments(p.oid) || ') OWNER TO \"${owner}\";'
              AS a
              FROM pg_proc p
              JOIN pg_namespace n ON p.pronamespace = n.oid
              JOIN pg_roles ON p.proowner = pg_roles.oid
              WHERE n.nspname = '${schema}'
              AND pg_roles.rolname != 'pe-postgres'
          LOOP
            EXECUTE r.a;
          END LOOP;
        END
      $$;
    ",

    # query that returns rows if there are *no* functions owned by other users
    unless => "
      SELECT * FROM
        (SELECT count(*)
         FROM pg_proc p
         JOIN pg_roles r ON p.proowner = r.oid
         JOIN pg_namespace n on p.pronamespace = n.oid
         WHERE n.nspname = '${schema}'
           AND r.rolname != '${owner}'
           AND r.rolname != 'pe-postgres') a
      WHERE a.count = 0
    "
  }
}
