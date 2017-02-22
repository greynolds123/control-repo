# This class manages the new Trapperkeeper-based auth.conf file.
#
# @param console_client_certname [String] The name on the certificate used by the console.
# @param classifier_client_certname [String] The name on the certificate used by the classifier.
# @param orchestrator_client_certname [String] The name on the certificate used by the orchestrator.
# @param allow_header_cert_info [Boolean] Controls how the authenticated user "name" is derived for a request being authorized.
class puppet_enterprise::master::tk_authz(
  String $console_client_certname,
  String $classifier_client_certname,
  String $orchestrator_client_certname,
  Optional[Boolean] $allow_header_cert_info = false,
) {

  $authconf = '/etc/puppetlabs/puppetserver/conf.d/auth.conf'

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

  # Allow nodes to retrieve the certificate they requested earlier
  pe_puppet_authorization::rule { 'puppetlabs certificate':
    match_request_path    => '/puppet-ca/v1/certificate/',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow_unauthenticated => true,
    sort_order            => 500,
  }

  # Allow all nodes to access the certificate revocation list
  pe_puppet_authorization::rule { 'puppetlabs crl':
    match_request_path    => '/puppet-ca/v1/certificate_revocation_list/ca',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow_unauthenticated => true,
    sort_order            => 500,
  }

  # Allow nodes to request a new certificate
  pe_puppet_authorization::rule { 'puppetlabs csr':
    match_request_path    => '/puppet-ca/v1/certificate_request',
    match_request_type    => 'path',
    match_request_method  => ['get', 'put'],
    allow_unauthenticated => true,
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

  # Allow nodes to access all file services; this is necessary for
  # pluginsync, file serving from modules, and file serving from
  # custom mount points (see fileserver.conf). Note that the `/file`
  # prefix matches requests to file_metadata, file_content, and
  # file_bucket_file paths.
  pe_puppet_authorization::rule { 'puppetlabs file':
    match_request_path   => '/puppet/v3/file',
    match_request_type   => 'path',
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

  # Allow nodes to store only their own reports
  pe_puppet_authorization::rule { 'puppetlabs report':
    match_request_path   => '^/puppet/v3/report/([^/]+)$',
    match_request_type   => 'regex',
    match_request_method => 'put',
    allow                => '$1',
    sort_order           => 500,
  }

  pe_puppet_authorization::rule { 'puppetlabs resource type':
    match_request_path   => '/puppet/v3/resource_type',
    match_request_type   => 'path',
    match_request_method => 'get',
    allow                => [$console_client_certname,
                             $classifier_client_certname,
                             $orchestrator_client_certname],
    sort_order           => 500,
  }

  pe_puppet_authorization::rule { 'puppetlabs status':
    match_request_path    => '/puppet/v3/status',
    match_request_type    => 'path',
    match_request_method  => 'get',
    allow_unauthenticated => true,
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
