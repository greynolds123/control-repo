require 'spec_helper'

describe 'puppet_enterprise::puppetdb::config_ini', :type => :class do
  before :all do
    @params = {
      'confdir'                    => '/etc/puppetlabs/puppetdb/conf.d',
      'command_processing_threads' => 4,
    }
  end

  let(:params) { @params }

  it { should contain_class('puppet_enterprise::puppetdb::config_ini') }
  it { should contain_file('/etc/puppetlabs/puppetdb/conf.d/config.ini') }

  describe 'when using default values' do
    it { should contain_pe_ini_setting('config.ini threads command-processing section').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/config.ini',
           'section' => 'command-processing',
           'setting' => 'threads',
           'value'   => 4
    )}
  end
  describe 'when using 0 for command-processing threads expect 1 command_processing_thread' do
    before :each do
      @params['command_processing_threads'] = 0
    end
      it { should contain_pe_ini_setting('config.ini threads command-processing section').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/config.ini',
           'section' => 'command-processing',
           'setting' => 'threads',
           'value'   => 1
    )}
  end
end
