require 'spec_helper'

describe('cobbler::install') do
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
      'package' => [
        'cobbler',
        'cobbler-web.noarch',
        'syslinux',
        'syslinux-tftpboot',
      ],
      'package_ensure' => 'installed',
    }
  }
  it { should contain_package('cobbler').with_ensure('installed') }
  it { should contain_package('cobbler-web.noarch').with_ensure('installed') }
  it { should contain_package('syslinux').with_ensure('installed') }
  it { should contain_package('syslinux-tftpboot').with_ensure('installed') }
 
  end
end
