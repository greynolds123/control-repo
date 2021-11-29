require 'spec_helper'

describe 'puppet_enterprise::profile::master::auth_conf' do

  let(:params) do
    {
      'console_client_certname'      => 'fake_console_certname',
      'classifier_client_certname'   => 'fake_classifier_certname',
      'orchestrator_client_certname' => 'fake_orchestrator_certname'
    }
  end

  context 'managing legacy Ruby auth.conf' do
    context 'when not custom auth.conf' do
      let(:facts) {{ 'custom_auth_conf' => false }}
      it { should_not contain_file('/etc/puppetlabs/puppet/auth.conf') }
    end

    context 'when custom auth.conf' do
      let(:facts) {{ 'custom_auth_conf' => true }}
      it { should_not contain_file('/etc/puppetlabs/puppet/auth.conf') }
    end
  end

  context 'managing new Trapperkeeper auth.conf' do
    it { should contain_class('puppet_enterprise::master::tk_authz')
                 .with_console_client_certname('fake_console_certname')
                 .with_classifier_client_certname('fake_classifier_certname')
                 .with_orchestrator_client_certname('fake_orchestrator_certname')
                 .with_require('Package[pe-puppetserver]')
                 .with_notify('Service[pe-puppetserver]') }
  end
end
