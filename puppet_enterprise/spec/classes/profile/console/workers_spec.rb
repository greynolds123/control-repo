require 'spec_helper'

describe 'puppet_enterprise::profile::console::workers' do
  before :each do
    @params = {
      'database_name' => 'console-db',
      'database_user' => 'console-user',
      'database_password' => 'secretpassword',
      'database_host' => 'database.rspec',
      'database_port' => 2345,
    }
  end

  let(:params) { @params }

  it { should_not contain_notify('puppet-enterprise-profile-console-workers-obsolete') }
end
