require 'spec_helper'

describe 'puppet_enterprise::mcollective::server' do

  let(:server_cfg) { '/etc/puppetlabs/mcollective/server.cfg' }

  def should_have_setting(setting, value)
    should contain_file(server_cfg).with_content(%r[^#{Regexp.escape(setting)}\s*=\s*#{Regexp.escape(value)}$])
  end

  before :each do
    @facter_facts = {
      'osfamily'          => 'RedHat',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'somenode.rspec',
      'clientcert'        => 'awesomecert',
    }
    @params = {}
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  context "on a windows machine" do
    before :each do
      @facter_facts['osfamily'] = 'windows'
      @facter_facts['operatingsystem'] = 'windows'
      @facter_facts['common_appdata'] = '/ProgramData'
    end
    it { catalogue }
  end

  context "on a RedHat machine" do
    it { should compile }

    it { should contain_file('/etc/puppetlabs/mcollective/server.cfg').with_notify('Service[mcollective]') }
  end

  context "server.cfg" do
    it { should_have_setting('libdir', '/opt/puppet/libexec/mcollective:/opt/puppetlabs/mcollective/plugins') }
  end

  context "mco_arbitrary_server_config" do
    before(:each) do
      @params['mco_arbitrary_server_config'] = [ 'test_setting = blah', 'second_test = blah2' ]
    end
      it { should_have_setting('test_setting','blah') }
      it { should_have_setting('second_test','blah2') }
  end

  context "randomzie_activemq" do
    context "false" do
      it { should_have_setting('plugin.activemq.randomize','false') }
    end
    context "true" do
      before(:each) do
        @params['randomize_activemq'] = true
      end
      it { should_have_setting('plugin.activemq.randomize','true') }
    end
  end

  context "activemq_heartbeat_interval should be set to the correct value" do
    it { should_have_setting('plugin.activemq.heartbeat_interval', '120') }
  end

  context "to not enforce action policies" do

    it do
      should contain_file('/etc/puppetlabs/mcollective/server.cfg').with_content(/plugin.actionpolicy.allow_unconfigured = 1/)
    end
  end

  context "to enforce action policies" do
    let(:params) {
      {
        'allow_no_actionpolicy'  => '0',
      }
    }

    it do
      should contain_file('/etc/puppetlabs/mcollective/server.cfg').with_content(/plugin.actionpolicy.allow_unconfigured = 0/)
    end
  end

  context "fail if allow_no_actionpolicy is not 1 or 0" do
    let(:params) {
      {
        'allow_no_actionpolicy'  => 'beer',
      }
    }

    it { should compile.and_raise_error(/does not match/) }
  end

  describe "puppet_enterprise::mcollective::cleanup" do
    it { should compile }
    it { should satisfy_all_relationships }
    it { should contain_file('/opt/puppet/libexec/mcollective/mcollective/agent/discovery.rb').with_ensure('absent') }
    # We *do not* want to just delete the directories, as that will remove any plugins the user has installed
    it { should_not contain_file('/opt/puppet/libexec/mcollective/mcollective/agent').with_ensure('absent') }

    context "on a windows machine" do
      before :each do
        @facter_facts['osfamily'] = 'windows'
        @facter_facts['operatingsystem'] = 'windows'
        @facter_facts['common_appdata'] = 'C:/ProgramData'
      end

      it { should_not contain_file('/opt/puppet/libexec/mcollective/mcollective/agent/discovery.rb') }
      it { should contain_file('C:/ProgramData/PuppetLabs/mcollective/etc/plugins/mcollective/agent/discovery.rb').with_ensure('absent') }
      # We *do not* want to just delete the directories, as that will remove any plugins the user has installed
      it { should_not contain_file('C:/ProgramData/PuppetLabs/mcollective/etc/plugins/mcollective/agent').with_ensure('absent') }
    end
  end

  context "Chnages in log and caching values" do
    let(:params) {
      {
        'mco_loglevel'        => 'debug',
        'mco_fact_cache_time' => '150',
      }
    }

    it {
      should_have_setting('loglevel','debug')
    }

    it {
      should_have_setting('fact_cache_time','150')
    }
  end


  it { should satisfy_all_relationships }
end
