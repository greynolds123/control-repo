define moodle::db (
  $create_db,
  $create_db_user,
  $dbname,
  $dbhost,
  $dbuser,
  $dbpass,
) {
  validate_bool($create_db,$create_db_user)
  validate_string($dbname,$dbhost,$dbuser,$dbpass)

  ## Set up DB using puppetlabs-mysql defined type
  if $create_db {
    mysql_database { "${dbhost}/${dbname}":
      name    => $dbname,
      charset => 'utf8',
    }
  }
  if $create_db_user {
    mysql_user { "${dbuser}@${dbhost}":
      password_hash => mysql_password($dbpass),
    }
    mysql_grant { "${dbuser}@${dbhost}/${dbname}.*":
      table      => "${dbname}.*",
      user       => "${dbuser}@${dbhost}",
      privileges => ['ALL'],
    }
  }

}
