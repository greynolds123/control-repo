require 'spec_helper'

describe 'puppet_enterprise::profile::mcollective::peadmin' do
  before :all do
    @facter_facts = {
      'kernel'            => 'Linux',
      'osfamily'          => 'RedHat',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'masternode.rspec',
      'clientcert'        => 'awesomecert',
    }

    @params = {
      'activemq_brokers'  => ['testagent'],
      'stomp_port'     => '12345',
      'stomp_user'     => 'anyone',
      'stomp_password' => 'supersecret',
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  context 'invalid parameter' do
    %w[activemq_brokers].each do |param|
      context "#{param}" do
        let(:params) { @params.merge(param => 'this tots should raise an error, yo') }

        it { should compile.and_raise_error(/is not an Array/) }
      end
    end
  end

  context "not creating the peadmin user" do
    let(:params) { @params.merge('create_user' => false) }
    it { should_not contain_user('peadmin').with('home' => '/var/lib/peadmin') }
  end

  context "managing the peadmin client" do
    it { should contain_user('peadmin').with('home' => '/var/lib/peadmin') }
    it { should contain_file('/var/lib/peadmin/.bashrc.custom').with(
      'ensure' => 'file',
      'owner'  => 'peadmin',
      'group'  => 'peadmin',
      'mode'   => '0600',
    )}
    it { should contain_class('puppet_enterprise::mcollective::service') }

    it { should contain_file('/var/lib/peadmin/.mcollective.d/ca.cert.pem') }
    it { should contain_file('/var/lib/peadmin/.mcollective.d/awesomecert.cert.pem') }
    it { should contain_file('/var/lib/peadmin/.mcollective.d/awesomecert.private_key.pem') }
    it { should contain_file('/var/lib/peadmin/.mcollective.d/peadmin-private.pem') }

    context "client.cfg" do
      def should_have_setting(setting, value)
        should contain_file(client_cfg).with_content(%r[^#{Regexp.escape(setting)}\s*=\s*#{Regexp.escape(value)}$])
      end
      def should_not_have_setting(setting)
        should contain_file(client_cfg).without_content(%r[^#{Regexp.escape(setting)}\s*$])
      end

      let(:client_cfg) { '/var/lib/peadmin/.mcollective' }

      context "managing subcollectives" do
        context "with invalid params" do
          before(:each) { @params[:collectives] = "this is a string" }
          it { should compile.and_raise_error(/is not an Array/) }
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

      context "mco_discovery_timeout" do
        context "mco_discovery_timeout set" do
          before(:each) do
            @params['mco_discovery_timeout'] = 5
          end
          it { should_have_setting('discovery_timeout','5') }
        end
        context "mco_discovery_timeout default" do
          it { should_not_have_setting('discovery_timeout') }
        end
      end

      context "configuring the security provider" do
        it { should_have_setting('securityprovider', 'ssl') }
        it { should_have_setting('plugin.ssl_serializer', 'yaml') }

        it { should_have_setting('plugin.ssl_client_private', '/var/lib/peadmin/.mcollective.d/peadmin-private.pem') }
        it { should_have_setting('plugin.ssl_client_public', '/var/lib/peadmin/.mcollective.d/peadmin-public.pem') }
        it { should_have_setting('plugin.ssl_server_public', '/var/lib/peadmin/.mcollective.d/mcollective-public.pem') }
      end

      context "mco_arbitrary_client_config" do
        before(:each) do
          @params['mco_arbitrary_client_config'] = [ 'test_setting = blah', 'second_test = blah2' ]
        end
          it { should_have_setting('test_setting','blah') }
          it { should_have_setting('second_test','blah2') }
      end

      it { should_have_setting('main_collective', 'mcollective') }
      it { should_have_setting('factsource', 'yaml') }
      it { should_have_setting('plugin.yaml', '/etc/puppetlabs/mcollective/facts.yaml') }
      it { should_have_setting('libdir', '/opt/puppet/libexec/mcollective:/opt/puppetlabs/mcollective/plugins') }
      it { should_have_setting('logfile', '/var/lib/peadmin/.mcollective.d/client.log') }
      it { should_have_setting('loglevel', 'info') }

      context "managing the connector" do
        it { should_have_setting('connector', 'activemq') }

        context "with the default pool" do
          it { should_have_setting('plugin.activemq.pool.size', '1') }
          it { should_have_setting('plugin.activemq.pool.1.host', 'testagent') }
          it { should_have_setting('plugin.activemq.pool.1.port', '12345') }
          it { should_have_setting('plugin.activemq.pool.1.user', 'anyone') }
          it { should_have_setting('plugin.activemq.pool.1.password', 'supersecret') }
          it { should_have_setting('plugin.activemq.pool.1.ssl', 'true') }
          it { should_have_setting('plugin.ssl_client_private', '/var/lib/peadmin/.mcollective.d/peadmin-private.pem') }
          it { should_have_setting('plugin.ssl_client_public', '/var/lib/peadmin/.mcollective.d/peadmin-public.pem') }
          it { should_have_setting('plugin.ssl_server_public', '/var/lib/peadmin/.mcollective.d/mcollective-public.pem') }
        end

        context "specifying pool members with parameters" do
          let(:params) { @params.merge("activemq_brokers" => %w[foo bar]) }

          it { should_have_setting('plugin.activemq.pool.size', '2') }

          %w[foo bar].each_with_index do |host, idx|
            i = idx + 1
            it { should_have_setting("plugin.activemq.pool.#{i}.host", host) }
            it { should_have_setting("plugin.activemq.pool.#{i}.port", '12345') }
            it { should_have_setting("plugin.activemq.pool.#{i}.user", 'anyone') }
            it { should_have_setting("plugin.activemq.pool.#{i}.password", 'supersecret') }
            it { should_have_setting("plugin.activemq.pool.#{i}.ssl", 'true') }
          end
        end
      end
    end
  end

  context "managing symlinks" do
    let(:facts) { @facter_facts.merge('platform_symlink_writable' => true) }
    let(:params) { @params.merge('manage_symlinks' => true) }

    it { should contain_file('/usr/local/bin/mco') }
  end

  context "not managing symlinks" do
    let(:facts)  { @facter_facts.merge('platform_symlink_writable' => true) }
    let(:params) { @params.merge('manage_symlinks' => false) }

    it { should_not contain_file('/usr/local/bin/mco') }
  end

  context "not managing symlinks because fact reports target is not writable" do
    let(:facts)  { @facter_facts.merge('platform_symlink_writable' => false) }
    let(:params) { @params.merge('manage_symlinks' => true) }

    it { should_not contain_file('/usr/local/bin/mco') }
  end

  it { should satisfy_all_relationships }
end
