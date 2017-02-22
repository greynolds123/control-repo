require 'spec_helper'
describe 'puppet_enterprise::console_services' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'master.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir'    => '/tmp/file',
    }

    @params = {
      'client_certname' => 'console.rspec',
      'master_host'     => 'master.rspec',
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:confdir) { "/etc/puppetlabs/puppet" }

  context "when managing default java_args" do
    it { should contain_pe_ini_subsetting("pe-console-services_'Xmx'").with_value( '256m' ) }
    it { should contain_pe_ini_subsetting("pe-console-services_'Xms'").with_value( '256m' ) }
  end

  context "wth custom java_args" do
    before(:each) { @params['java_args'] = { 'Xmx' => '128m' } }
    it { should contain_pe_ini_subsetting("pe-console-services_'Xmx'").with(
     'value'   => '128m',
     'require' => 'Package[pe-console-services]',
    ) }
  end

  context "managing services" do
    it { should contain_service('pe-console-services') }
  end

  context "managing service defaults" do
    it { should contain_pe_ini_setting('pe-console-services initconf java_bin')
         .with_setting('JAVA_BIN')
         .with_value('"/opt/puppetlabs/server/bin/java"')
         .with_path('/etc/default/pe-console-services') }
    it { should contain_pe_ini_setting('pe-console-services initconf user')
         .with_setting('USER')
         .with_value('pe-console-services') }
    it { should contain_pe_ini_setting('pe-console-services initconf group')
         .with_setting('GROUP')
         .with_value('pe-console-services') }
    it { should contain_pe_ini_setting('pe-console-services initconf install_dir')
         .with_setting('INSTALL_DIR')
         .with_value('"/opt/puppetlabs/server/apps/console-services"') }
    it { should contain_pe_ini_setting('pe-console-services initconf config')
         .with_setting('CONFIG')
         .with_value('"/etc/puppetlabs/console-services/conf.d"') }
    it { should contain_pe_ini_setting('pe-console-services initconf bootstrap_config')
         .with_setting('BOOTSTRAP_CONFIG')
         .with_value('"/etc/puppetlabs/console-services/bootstrap.cfg"') }
    it { should contain_pe_ini_setting('pe-console-services initconf service_stop_retries')
         .with_setting('SERVICE_STOP_RETRIES')
         .with_value('60') }
    it { should contain_pe_ini_setting('pe-console-services initconf start_timeout')
         .with_setting('START_TIMEOUT')
         .with_value('120') }

    context "with overrides" do
      before(:each) do
        @params['service_stop_retries'] = 12345
        @params['start_timeout'] = 67890
      end

      it { should contain_pe_ini_setting('pe-console-services initconf service_stop_retries')
           .with_setting('SERVICE_STOP_RETRIES')
           .with_value('12345') }
      it { should contain_pe_ini_setting('pe-console-services initconf start_timeout')
           .with_setting('START_TIMEOUT')
           .with_value('67890') }
    end
  end
end
