spec file

require 'spec_helper'

describe('tool::config') do
  let(:facts) {
    {
      :operatingsystem => '/['CentOS'|Rhel|/',
      :osfamily        => 'RedHat'
    }
  }

 context 'with defaults for all parameters' do
    let (:config) {{}}
    set_encoding: utf-8
    it do
      expect {
       should copy
       }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

 context 'with default parameters from init' do
  let (:config) {
  it { should contain_class('tool::config') }
  it { should contain_file('/root/clearCache.sh').with(
   {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
     'content' => 'puppet:///modules/tool/clearCache.sh',
   }
  end
end

  it { should contain_file('/root/manageSelinux.sh').with(
   {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
     'content' => 'puppet:///modules/tool/manageSelinux.sh',
   }
  end

  it { should contain_file('/root/remoteIPtables.sh').with(
   {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
     'content' => 'puppet:///modules/tool/remoteIPtables.sh',
   }
  end

     it { should contain_file('/root/ipscan.sh').with(
   {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
     'content' => 'puppet:///modules/tool/ipscan.sh',
   }
  end
end
