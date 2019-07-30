#log_temp_files should equal work_mem to avoid logging
#temp files smaller than work_mem
function puppet_enterprise::calculate_log_temp_files(
  Variant[String, Integer] $work_mem,
) >> Integer {
  #work_mem is specified in kB if no memory unit is provided
  if $work_mem =~ Integer {
    $log_temp_files = $work_mem
  } elsif ( $matches = $work_mem.match(Puppet_enterprise::Postgresql_setting_numeric_w_memory_unit_regex) ) {
    $work_mem_integer = $matches[1]
    $work_mem_suffix = $matches[3]

    $multiplier = $work_mem_suffix ? {
      'kb' => 1,
      'MB' => 1024,
      'GB' => 1024*1024,
      'TB' => 1024*1024*1024,
    }

    $log_temp_files = Integer($work_mem_integer) * $multiplier
  } else {
    $log_temp_files = Integer($work_mem)
  }
}
