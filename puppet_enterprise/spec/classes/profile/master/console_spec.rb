require 'spec_helper'

describe 'puppet_enterprise::profile::master::console' do
  let(:params) do
    { 'console_host'            => 'console.rspec',
      'dashboard_port'          => '1234',
      'console_server_certname' => 'some-cert', }
  end

  it { should_not contain_notify('puppet-enterprise-profile-master-console-obsolete') }
end
