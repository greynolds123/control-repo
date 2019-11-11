# Ensures that the mcollective service is running
class puppet_enterprise::mcollective::service (
  Enum['stopped', 'running'] $ensure = 'running',
  Boolean                    $enable = true,
) {
  service { 'mcollective':
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
  }
}
