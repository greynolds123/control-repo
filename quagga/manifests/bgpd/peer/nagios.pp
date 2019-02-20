# quagga::bgpd::peer::nagios
# 
define quagga::bgpd::peer::nagios (
  $routes = []
) {
  validate_array($routes)
  $_routes = join($routes, ' ')
  @@nagios_service{ "${::fqdn}_BGP_NEIGHBOUR_${name}":
    ensure              => present,
    use                 => 'generic-service',
    host_name           => $::fqdn,
    service_description => "BGP_NEIGHBOUR_${name}",
    check_command       => "check_nrpe_args!check_bgp!${name}!${_routes}",
  }
}
