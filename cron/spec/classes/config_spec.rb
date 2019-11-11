spec file

require 'spec_helper'

describe('cron::config') do
  let(:facts) {
    {
      :operatingsystem => '/['CentOS'|Rhel']/',
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

  context 'with default parameters from config' do
    let (:config) { 
    it { should_contain_class('cron') }
    it { should_contain_file('/root/clearCache.sh').with(
      'cron' { 'clearCache':     
      'ensure'   => 'present',
      'user      => 'root',
      'command'  => '/bin/sh /root/clearCache.sh',
      'hour'     => '2',
      'minute'   => '45',
      }
      }
  end
end 
 
   context 'with default parameters from config' do
    let (:config) {
    it { should_contain_class('cron') }
    it { should_contain_file('/root/TuneDatabase').with(
     'cron' { 'TuneDatabase':
     'ensure'   => 'present',
     'user      => 'root',
     'command'  => '/bin/sh /root/TuneDatabase.sh',
     'hour'     => '5',
     'minute'   => '15',
     }
     }
 end
end

