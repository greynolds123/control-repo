# Coarsely manage a pglogical replication set. For now, the replication set must
# already exist (this is ok since we use the 'default' replication set
# everywhere). It will be either empty or contain all tables in the schema.
define puppet_enterprise::pg::pglogical::replication_set (
  Enum['populated', 'empty'] $ensure,
  String $database,
  String $replication_set_name,
  String $schema
) {
  # lint:ignore:case_without_default
  case $ensure {
    'populated': {
      puppet_enterprise::psql { "pglogical replication set ${title} populate-sql":
        db      => $database,
        command => "SELECT pglogical.replication_set_add_all_tables('${replication_set_name}', ARRAY['${schema}'])",
        # query that returns rows if all tables are in the replication set.
        # The count(*) query tell you how many tables aren't in the replication set.
        unless  => "SELECT *
                    FROM (SELECT COUNT(*)
                          FROM (SELECT relname from pglogical.tables
                                WHERE set_name='${replication_set_name}'
                                AND nspname='${schema}') pgl
                          RIGHT OUTER JOIN information_schema.tables pg
                          ON pgl.relname=pg.table_name
                          WHERE pg.table_schema='${schema}'
                          AND relname IS NULL) c
                    WHERE c.count = 0",
      }
    }

    'empty': {
      puppet_enterprise::psql { "pglogical replication set ${title} empty-sql":
        db      => $database,
        command => "SELECT pglogical.replication_set_remove_table('${replication_set_name}', relname::text)
                    FROM pglogical.tables
                    WHERE set_name='${replication_set_name}'
                    AND nspname='${schema}'",
        # query that returns rows if the replication set is empty
        unless  => "SELECT *
                    FROM (SELECT COUNT(*)
                          FROM pglogical.tables
                          WHERE set_name='${replication_set_name}') c
                    WHERE c.count = 0",
      }
    }
  }
  # lint:endignore
}


