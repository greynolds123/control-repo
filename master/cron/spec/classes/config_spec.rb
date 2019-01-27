spec file

require 'spec_helper'

describe('cron::config') do
  let(:facts) {
<<<<<<< HEAD
    {
      :operatingsystem => '/['CentOS'|Rhel']/',
      :osfamily        => 'RedHat'
=======
    }
      :operatingsystem =>'/['CentOS'|'Rhel']/', 
      :osfamily        =>'RedHat'
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
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
<<<<<<< HEAD
 
<<<<<<< HEAD:master/cron/spec/classes/config_spec.rb
=======
  
 context 'with default parameters from config' do
    let (:config) {
    it { should_contain_class('cron::config') }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
   it { should_contain_file('/root/TuneDatabase').with(
=======
   context 'with default parameters from config' do
    let (:config) {
    it { should_contain_class('cron') }
    it { should_contain_file('/root/TuneDatabase').with(
>>>>>>> 52ca1e871f69b13415a82a7b0c67bc44780324bf:cron/spec/classes/config_spec.rb
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

