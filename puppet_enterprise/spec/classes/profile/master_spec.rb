require 'spec_helper'

describe 'puppet_enterprise::profile::master' do
  before :each do
    @cacrl = Tempfile.new('cacrl')
    File.open(@cacrl, 'w') { |f| f.write "blah blah blah I'm a CRL blah blah blah" }
    Puppet.settings[:cacrl] = @cacrl.path
    @hostcrl = Tempfile.new('hostcrl')
    File.open(@hostcrl, 'w') { |f| f.write "I'm another CRL that doesn't blah so much" }
    Puppet.settings[:hostcrl] = @hostcrl.path

    @facter_facts = {
      'kernel'            => 'Linux',
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'master.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
      'aio_agent_build'   => '1.3.3',
    }

    @params = {
      'console_host'                 => 'console.rspec',
      'certname'                     => 'master.rspec',
      'console_client_certname'      => 'console.rspec',
      'console_server_certname'      => 'blah.rspec',
      'classifier_client_certname'   => 'classifier.rspec',
      'orchestrator_client_certname' => 'orchestrator.rspec',
      'puppetdb_host'                => 'puppetdb.rspec',
      'ca_host'                      => 'ca.rspec',
      'environmentpath'              => '/etc/puppetlabs/puppet/environments',
      'codedir'                      => '/etc/puppetlabs/code',
      'metrics_graphite_host'                    => 'graphite',
      'metrics_graphite_port'                    => 2003,
      'metrics_graphite_update_interval_seconds' => 30,
    }

    Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
      '1.3.3'
    end
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:confdir) { "/etc/puppetlabs/puppet" }
  let(:tarball_staging) { '/opt/puppetlabs/server/share/puppet_enterprise/pe_modules' }

  context "managing files" do
    it { should contain_pe_hocon_setting('metrics.reporters.graphite.host').with_value('graphite') }
    it { should contain_pe_hocon_setting('metrics.reporters.graphite.port').with_value(2003) }
    it { should contain_pe_hocon_setting('metrics.reporters.graphite.update-interval-seconds').with_value(30) }
  end

  context "managing crl" do
    context 'puppet agent -t' do
      before :each do
        @facter_facts['servername'] = 'master.rspec'
      end

      it { should contain_file("/etc/puppetlabs/puppet/ssl/crl.pem").with_content("blah blah blah I'm a CRL blah blah blah") }
    end

    context 'puppet apply' do
      it { should_not contain_file("/etc/puppetlabs/puppet/ssl/crl.pem").with_content("blah blah blah I'm a CRL blah blah blah") }
    end
  end

  context "with classifier" do
    before :each do
      @params['classifier_host'] = 'classifier.rspec'
    end
    it { should contain_class('puppet_enterprise::profile::master::classifier') }
    it { should satisfy_all_relationships }
  end

  context "without classifier" do
    before :each do
      @params['classifier_host'] = ''
    end
    it { should_not contain_class('puppet_enterprise::profile::master::classifier') }
  end

  context 'managing auth.conf' do
    it { should contain_class('puppet_enterprise::profile::master::auth_conf')
                 .with_console_client_certname('console.rspec')
                 .with_classifier_client_certname('classifier.rspec')
                 .with_orchestrator_client_certname('orchestrator.rspec')
                 .with_require('Package[pe-puppetserver]')
                 .with_notify('Service[pe-puppetserver]')}
  end

  context "with puppetdb" do
    it { should contain_class('puppet_enterprise::profile::master::puppetdb') }
  end

  context "managing puppet.conf" do
    it { should contain_pe_ini_setting('module_groups').with_value('base+pe_only') }
  end

  context "managing master" do
    it { should contain_class('puppet_enterprise::master').with(:certname => @params['certname']) }
  end

  context "when using default certname" do
    before :each do
      @params.delete('certname')
    end
    it { should contain_class('puppet_enterprise::master').with(:certname => @facter_facts['clientcert']) }
  end

  context "determining version match" do
    before(:each) do
      # The hostname of the compiling server
      @facter_facts['servername'] = 'master.rspec'
      @facter_facts['fqdn'] = 'master.rspec'
    end

    context "on the master of masters (puppet apply)" do
      context "when installing" do
        before :each do
          @facter_facts.delete('pe_server_version')
          @facter_facts.delete('pe_version')
          # These server variables (which we are pretending are facts) are not
          # present when applying
          @facter_facts.delete('servername')
          @facter_facts.delete('aio_agent_build')

          Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
            nil
          end
        end

        it "does not raise an error regardless of match so as not to interfere with initial master of master's install/upgrade" do
          should contain_class('puppet_enterprise::profile::master')
        end
      end

      context "when upgrading (puppet apply)" do
        context "from 3.8.x" do
          before :each do
            @facter_facts.delete('pe_server_version')
            @facter_facts.delete('aio_agent_build')
            @facter_facts['pe_version'] = '3.8.2'
          end

          it "does not raise an error regardless of match so as not to interfere with initial master of master's install/upgrade" do
            should contain_class('puppet_enterprise::profile::master')
          end
        end

        context "from 2015.2.x" do
          before :each do
            @facter_facts['pe_server_version'] = '2015.2.0'
            @facter_facts['aio_agent_build'] = '1.2.2'
            @facter_facts.delete('pe_version')
            Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
              '1.2.2'
            end
          end

          it "does not raise an error regardless of match so as not to interfere with initial master of master's install/upgrade" do
            should contain_class('puppet_enterprise::profile::master')
          end
        end
      end

      context "during an agent run (steady state)" do
        before :each do
          @facter_facts['pe_server_version'] = '2015.2.1'
          @facter_facts['aio_agent_build'] = '1.3.3'
          @facter_facts.delete('pe_version')
          Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
            '1.3.3'
          end
        end

        it "compiles" do
          should contain_class('puppet_enterprise::profile::master')
        end
      end
    end

    context "for a compile master" do
      before :each do
        @facter_facts['servername'] = 'master.rspec'
        @facter_facts['fqdn'] = 'compile-master.rspec'
        Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
          '1.3.3'
        end
      end

      context "when installing (after frictionless agent install)" do
        before :each do
          @facter_facts['pe_server_version'] = '2015.2.1'
          @facter_facts['aio_agent_build'] = '1.3.3'
          @facter_facts.delete('pe_version')
        end

        it "the catalog compiles" do
          should contain_class('puppet_enterprise::profile::master')
        end
      end

      context "when upgrading" do
        context "from 3.8.x" do
          before :each do
            @facter_facts.delete('pe_server_version')
            @facter_facts.delete('aio_agent_build')
            @facter_facts['pe_version'] = '3.8.2'
          end

          it "raises a version match error despite aio_agent_build not being present" do
            expect { catalogue }.to raise_error(Puppet::Error, /Please ensure that the PE versions are consistent across all Puppet masters/)
          end
        end

        context "from 2015.2.x" do
          before :each do
            @facter_facts.delete('pe_version')
          end

          context "and master versions are inconsistent" do
            before :each do
              @facter_facts['pe_server_version'] = '2015.2.0'
              @facter_facts['aio_agent_build'] = '1.2.2'
            end

            it "fails to compile" do
              expect { catalogue }.to raise_error(Puppet::Error, /Please ensure that the PE versions are consistent across all Puppet masters/)
            end
          end

          context "when compiling and compile master versions match" do
            before :each do
              @facter_facts['pe_server_version'] = '2015.2.1'
              @facter_facts['aio_agent_build'] = '1.3.3'
            end

            it "the catalog compiles" do
              should contain_class('puppet_enterprise::profile::master')
            end
          end
        end
      end

    end

    it { should compile }
  end

  context "when managing tarballs" do
    it { should contain_file(tarball_staging) }
    it { should contain_file("#{tarball_staging}/install.sh").with(:content => /source_dir="#{tarball_staging}"/) }
    it { should contain_exec('Extract PE Modules').with(:command => "#{tarball_staging}/install.sh") }
  end

  context "providing packages mount" do
    it do
      should contain_augeas('fileserver.conf pe_packages').with_changes([
        "set /files/etc/puppetlabs/puppet/fileserver.conf/pe_packages/path /opt/puppetlabs/server/data/packages/public",
        "set /files/etc/puppetlabs/puppet/fileserver.conf/pe_packages/allow *",
      ])
    end
  end

  context "managing symlinks" do
    let(:facts) { @facter_facts.merge('platform_symlink_writable' => true) }
    let(:params) { @params.merge('manage_symlinks' => true) }

    it { should contain_file('/usr/local/bin/r10k') }
  end

  context "not managing symlinks" do
    let(:facts)  { @facter_facts.merge('platform_symlink_writable' => true) }
    let(:params) { @params.merge('manage_symlinks' => false) }

    it { should_not contain_file('/usr/local/bin/r10k') }
  end

  context "not managing symlinks because fact reports target is not writable" do
    let(:facts)  { @facter_facts.merge('platform_symlink_writable' => false) }
    let(:params) { @params.merge('manage_symlinks' => true) }

    it { should_not contain_file('/usr/local/bin/r10k') }
  end

  context "managing pe_r10k with remote" do
    before(:each) { @params['r10k_remote'] = 'git@gitserver.rspec' }
    it { should contain_package('pe-r10k') }
    it { should contain_file('r10k.yaml').with_content(/.*git@gitserver\.rspec.*/) }
    it { should satisfy_all_relationships }
  end

  context "managing pe_r10k with remote and private key" do
    before :each do
      @params['r10k_remote']      = 'git@gitserver.rspec'
      @params['r10k_private_key'] = '/path/to/key.rspec'
    end
    it { should contain_package('pe-r10k') }
    it { should contain_file('r10k.yaml').with_content(%r[.*/path/to/key\.rspec.*]) }
    it { should satisfy_all_relationships }
  end

  context "managing pe_r10k with proxy server" do
    proxy = 'https://user:p455w0rd@proxy.example.com'
    before :each do
      @params['r10k_remote']      = 'git@gitserver.rspec'
      @params['r10k_private_key'] = '/path/to/key.rspec'
      @params['r10k_proxy'] = proxy
    end
    it { should contain_file('r10k.yaml').with_content(/^proxy:\s+#{proxy}/) }
    it { should satisfy_all_relationships }
  end

  context 'not managing r10k explicitly using parameters' do
    it { should contain_class('pe_r10k::package') }
    it { should_not contain_file('r10k.yaml') }
  end

  context 'when running on MoM' do
    before(:each) { @facter_facts['servername'] = 'master.rspec' }

    context 'when autoconfiguring code_manager' do
      before(:each) { @params['code_manager_auto_configure'] = true }
      it { should contain_class('puppet_enterprise::master::code_manager') }
      it { should contain_file('r10k.yaml').with_content(/write_lock/) }
    end

    context 'when not autoconfiguring code_manager' do
      it { should_not contain_class('puppet_enterprise::master::code_manager') }

      context 'when still managing r10k config' do
        before(:each) { @params['r10k_remote'] = 'git@gitserver.rspec' }
        it { should contain_file('r10k.yaml').without_content(/write_lock/) }
      end
    end

    context 'when file sync is enabled' do
      before(:each) { @params['code_manager_auto_configure'] = true }
      it { should contain_class('puppet_enterprise::master::file_sync').with_compile_master(false)}
      it { should_not contain_class('puppet_enterprise::master::code_manager').with_file_sync_autocommit(true) }
      it { should contain_class('puppet_enterprise::master::file_sync').with_compile_master(false)}
    end
    context 'when file sync is disabled' do
      before(:each) { @params['code_manager_auto_configure'] = true }
      before(:each) { @params['file_sync_enabled'] = false}
      it { should contain_class('puppet_enterprise::master::file_sync_disabled')}
      it { should_not contain_class('puppet_enterprise::master::code_manager').with_file_sync_autocommit(false) }
    end
  end

  context 'when running on a compile master' do
    before(:each) { @facter_facts['servername'] = 'compile.rspec' }

    context 'when autoconfiguring code_manager' do
      before(:each) { @params['code_manager_auto_configure'] = true }
      it { should_not contain_class('puppet_enterprise::master::code_manager') }
    end
    context 'when file sync is enabled' do
      before(:each) { @params['file_sync_enabled'] = true}
      it { should contain_class('puppet_enterprise::master::file_sync').with_compile_master(true)}
    end
    context 'when file sync is disabled' do
      before(:each) { @params['file_sync_enabled'] = false}
      it { should contain_class('puppet_enterprise::master::file_sync_disabled')}
    end
  end

  context 'passing through code_manager_auto_configure to the pe::master class' do
    context 'when code_manager_auto_configure false' do
      before(:each) { @params['code_manager_auto_configure'] = false }
      it { should contain_class('puppet_enterprise::master').with(:code_manager_auto_configure => false) }
    end
    context 'when code_manager_auto_configure true' do
      before(:each) { @params['code_manager_auto_configure'] = true }
      it { should contain_class('puppet_enterprise::master').with(:code_manager_auto_configure => true) }
    end
  end

  context "custom environmentpath setting in puppet.conf" do
    before(:each) { @params['environmentpath'] = '/tmp' }
    it { should contain_pe_ini_setting('environmentpath_setting').with_value('/tmp') }
  end

  context "custom codedir setting in puppet.conf" do
    before(:each) { @params['codedir'] = '/tmp/code' }
    it { should contain_pe_ini_setting('codedir_setting').with_value('/tmp/code') }
  end

  it { should satisfy_all_relationships }

  context "when not enabling app_management" do
    before(:each) {@params['app_management'] = 'false' }
    it { should contain_pe_ini_setting("puppetserver puppetconf app_management").with_value('false') }
  end

  context "when enabling app_management" do
    it { should contain_pe_ini_setting("puppetserver puppetconf app_management").with_value('true') }
  end

  context "removes ankeny app_management config" do
    it { should contain_pe_ini_setting("deprecated puppetserver puppetconf app_management").with_ensure('absent') }
  end

  context "acting as a controller node" do
    it { should contain_class("puppet_enterprise::profile::controller") }
  end

  context "with check_for_updates unspecified" do
    it { should contain_file('/etc/puppetlabs/puppetserver/opt-out').with_ensure('absent').with_require('Package[pe-puppetserver]') }
    it { should satisfy_all_relationships }
  end

  context "with check_for_updates opt out disabled" do
    before :each do
      @params['check_for_updates'] = false
    end

    it { should contain_file('/etc/puppetlabs/puppetserver/opt-out').with_ensure('file').with_require('Package[pe-puppetserver]') }
    it { should satisfy_all_relationships }
  end
end
