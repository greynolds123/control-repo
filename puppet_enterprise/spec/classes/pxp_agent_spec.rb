require 'spec_helper'

describe 'puppet_enterprise::pxp_agent' do

  let(:agent_conf) { '/etc/puppetlabs/pxp-agent/pxp-agent.conf' }

  def should_have_setting(path, setting, value)
    settings = JSON.load(catalogue.resource('file', path)[:content])
    expect(settings[setting]).to eq(value)
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

    @params = {
      'broker_ws_uri' => 'wss://pxp-broker.example.com:8142/pcp/',
    }
  end

  let(:facts) { @facter_facts }

  let(:params) { @params }

  context "on a windows machine" do
    before :each do
      @facter_facts['osfamily'] = 'windows'
    end

    it "the catalog compiles" do
      subject
    end
  end

  context "on a RedHat machine" do
    it "the catalog compiles" do
      subject
    end

    it { should contain_file(agent_conf).with_notify('Service[pxp-agent]') }
  end

  context "pxp-agent.conf" do
    it { should contain_file(agent_conf) }
    it { should_have_setting(agent_conf, 'broker-ws-uri', 'wss://pxp-broker.example.com:8142/pcp/') }
    it { should_have_setting(agent_conf, 'ssl-key', '/etc/puppetlabs/puppet/ssl/private_keys/awesomecert.pem') }
    it { should_have_setting(agent_conf, 'ssl-cert', '/etc/puppetlabs/puppet/ssl/certs/awesomecert.pem') }
    it { should_have_setting(agent_conf, 'loglevel', 'info') }
  end

  context "when enabled" do
    it { should contain_class('puppet_enterprise::pxp_agent::service').with_enabled(true) }
  end

  context "when disabled" do
    before :each do
      @params['enabled'] = false
    end

    it { should contain_class('puppet_enterprise::pxp_agent::service').with_enabled(false) }
  end

  it { should satisfy_all_relationships }
end
