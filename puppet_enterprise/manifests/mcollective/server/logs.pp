# Sets up the log directory and files for the mcollective server.
#
# Also sets up log rotation on solaris.
class puppet_enterprise::mcollective::server::logs {
  include puppet_enterprise::params

  File {
    owner  => $puppet_enterprise::params::root_user,
    group  => $puppet_enterprise::params::root_group,
    mode   => $puppet_enterprise::params::root_mode,
  }

  file { $puppet_enterprise::params::mco_logdir:
    ensure => directory,
  }

  file { [$puppet_enterprise::params::mco_server_log_file, $puppet_enterprise::params::mco_audit_log_file]:
    ensure => present,
  }

  #Switching back to using exec from file line.  logadm adds a timestamp to the command when it runs.  This caused the line to be modified on every puppet run.
  if $::operatingsystem == 'solaris' {
    exec { 'Solaris: mcollective log rotation':
      command => "/usr/bin/echo '# mcollective log rotation rule\n${puppet_enterprise::params::mco_server_log_file} -C 14 -c -p 1w' >> /etc/logadm.conf",
      unless  => "/usr/bin/grep 'puppetlabs/mcollective.log' /etc/logadm.conf > /dev/null",
    }

    exec { 'Solaris: mcollective audit log rotation':
      command => "/usr/bin/echo '# mcollective audit log rotation rule\n${puppet_enterprise::params::mco_audit_log_file} -C 14 -c -p 1w' >> /etc/logadm.conf",
      unless  => "/usr/bin/grep 'puppetlabs/mcollective-audit.log' /etc/logadm.conf > /dev/null",
    }
  }
}
