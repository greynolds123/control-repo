require 'spec_helper'

describe 'puppet_enterprise::mcollective::client', :type => :define do
  context 'on a supported platform' do
    before :each do
      @facter_facts = {
        :osfamily                => 'RedHat',
        :lsbmajdistrelease       => '6',
        :puppetversion           => '3.6.2 (Puppet Enterprise 3.3.0)',
        :is_pe                   => 'true',
        :clientcert              => 'awesomecert'
      }

      @params = {
        :activemq_brokers => ['testagent'],
        :keypair_name     => 'pe-internal-puppet-console-mcollective-client',
        :create_user      => true,
        :home_dir         => homedir,
        :logfile          => logdir,
        :stomp_password   => 'supersecret',
        :stomp_port       => '12345',
        :stomp_user       => 'anyone',
      }
    end

    let(:title) { 'peadmin' }
    let(:facts) { @facter_facts }
    let(:params) { @params }
    let(:homedir) { '/some/home/peadmin' }
    let(:logdir) { '/some/mcollective_client.log' }

    context "not creating user" do
      before(:each) { @params[:create_user] = false }
      it { should_not contain_user('peadmin').with('home' => '/some/home/peadmin') }
    end

    context "using the default home dir" do
      before(:each) { @params.delete(:home_dir) }
      it { should contain_file('/var/lib/peadmin/.mcollective.d/awesomecert.private_key.pem') }
    end

    context "using a custom home dir" do
      context "creating the user" do
        it { should contain_user('peadmin').with('home' => '/some/home/peadmin') }
        it { should contain_file('/some/home/peadmin').with('mode' => '0700') }

        it { should contain_file('/some/home/peadmin/.bashrc.custom').with(
          'ensure' => 'file',
          'owner'  => 'peadmin',
          'group'  => 'peadmin',
          'mode'   => '0600',
        )}

        it { should contain_file('/some/home/peadmin/.mcollective.d/ca.cert.pem') }
        it { should contain_file('/some/home/peadmin/.mcollective.d/awesomecert.cert.pem') }
        it { should contain_file('/some/home/peadmin/.mcollective.d/awesomecert.private_key.pem') }
        it { should contain_file('/some/home/peadmin/.mcollective.d/peadmin-private.pem') }

        context "client.cfg" do
          def should_have_setting(setting, value)
            should contain_file(client_cfg).with_content(%r[^#{Regexp.escape(setting)}\s*=\s*#{Regexp.escape(value)}$])
          end

          let(:client_cfg) { '/some/home/peadmin/.mcollective' }

          it { should contain_file(client_cfg).with_mode('0600') }

          context "configuring the security provider" do
            it { should_have_setting('securityprovider', 'ssl') }
            it { should_have_setting('plugin.ssl_serializer', 'yaml') }

            it { should_have_setting('plugin.ssl_client_private', '/some/home/peadmin/.mcollective.d/peadmin-private.pem') }
            it { should_have_setting('plugin.ssl_client_public', '/some/home/peadmin/.mcollective.d/peadmin-public.pem') }
            it { should_have_setting('plugin.ssl_server_public', '/some/home/peadmin/.mcollective.d/mcollective-public.pem') }
          end

          it { should_have_setting('main_collective', 'mcollective') }
          it { should_have_setting('factsource', 'yaml') }
          it { should_have_setting('plugin.yaml', '/etc/puppetlabs/mcollective/facts.yaml') }
          it { should_have_setting('libdir', '/opt/puppet/libexec/mcollective:/opt/puppetlabs/mcollective/plugins') }
          it { should_have_setting('logfile', '/some/mcollective_client.log') }
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
              it { should_have_setting('plugin.ssl_client_private', '/some/home/peadmin/.mcollective.d/peadmin-private.pem') }
              it { should_have_setting('plugin.ssl_client_public', '/some/home/peadmin/.mcollective.d/peadmin-public.pem') }
              it { should_have_setting('plugin.ssl_server_public', '/some/home/peadmin/.mcollective.d/mcollective-public.pem') }
            end

            context "specifying pool members with parameters" do
              before(:each) { @params[:activemq_brokers] = %w[foo bar] }

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
    end
  end
end
