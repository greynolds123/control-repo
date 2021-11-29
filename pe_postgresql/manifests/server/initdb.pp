# PRIVATE CLASS: do not call directly
class pe_postgresql::server::initdb {
  $ensure       = $pe_postgresql::server::ensure
  $needs_initdb = $pe_postgresql::server::needs_initdb
  $initdb_path  = $pe_postgresql::server::initdb_path
  $datadir      = $pe_postgresql::server::datadir
  $xlogdir      = $pe_postgresql::server::xlogdir
  $encoding     = $pe_postgresql::server::encoding
  $locale       = $pe_postgresql::server::locale
  $ctype        = $pe_postgresql::server::ctype
  $collate      = $pe_postgresql::server::collate
  $group        = $pe_postgresql::server::group
  $user         = $pe_postgresql::server::user

  if($ensure == 'present' or $ensure == true) {
    # Make sure the data directory exists, and has the correct permissions.
    file { $datadir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0700',
    }

    if($xlogdir) {
      # Make sure the xlog directory exists, and has the correct permissions.
      file { $xlogdir:
        ensure => directory,
        owner  => $user,
        group  => $group,
        mode   => '0700',
      }
    }

    if($needs_initdb) {
      # Build up the initdb command.
      #
      # We optionally add the locale switch if specified. Older versions of the
      # initdb command don't accept this switch. So if the user didn't pass the
      # parameter, lets not pass the switch at all.
      $ic_base = "${initdb_path} --encoding '${encoding}' --pgdata '${datadir}'"
      $ic_xlog_flag = $xlogdir ? {
        undef   => '',
        default => "--xlogdir '${xlogdir}'"
      }
      $locale_flag = $locale ? {
        undef   => '',
        default => "--locale=${locale}"
      }
      $collate_flag = $collate ? {
        undef   => '',
        default => "--lc-collate='${collate}'"
      }
      $ctype_flag = $ctype ? {
        undef   => '',
        default => "--lc-ctype='${ctype}'"
      }

      $initdb_command = "${ic_base} ${ic_xlog_flag} ${locale_flag} ${collate_flag} ${ctype_flag}"

      # This runs the initdb command, we use the existance of the PG_VERSION
      # file to ensure we don't keep running this command.
      exec { 'postgresql_initdb':
        command   => $initdb_command,
        creates   => "${datadir}/PG_VERSION",
        user      => $user,
        group     => $group,
        logoutput => on_failure,
        require   => File[$datadir],
      }
    }
  } else {
    # Purge data directory if ensure => absent
    file { $datadir:
      ensure  => absent,
      recurse => true,
      force   => true,
    }

    if($xlogdir) {
      # Make sure the xlog directory exists, and has the correct permissions.
      file { $xlogdir:
        ensure  => absent,
        recurse => true,
        force   => true,
      }
    }
  }
}
