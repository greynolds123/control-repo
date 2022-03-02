class pe_repo::platform::sles_11_s390x(
  $agent_version = $::aio_agent_build,
){
  pe_repo::deprecation_warning { 'sles-11-s390x': }
}
