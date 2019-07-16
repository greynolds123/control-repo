class puppet_enterprise::params {
  $mco_create_client_user               = "peadmin"
  $stomp_password                       = "stomp_password_value"
  $mcollective_middleware_port          = 61616
  $stomp_user                           = "stomp_user_value"
  $activity_url_prefix                  = '/activity-api'
  $classifier_url_prefix                = '/classifier-api'
  $rbac_url_prefix                      = '/rbac-api'
  $console_services_api_ssl_listen_port = '4433'

}
