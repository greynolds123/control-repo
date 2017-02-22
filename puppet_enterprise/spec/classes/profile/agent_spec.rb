require 'spec_helper'

describe 'puppet_enterprise::profile::agent' do
  before :each do
    @facter_facts = {
      'kernel'                    => 'Linux',
      'platform_symlink_writable' => true,
    }

    @params = {
      'manage_symlinks'   => true,
      'pcp_broker_host'   => 'pcp_broker.rspec',
      'pcp_broker_port'   => 4245,
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  context "when parameter disables management of symlinks" do
    before :each do
      @params['manage_symlinks'] = false
    end

    it { should_not contain_file('/usr/local/bin/facter') }
    it { should_not contain_file('/usr/local/bin/puppet') }
    it { should_not contain_file('/usr/local/bin/pe-man') }
    it { should_not contain_file('/usr/local/bin/hiera') }
    it { should satisfy_all_relationships }
  end

  context "when pxp is disabled" do
    before :each do
      @params['pxp_enabled'] = false
      @facter_facts['puppetversion'] = '4.3.0'
    end

    context "with the identity fact in Facter 3.2" do
      before :each do
        @facter_facts['identity'] = {
          'uid' => 0,
          'user' => 'root',
          'gid' => 0,
          'group' => 'root',
          'privileged' => true,
        }
      end

      it { should contain_class('puppet_enterprise::pxp_agent').with_broker_ws_uri("wss://pcp_broker.rspec:4245/pcp/").with_enabled(false) }
      it { should satisfy_all_relationships }
    end

    context "with the identity fact prior to Facter 3.2" do
      before :each do
        @facter_facts['identity'] = {
          'uid' => 0,
          'user' => 'root',
          'gid' => 0,
          'group' => 'root',
        }
      end

      it { should_not contain_class('puppet_enterprise::pxp_agent') }
    end

    context "without the identity fact" do
      it { should_not contain_class('puppet_enterprise::pxp_agent') }
    end
  end

  context "when non boolean is passed for parameter manage_symlinks" do
    before :each do
      @params['manage_symlinks'] = 'IamAString'
    end

    it { should_not compile }
  end

  context "when platform symlink fact reports system path is not writable" do
    before :each do
      @facter_facts['platform_symlink_writable'] = false
    end

    it { should_not contain_file('/usr/local/bin/facter') }
    it { should_not contain_file('/usr/local/bin/puppet') }
    it { should_not contain_file('/usr/local/bin/pe-man') }
    it { should_not contain_file('/usr/local/bin/hiera') }
    it { should satisfy_all_relationships }
  end

  context "when using Windows fact should be false and symlinks should not be managed" do
    before :each do
      @facter_facts['kernel'] = 'windows'
      @facter_facts['platform_symlink_writable'] = false
    end

    it { should_not contain_file('/usr/local/bin/facter') }
    it { should_not contain_file('/usr/local/bin/puppet') }
    it { should_not contain_file('/usr/local/bin/pe-man') }
    it { should_not contain_file('/usr/local/bin/hiera') }
    it { should satisfy_all_relationships }
  end

  context "when using inherited parameter defaults" do
    before :each do
      @params.delete('manage_symlinks')
      @facter_facts['puppetversion'] = '4.3.0'
    end

    context "with the identity fact in Facter 3.2" do
      before :each do
        @facter_facts['identity'] = {
          'uid' => 0,
          'user' => 'root',
          'gid' => 0,
          'group' => 'root',
          'privileged' => true,
        }
      end

      it { should contain_file('/usr/local/bin/facter').with_tag('pe-agent-symlinks') }
      it { should contain_file('/usr/local/bin/puppet').with_tag('pe-agent-symlinks') }
      it { should contain_file('/usr/local/bin/pe-man').with_tag('pe-agent-symlinks') }
      it { should contain_file('/usr/local/bin/hiera').with_tag('pe-agent-symlinks') }
      it { should contain_class('puppet_enterprise::pxp_agent').with_broker_ws_uri("wss://pcp_broker.rspec:4245/pcp/").with_enabled(true) }
      it { should satisfy_all_relationships }
    end

    context "with the identity fact prior to Facter 3.2" do
      it { should contain_class('puppet_enterprise::pxp_agent').with_broker_ws_uri("wss://pcp_broker.rspec:4245/pcp/").with_enabled(true) }
    end

    context "without the identity fact" do
      it { should contain_class('puppet_enterprise::pxp_agent').with_broker_ws_uri("wss://pcp_broker.rspec:4245/pcp/").with_enabled(true) }
    end
  end

  context "when using inherited parameter defaults with puppet version below 4.3" do
    before :each do
      @params.delete('manage_symlinks')
      @facter_facts['puppetversion'] = '4.2.0'
    end

    it { should_not contain_class('puppet_enterprise::pxp_agent') }
  end

  it { should satisfy_all_relationships }
end
