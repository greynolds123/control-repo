class puppet_enterprise::pxp_agent::service(
  Boolean $enabled = true,
) {
  service { 'pxp-agent':
    ensure     => $enabled,
    enable     => $enabled,
    hasrestart => true,
  }
}
