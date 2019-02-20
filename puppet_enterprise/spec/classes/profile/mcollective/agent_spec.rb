require 'spec_helper'

describe 'puppet_enterprise::profile::mcollective::agent' do
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
      'activemq_brokers'  => ['testagent'],
      'stomp_port'        => 12345,
      'stomp_user'        => 'anyone',
      'stomp_password'    => 'supersecret',
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  def should_have_setting(setting, value)
    should contain_file(server_cfg).with_content(%r[^#{Regexp.escape(setting)}\s*=\s*#{Regexp.escape(value)}$])
  end

  context 'invalid parameter' do
    %w[activemq_brokers collectives].each do |param|
      context "#{param}" do
        before(:each) do
          @params.merge!({param => 'this tots should raise an error, yo'})
        end

        it { should_not compile }
      end
    end
  end

  context "on a windows machine" do
    before :each do
      @facter_facts['osfamily'] = 'windows'
      @facter_facts['common_appdata'] = 'ProgramData'
    end

    it { catalogue }
  end

  context "server.cfg" do
    let(:server_cfg) { "/etc/puppetlabs/mcollective/server.cfg" }

    context "configuring the security provider" do
      it { should_have_setting('identity', 'awesomecert') }
    end

    context "managing subcollectives" do
      context "with invalid params" do
        before(:each) { @params[:collectives] = "this is a string" }
        it { should_not compile }
      end

      context "with valid params" do
        before(:each) { @params[:collectives] = ['uk_collective', 'de_collective'] }
        it { should_have_setting('collectives', 'uk_collective,de_collective') }
      end

      context "with leading and trailing spaces on a collective name" do
        before(:each) { @params[:collectives] = ['uk_collective ', ' de_collective'] }
        it { should_have_setting('collectives', 'uk_collective,de_collective') }
      end
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
  end

  context "using a custom mcollective_identity" do
    let(:params) { @params.merge('mco_identity' => 'acustomidentity') }

    context "server.cfg" do
      let(:server_cfg) { "/etc/puppetlabs/mcollective/server.cfg" }

      context "configuring the security provider" do
        it { should_have_setting('identity', 'acustomidentity') }
      end
    end
  end

  context "don't manage the metadata cron job" do
    let(:params) { @params.merge('manage_metadata_cron' => false) }

    it { should_not contain_cron('pe-mcollective-metadata') }
  end

  it { should contain_class('puppet_enterprise::mcollective::service') }
  it { should satisfy_all_relationships }
end
