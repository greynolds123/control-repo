define puppet_enterprise::trapperkeeper::init_defaults(
  String  $container            = $title,
  String  $user                 = "pe-${container}",
  String  $group                = "pe-${container}",
  Integer $service_stop_retries = 60,
  Integer $start_timeout        = 300,
  Optional[String] $jruby_jar   = undef,
) {

  $confdir = "/etc/puppetlabs/${container}"

  $notify_hup_or_full_restart = puppet_enterprise::on_the_lts() ? {
    true    => Service["pe-${container}"],
    default => Exec["pe-${container} service full restart"],
  }

  Pe_ini_setting {
    ensure  => present,
    path    => "${puppet_enterprise::params::defaults_dir}/pe-${container}",
    key_val_separator => '=',
    section => '',
    require => Package["pe-${container}"],
    notify  => $notify_hup_or_full_restart
  }

  pe_ini_setting { "${container} initconf java_bin":
    setting => 'JAVA_BIN',
    value   => '"/opt/puppetlabs/server/bin/java"',
  }

  pe_ini_setting { "${container} initconf user":
    setting => 'USER',
    value   => $user,
  }

  pe_ini_setting { "${container} initconf group":
    setting => 'GROUP',
    value   => $group,
  }

  pe_ini_setting { "${container} initconf install_dir":
    setting => 'INSTALL_DIR',
    value   => "\"/opt/puppetlabs/server/apps/${container}\"",
  }

  pe_ini_setting { "${container} initconf config":
    setting => 'CONFIG',
    value   => "\"${confdir}/conf.d\"",
  }

  pe_ini_setting { "${container} initconf bootstrap_config":
    setting => 'BOOTSTRAP_CONFIG',
    value   => "\"${confdir}/bootstrap.cfg\"",
  }

  pe_ini_setting { "${container} initconf service_stop_retries":
    setting => 'SERVICE_STOP_RETRIES',
    value   => $service_stop_retries,
  }

  pe_ini_setting { "${container} initconf start_timeout":
    setting => 'START_TIMEOUT',
    value   => $start_timeout,
  }

  $jruby_jar_enabled = pe_empty($jruby_jar) ? {
    true    => 'absent',
    default => 'present',
  }

  pe_ini_setting { "${container} initconf jruby_jar":
    ensure => $jruby_jar_enabled,
    setting => 'JRUBY_JAR',
    value => "\"${jruby_jar}\"",
  }
}
