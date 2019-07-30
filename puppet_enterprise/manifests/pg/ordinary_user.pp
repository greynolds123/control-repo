# A define type to manage the creation of 'ordinary' (non-super-) postgres users.
# In particular, it manages the necessary grants to have such a user that is not
# also the database owner. This works in conjunction with the migration user,
# which *is* a superuser, and which owns the database and all objects inside it.
#
# @param user_name [String] The name of the postgres user
# @param database [String] The name of the database to grant access to.
# @param database_password [String] The login password for the user; use the empty
#        string to disable password authentication.
# @param db_owner [String] The user which owns the database (i.e. the migration user
#        for the database)
# @param replication_user [String] The user which performs replication, and which may
#        end up owning replicated objects.
define puppet_enterprise::pg::ordinary_user(
  String $user_name,
  String $database,
  String $database_password,
  Boolean $write_access,
  String $db_owner,
  String $replication_user,
) {
  $_database_password = $database_password ? {
    ''      => undef,
    default => $database_password
  }

  pe_postgresql::server::role { $user_name:
    password_hash => $_database_password,
  }

  puppet_enterprise::pg::grant_connect { "${database} grant connect perms to ${user_name}":
    database => $database,
    schema   => 'public',
    user     => $user_name,
    require  => Pe_postgresql::Server::Role[$user_name],
  }

  if $write_access {
    puppet_enterprise::pg::write_grant {"${database} grant write perms on existing objects to ${user_name}":
      table_writer => $user_name,
      database     => $database,
      schema       => 'public',
      require      => Pe_postgresql::Server::Role[$user_name],
    }

    [$db_owner, $replication_user].each |$owner| {
      puppet_enterprise::pg::default_write_grant {"${database} grant write perms on new objects from ${owner} to ${user_name}":
        table_creator => $owner,
        table_writer  => $user_name,
        database      => $database,
        schema        => 'public',
        require       => Pe_postgresql::Server::Role[$user_name],
      }
    }
  } else {
    [$db_owner, $replication_user].each |$owner| {
      puppet_enterprise::pg::default_read_grant {"${database} grant read perms on new objects from ${owner} to ${user_name}":
        table_creator => $owner,
        table_reader  => $user_name,
        database      => $database,
        schema        => 'public',
        require       => Pe_postgresql::Server::Role[$user_name],
      }
    }
  }
}
