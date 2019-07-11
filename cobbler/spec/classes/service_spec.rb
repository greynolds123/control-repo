require 'spec_helper'

describe('cobbler::service') do
  let(:facts) {
    {
      :fqdn            => 'test.example.com',
      :hostname        => 'test',
      :ipaddress       => '192.168.0.1',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat'
    }
  }
  context 'with defaults for all parameters' do
    let (:params) {{}}

    it do
      expect {
        should compile
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  context 'with default parameters from init' do
  let (:params) {
    {
      'service'        => 'cobbler',
      'service_ensure' => 'running',
      'service_enable' => true,
    }
  }
  it { should contain_service('cobbler').with(
    {
      'ensure' => 'running',
      'enable' => true,
    }
  )
  }
 
  end
end
