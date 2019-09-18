# PRIVATE CLASS: do not call directly
class pe_postgresql::server::passwd {
  $ensure            = $pe_postgresql::server::ensure
  $postgres_password = $pe_postgresql::server::postgres_password
  $user              = $pe_postgresql::server::user
  $group             = $pe_postgresql::server::group
  $psql_path         = $pe_postgresql::server::psql_path

  if($ensure == 'present' or $ensure == true) {
    if ($postgres_password != undef) {
      # NOTE: this password-setting logic relies on the pg_hba.conf being
      #  configured to allow the postgres system user to connect via psql
      #  without specifying a password ('ident' or 'trust' security). This is
      #  the default for pg_hba.conf.
      $escaped = pe_postgresql_escape($postgres_password)
      $env = "env PGPASSWORD='${postgres_password}'"
      exec { 'set_postgres_postgrespw':
        # This command works w/no password because we run it as postgres system
        # user
        command     => "${psql_path} -c 'ALTER ROLE \"${user}\" PASSWORD ${escaped}'",
        user        => $user,
        group       => $group,
        logoutput   => true,
        cwd         => '/tmp',
        # With this command we're passing -h to force TCP authentication, which
        # does require a password.  We specify the password via the PGPASSWORD
        # environment variable. If the password is correct (current), this
        # command will exit with an exit code of 0, which will prevent the main
        # command from running.
        unless      => "${env} ${psql_path} -h localhost -c 'select 1' > /dev/null",
        path        => '/usr/bin:/usr/local/bin:/bin',
      }
    }
  }
}
