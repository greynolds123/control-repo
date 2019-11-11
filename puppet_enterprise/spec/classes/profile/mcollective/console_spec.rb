require 'spec_helper'

describe "puppet_enterprise::profile::mcollective::console" do
  let(:params) do
    {
      'activemq_brokers' => ['testagent'],
      'stomp_port'       => '12345',
      'stomp_user'       => 'anyone',
      'stomp_password'   => 'supersecret',
    }
  end

  it { should_not contain_notify('puppet-enterprise-profile-mcollective-console-obsolete') }
end
