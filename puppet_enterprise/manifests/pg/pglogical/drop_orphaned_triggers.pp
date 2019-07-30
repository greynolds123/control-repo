class puppet_enterprise::pg::pglogical::drop_orphaned_triggers () {
  # Post upgrade, we need to remove pglogical triggers if they are in an orphaned state. See (PE-23115)

  $default_databases = [
    $puppet_enterprise::classifier_database_name,
    $puppet_enterprise::rbac_database_name,
    $puppet_enterprise::activity_database_name,
  ]

  if versioncmp(pe_current_server_version(), '2015.3.0') >= 0 {
    $databases = $default_databases + [$puppet_enterprise::orchestrator_database_name]
  } else {
    $databases = $default_databases
  }

  $databases.map |$database_name| {
    puppet_enterprise::psql { "Drop pglogical trigger pglogical_truncate_trigger_add for ${database_name} sql":
      db      => $database_name,
      command => 'DROP EVENT TRIGGER IF EXISTS pglogical_truncate_trigger_add',
      unless  => "SELECT * FROM pg_event_trigger AS evt
                  JOIN pg_depend AS d on evt.oid = d.objid
                  JOIN pg_extension AS e on e.oid = d.refobjid
                  WHERE e.extname = 'pglogical'
                  AND evt.evtname = 'pglogical_truncate_trigger_add'",
    }

    puppet_enterprise::psql { "Drop pglogical trigger pglogical_dependency_check_trigger for ${database_name} sql":
      db      => $database_name,
      command => 'DROP EVENT TRIGGER IF EXISTS pglogical_dependency_check_trigger',
      unless  => "SELECT * FROM pg_event_trigger AS evt
                  JOIN pg_depend AS d on evt.oid = d.objid
                  JOIN pg_extension AS e on e.oid = d.refobjid
                  WHERE e.extname = 'pglogical'
                  AND evt.evtname = 'pglogical_dependency_check_trigger'",
    }
  }
}
