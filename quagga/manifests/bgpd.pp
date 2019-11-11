# Class: quagga::bgpd
#
class quagga::bgpd (
  $my_asn                   = undef,
  $router_id                = undef,
  $enable                   = true,
  $networks4                = [],
  $failsafe_networks4       = [],
  $networks6                = [],
  $failsafe_networks6       = [],
  $failover_server          = false,
  $enable_advertisements    = true,
  $enable_advertisements_v4 = true,
  $enable_advertisements_v6 = true,
  $manage_nagios            = false,
  $conf_file                = '/etc/quagga/bgpd.conf',
  $debug_bgp                = [],
  $log_stdout               = false,
  $log_stdout_level         = 'debugging',
  $log_file                 = false,
  $log_file_path            = '/var/log/quagga/bgpd.log',
  $log_file_level           = 'debugging',
  $logrotate_enable         = false,
  $logrotate_rotate         = 5,
  $logrotate_size           = '100M',
  $log_syslog               = false,
  $log_syslog_level         = 'debugging',
  $log_syslog_facility      = 'daemon',
  $log_monitor              = false,
  $log_monitor_level        = 'debugging',
  $log_record_priority      = false,
  $log_timestamp_precision  = 1,
  $peers                    = {},
) {

  include quagga

  $log_levels = '^(emergencies|alerts|critical|errors|warnings|notifications|informational|debugging)$'
  validate_integer($my_asn)
  validate_ip_address($router_id)
  validate_bool($enable)
  validate_array($networks4)
  validate_array($failsafe_networks4)
  validate_array($networks6)
  validate_array($failsafe_networks6)
  validate_bool($failover_server)
  validate_bool($enable_advertisements)
  validate_bool($enable_advertisements_v4)
  validate_bool($enable_advertisements_v6)
  validate_bool($manage_nagios)
  validate_absolute_path($conf_file)
  validate_array($debug_bgp)
  validate_bool($log_stdout)
  validate_re($log_stdout_level, $log_levels)
  validate_bool($log_file)
  validate_absolute_path($log_file_path)
  validate_re($log_file_level, $log_levels)
  validate_bool($logrotate_enable)
  validate_integer($logrotate_rotate)
  validate_string($logrotate_size)
  validate_bool($log_syslog)
  validate_re($log_syslog_level, $log_levels)
  validate_string($log_syslog_facility)
  validate_bool($log_monitor)
  validate_re($log_monitor_level, $log_levels)
  validate_bool($log_record_priority)
  validate_integer($log_timestamp_precision,6)
  validate_hash($peers)

  Ini_setting {
    path    => '/etc/quagga/daemons',
    section => '',
    notify  => Service['quagga'],
  }
  if $enable {
    ini_setting {'bgpd':
      setting => 'bgpd',
      value   => 'yes',
    }
  } else {
    ini_setting {'bgpd':
      setting => 'bgpd',
      value   => 'no',
    }
  }
  concat{$conf_file:
    require => Package[ $::quagga::package ],
    notify  => Service['quagga'],
  }
  concat::fragment{ 'quagga_bgpd_head':
    target  => $conf_file,
    content => template('quagga/bgpd.conf.head.erb'),
    order   => '01',
  }
  concat::fragment{ 'quagga_bgpd_v6head':
    target  => $conf_file,
    content => "!\n address-family ipv6\n",
    order   => '30',
  }
  concat::fragment{ 'quagga_bgpd_v6foot':
    target  => $conf_file,
    content => template('quagga/bgpd.conf.v6foot.erb'),
    order   => '50',
  }
  concat::fragment{ 'quagga_bgpd_acl':
    target  => $conf_file,
    content => template('quagga/bgpd.conf.acl.erb'),
    order   => '80',
  }
  concat::fragment{ 'quagga_bgpd_foot':
    target  => $conf_file,
    content => "line vty\n!\n",
    order   => '99',
  }
  if $log_file and $logrotate_enable {
    logrotate::rule {'quagga_bgp':
      path       => $log_file_path,
      rotate     => $logrotate_rotate,
      size       => $logrotate_size,
      compress   => true,
      postrotate => '/bin/kill -USR1 `cat /var/run/quagga/bgpd.pid 2> /dev/null` 2> /dev/null || true',
    }
  }
  create_resources(quagga::bgpd::peer, $peers)
}

