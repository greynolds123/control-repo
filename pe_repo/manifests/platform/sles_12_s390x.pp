class pe_repo::platform::sles_12_s390x(
  $agent_version = $::aio_agent_build,
){
  pe_repo::deprecation_warning { 'sles-12-s390x': }
}
