# Defined type for creating a deprecation warning for
# deprecated platforms.
define pe_repo::deprecation_warning (
  $platform = $title
){
  notify { "${platform} deprecation warning" :
    message  => "${platform} has reached end of life and is no longer being maintained. Puppet is no longer supporting or building agents on this platform. Any existing ${platform} agents you have deployed will continue to work. Please remove this class from classification.",
    loglevel =>  'warning',
  }
}
