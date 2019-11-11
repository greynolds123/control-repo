require 'spec_helper'

describe 'puppet_enterprise::master::tk_authz' do

  let(:params) do
    {
      'console_client_certname'      => 'fake_console_certname',
      'classifier_client_certname'   => 'fake_classifier_certname',
      'orchestrator_client_certname' => 'fake_orchestrator_certname'
    }
  end

  let(:authconf) { '/etc/puppetlabs/puppetserver/conf.d/auth.conf' }

  context 'managing auth.conf metadata' do
    it { should contain_pe_puppet_authorization(authconf)
                 .with_version(1)
                 .with_allow_header_cert_info(false)}
  end

  context 'managing rules' do
    it { should contain_pe_puppet_authorization__rule('puppetlabs catalog')
                 .with_match_request_path('^/puppet/v3/catalog/([^/]+)$')
                 .with_match_request_type('regex')
                 .with_match_request_method(['get', 'post'])
                 .with_allow('$1')
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs certificate')
                 .with_match_request_path('/puppet-ca/v1/certificate/')
                 .with_match_request_type('path')
                 .with_match_request_method('get')
                 .with_allow_unauthenticated(true)
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs crl')
                 .with_match_request_path('/puppet-ca/v1/certificate_revocation_list/ca')
                 .with_match_request_type('path')
                 .with_match_request_method('get')
                 .with_allow_unauthenticated(true)
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs csr')
                 .with_match_request_path('/puppet-ca/v1/certificate_request')
                 .with_match_request_type('path')
                 .with_match_request_method(['get', 'put'])
                 .with_allow_unauthenticated(true)
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs environments')
                 .with_match_request_path('/puppet/v3/environments')
                 .with_match_request_type('path')
                 .with_match_request_method('get')
                 .with_allow('*')
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs environment')
                 .with_match_request_path('/puppet/v3/environment')
                 .with_match_request_type('path')
                 .with_match_request_method('get')
                 .with_allow('fake_orchestrator_certname')
                 .with_sort_order(510)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs environment classes')
                 .with_match_request_path('/puppet/v3/environment_classes')
                 .with_match_request_type('path')
                 .with_match_request_method('get')
                 .with_allow('fake_classifier_certname')
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs file')
                 .with_match_request_path('/puppet/v3/file')
                 .with_match_request_type('path')
                 .with_allow('*')
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs node')
                 .with_match_request_path('^/puppet/v3/node/([^/]+)$')
                 .with_match_request_type('regex')
                 .with_match_request_method('get')
                 .with_allow('$1')
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs report')
                 .with_match_request_path('^/puppet/v3/report/([^/]+)$')
                 .with_match_request_type('regex')
                 .with_match_request_method('put')
                 .with_allow('$1')
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs resource type')
                 .with_match_request_path('/puppet/v3/resource_type')
                 .with_match_request_type('path')
                 .with_match_request_method('get')
                 .with_allow(['fake_console_certname',
                              'fake_classifier_certname',
                              'fake_orchestrator_certname'])
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs status')
                 .with_match_request_path('/puppet/v3/status')
                 .with_match_request_type('path')
                 .with_match_request_method('get')
                 .with_allow_unauthenticated(true)
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs static file content')
                 .with_match_request_path('/puppet/v3/static_file_content')
                 .with_match_request_type('path')
                 .with_match_request_method('get')
                 .with_allow('*')
                 .with_sort_order(500)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs experimental')
                    .with_match_request_path('/puppet/experimental')
                    .with_match_request_type('path')
                    .with_match_request_method('get')
                    .with_allow_unauthenticated(true)
                    .with_sort_order(500)
                    .with_path(authconf)
                    .with_require("Pe_puppet_authorization[#{authconf}]")
                    .with_notify('Service[pe-puppetserver]')}

    it { should contain_pe_puppet_authorization__rule('puppetlabs deny all')
                 .with_match_request_path('/')
                 .with_match_request_type('path')
                 .with_deny('*')
                 .with_sort_order(999)
                 .with_path(authconf)
                 .with_require("Pe_puppet_authorization[#{authconf}]")
                 .with_notify('Service[pe-puppetserver]')}
  end
end
