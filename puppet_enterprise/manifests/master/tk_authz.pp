# This class manages the new Trapperkeeper-based auth.conf file.
#
# @param console_client_certname [String] The name on the certificate used by the console.
# @param classifier_client_certname [String] The name on the certificate used by the classifier.
# @param orchestrator_client_certname [String] The name on the certificate used by the orchestrator.
# @param allow_header_cert_info [Boolean] Controls how the authenticated user "name" is derived for a request being authorized.
# @param allow_unauthenticated_ca [Boolean] True allows unauthenticated access, by default. False requires authentication on the certificate endpoints.
# @param allow_unauthenticated_status [Boolean] True allows unauthenticated access, by default. False requires authentication on status-service endpoint.
# @param allow_rbac_catalog_compile [Boolean] True allows RBAC token with the 'puppetserver:compile_catalogs:*` permission to use the new v4 catalog compile endpoint. Required for CD4PE.
class puppet_enterprise::master::tk_authz(
  String $console_client_certname,
  Variant[String,Array[String]] $classifier_client_certname,
  String $orchestrator_client_certname,
  Boolean $allow_unauthenticated_ca,
  Boolean $allow_unauthenticated_status,
  Optional[Boolean] $allow_header_cert_info = false,
  Optional[Boolean] $allow_rbac_catalog_compile = true,
) {

  $authconf = '/etc/puppetlabs/puppetserver/conf.d/auth.conf'
  $allow = $allow_unauthenticated_ca ? {
            false => '*',
            default => undef,
          }
  $allow_status_service = $allow_unauthenticated_status ? {
                           false => '*',
                           default => undef,
                         }

  pe_puppet_authorization { $authconf:
    version                => 1,
    allow_header_cert_info => $allow_header_cert_info,
  }

  Pe_puppet_authorization::Rule {
    path    => $authconf,
    require => Pe_puppet_authorization[$authconf],
    notify  => Service['pe-puppetserver'],
  }

  # Allow nodes to retrieve their own catalog
  pe_puppet_authorization::rule { 'puppetlabs catalog':
    match_request_path   => '^/puppet/v3/catalog/([^/]+)$',
    match_request_type   => 'regex',
    match_request_method => ['get', 'post'],
    allow                => '$1',
    sort_order           => 500,
  }

  # Allow ACE Server / CD4PE to retrieve v4 catalog
  $v4_catalog_rules = $allow_rbac_catalog_compile ? {
    true =>  [$orchestrator_client_certname, { 'rbac' => { 'permission' => 'puppetserver:compile_catalog:*' }}],
    false => $orchestrator_client_certname,
  }

  pe_puppet_authorization::rule { 'puppetlabs v4 catalog':
    ensure               => present,
    match_request_path   => '^/puppet/v4/catalog/?$',
    match_request_type   => 'regex',
    match_request_method => 'post',
    allow                => $v4_catalog_rules,
    sort_order           => 500,
  }

  # Allow nodes to retrieve the certificate they requested earlier
  pe_puppet_authorization::rule { 'puppetlabs certificate':
    match_request_path    => '/puppet-ca/v1/certificate/',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow                 => $allow,
    allow_unauthenticated => $allow_unauthenticated_ca,
    sort_order            => 500,
  }

  # Allow all nodes to access the certificate revocation list
  pe_puppet_authorization::rule { 'puppetlabs crl':
    match_request_path    => '/puppet-ca/v1/certificate_revocation_list/ca',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow                 => $allow,
    allow_unauthenticated => $allow_unauthenticated_ca,
    sort_order            => 500,
  }

  # Allow nodes to request a new certificate
  pe_puppet_authorization::rule { 'puppetlabs csr':
    match_request_path    => '/puppet-ca/v1/certificate_request',
    match_request_type    => 'path',
    match_request_method  => ['get', 'put'],
    allow                 => $allow,
    allow_unauthenticated => $allow_unauthenticated_ca,
    sort_order            => 500,
  }

  pe_puppet_authorization::rule { 'puppetlabs environments':
    match_request_path   => '/puppet/v3/environments',
    match_request_type   => 'path',
    match_request_method => 'get',
    allow                => '*',
    sort_order           => 500,
  }

  pe_puppet_authorization::rule { 'puppetlabs environment':
    match_request_path   => '/puppet/v3/environment',
    match_request_type   => 'path',
    match_request_method => 'get',
    allow                => $v4_catalog_rules,
    sort_order           => 510,
  }

  pe_puppet_authorization::rule { 'puppetlabs tasks':
    match_request_path   => '/puppet/v3/tasks',
    match_request_type   => 'path',
    match_request_method => 'get',
    allow                => $orchestrator_client_certname,
    sort_order           => 510,
  }

  pe_puppet_authorization::rule { 'puppetlabs environment classes':
    match_request_path   => '/puppet/v3/environment_classes',
    match_request_type   => 'path',
    match_request_method => 'get',
    allow                => $classifier_client_certname,
    sort_order           => 500,
  }

  # Allow nodes to access all file_bucket_files.  Note that access for
  # the 'delete' method is forbidden by Puppet regardless of the
  # configuration of this rule.
  pe_puppet_authorization::rule { 'puppetlabs file bucket file':
    match_request_path   => '/puppet/v3/file_bucket_file',
    match_request_type   => 'path',
    match_request_method => ['get', 'head', 'post', 'put'],
    allow                => '*',
    sort_order           => 500,
  }

  # Allow nodes to access all file_content.  Note that access for the
  # 'delete' method is forbidden by Puppet regardless of the
  # configuration of this rule.
  pe_puppet_authorization::rule { 'puppetlabs file content':
    match_request_path   => '/puppet/v3/file_content',
    match_request_type   => 'path',
    match_request_method => ['get', 'post'],
    allow                => '*',
    sort_order           => 500,
  }

  # Allow nodes to access all file_metadata.  Note that access for the
  # 'delete' method is forbidden by Puppet regardless of the
  # configuration of this rule.
  pe_puppet_authorization::rule { 'puppetlabs file metadata':
    match_request_path   => '/puppet/v3/file_metadata',
    match_request_type   => 'path',
    match_request_method => ['get', 'post'],
    allow                => '*',
    sort_order           => 500,
  }

  # Allow nodes to retrieve only their own node definition
  pe_puppet_authorization::rule { 'puppetlabs node':
    match_request_path   => '^/puppet/v3/node/([^/]+)$',
    match_request_type   => 'regex',
    match_request_method => 'get',
    allow                => '$1',
    sort_order           => 500,
  }

  # Allow nodes to store only their own reports, allow the ACE service to store any report
  pe_puppet_authorization::rule { 'puppetlabs report':
    match_request_path   => '^/puppet/v3/report/([^/]+)$',
    match_request_type   => 'regex',
    match_request_method => 'put',
    allow                => [ '$1', $orchestrator_client_certname ],
    sort_order           => 500,
  }

  # Allow nodes to update only their own facts
  pe_puppet_authorization::rule { 'puppetlabs facts':
    match_request_path   => '^/puppet/v3/facts/([^/]+)$',
    match_request_type   => 'regex',
    match_request_method => 'put',
    allow                => '$1',
    sort_order           => 500,
  }

  pe_puppet_authorization::rule { 'puppetlabs resource type':
    match_request_path   => '/puppet/v3/resource_type',
    match_request_type   => 'path',
    match_request_method => 'get',
    allow                => pe_flatten([$console_client_certname,
                                        $classifier_client_certname,
                                        $orchestrator_client_certname]),
    sort_order           => 500,
  }

  pe_puppet_authorization::rule { 'puppetlabs status':
    match_request_path    => '/puppet/v3/status',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow_unauthenticated => true,
    sort_order            => 500,
  }

  pe_puppet_authorization::rule { 'puppetserver simple status endpoint':
    match_request_path    => '/status/v1/simple',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow_unauthenticated => true,
    sort_order            => 500,
  }

  pe_puppet_authorization::rule { 'puppetlabs status service':
    match_request_path    => '/status/v1/services',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow                 => $allow_status_service,
    allow_unauthenticated => $allow_unauthenticated_status,
    sort_order            => 500,
  }

  pe_puppet_authorization::rule { 'puppetlabs static file content':
    match_request_path    => '/puppet/v3/static_file_content',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow                 => '*',
    sort_order            => 500,
  }

  # Allow all users access to the experimental endpoint in Puppet Server,
  # which currently only provides a dashboard web ui.
  pe_puppet_authorization::rule { 'puppetlabs experimental':
    match_request_path    => '/puppet/experimental',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow_unauthenticated => true,
    sort_order            => 500,
  }

  # Deny everything else. This ACL is not strictly
  # necessary, but illustrates the default policy
  pe_puppet_authorization::rule { 'puppetlabs deny all':
    match_request_path => '/',
    match_request_type => 'path',
    deny               => '*',
    sort_order         => 999,
  }
}
