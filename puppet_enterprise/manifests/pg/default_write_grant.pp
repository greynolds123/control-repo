# Grant write permissions to table_writer by default, for new tables created by
# table_creator.
define puppet_enterprise::pg::default_write_grant(
  String $database,
  String $schema,
  String $table_creator,
  String $table_writer,
  ) {
    puppet_enterprise::psql {"${title}/tables":
      db      => $database,
      command => "ALTER DEFAULT PRIVILEGES
                    FOR USER \"${table_creator}\"
                    IN SCHEMA \"${schema}\"
                  GRANT ALL PRIVILEGES ON TABLES
                    TO \"${table_writer}\"",

      # This is looking for the text:
      #   "\"pe-classifier-write\"=arwdDxt/\"pe-ha-replication\""
      # to show up in the defaclacl column (including the outer quotes)
      unless  => "SELECT
                    ns.nspname,
                    acl.defaclobjtype,
                    acl.defaclacl
                  FROM pg_default_acl acl
                  JOIN pg_namespace ns ON acl.defaclnamespace=ns.oid
                  WHERE acl.defaclacl::text ~ '.*\\\\\"${table_writer}\\\\\"=arwdDxt/\\\\\"${table_creator}\\\\\".*'
                    AND acl.defaclobjtype='r'
                    AND nspname = '${schema}'",
    }

    puppet_enterprise::psql {"${title}/sequences":
      db      => $database,
      command => "ALTER DEFAULT PRIVILEGES
                  FOR USER \"${table_creator}\"
                  IN SCHEMA \"${schema}\"
                  GRANT ALL PRIVILEGES ON SEQUENCES
                  TO \"${table_writer}\"",

      # This is looking for the text:
      #   "\"pe-classifier-write\"=rwU/\"pe-ha-replication\""
      # to show up in the defaclacl column (including the outer quotes)
      unless  => "SELECT
                    ns.nspname,
                    acl.defaclobjtype,
                    acl.defaclacl
                  FROM pg_default_acl acl
                  JOIN pg_namespace ns ON acl.defaclnamespace=ns.oid
                  WHERE acl.defaclacl::text ~ '.*\\\\\"${table_writer}\\\\\"=rwU/\\\\\"${table_creator}\\\\\".*'
                    AND acl.defaclobjtype='S'
                    AND nspname = '${schema}'",
    }

    puppet_enterprise::psql {"${title}/functions":
      db      => $database,
      command => "ALTER DEFAULT PRIVILEGES
                  FOR USER \"${table_creator}\"
                  IN SCHEMA \"${schema}\"
                  GRANT ALL PRIVILEGES ON FUNCTIONS
                  TO \"${table_writer}\"",

      # This is looking for the text:
      #   "\"pe-classifier-write\"=X/\"pe-ha-replication\""
      # to show up in the defaclacl column (including the outer quotes)
      unless  => "SELECT
                    ns.nspname,
                    acl.defaclobjtype,
                    acl.defaclacl
                  FROM pg_default_acl acl
                  JOIN pg_namespace ns ON acl.defaclnamespace=ns.oid
                  WHERE acl.defaclacl::text ~ '.*\\\\\"${table_writer}\\\\\"=X/\\\\\"${table_creator}\\\\\".*'
                    AND acl.defaclobjtype='f'
                    AND nspname = '${schema}'",
    }

  }
