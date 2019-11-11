function puppet_enterprise::produce_gc_logging_args_hash (
  String $container,
) {
  $gc_logging_args_base = { 'XX:+PrintGCDetails'       => '',
                            'XX:+PrintGCDateStamps'    => '',
                            'Xloggc:' => "/var/log/puppetlabs/${container}/${container}_gc.log", }

  $gc_log_rotation_args = { 'XX:+UseGCLogFileRotation' => '',
                            'XX:NumberOfGCLogFiles='   => '16',
                            'XX:GCLogFileSize='        => '64m', }

  $gc_logging_args_return = pe_merge($gc_logging_args_base, $gc_log_rotation_args)
}
