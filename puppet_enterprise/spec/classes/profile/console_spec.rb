require 'spec_helper'

describe 'puppet_enterprise::profile::console' do
  require 'puppet/resource/catalog'
  require 'puppet/indirector/memory'
  class ::Puppet::Resource::Catalog::StoreConfigsTesting < Puppet::Indirector::Memory; end

  before :each do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'console.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
    }

    @params = {
      'secret_token'                => 'totally secret',
      'dashboard_database_password' => 'password',
      'database_host'               => 'database.rspec',
      'database_port'               => 1234,
      'master_certname'             => 'master.cert.rspec',
      'master_host'                 => 'master.rspec',
      'certname'                    => 'console-rspec',
      'ca_host'                     => 'ca.rspec',
      'puppetdb_host'               => 'puppetdb.rspec'
    }


  end

  let(:facts)                    { @facter_facts }
  let(:params)                   { @params }
  let(:sharedir)                 { '/opt/puppet/share/puppet-dashboard' }
  let(:ssldir)                   { '/etc/puppetlabs/puppet/ssl' }
  let(:rbac_cert_whitelist)      { '/etc/puppetlabs/console-services/rbac-certificate-whitelist' }
  let(:dashboard_cert_whitelist) { '/etc/puppetlabs/puppet-dashboard/dashboard-certificate-whitelist' }

  context "managing packages" do
    it { should contain_package('pe-console-services') }
  end

  context "managing console-services" do
    let(:services_confdir) { '/etc/puppetlabs/console-services/conf.d' }
    let(:services_sharedir) { '/opt/puppetlabs/server/data/console-services' }
    it { should contain_pe_concat__fragment('console-services classifier-service') }
    it { should contain_pe_concat__fragment('console-services rbac-service') }
    it { should contain_pe_concat__fragment('console-services rbac-http-api-service') }
    it { should contain_pe_concat__fragment('console-services rbac-authn-middleware') }
    it { should contain_pe_concat__fragment('console-services jetty9-service') }
    it do
      should contain_file("#{services_confdir}/classifier.conf").with(
        :owner => "pe-console-services",
        :group => "pe-console-services",
        :mode => "0640"
      )
    end
    it do
      should contain_file("#{services_confdir}/rbac.conf").with(
        :owner => "pe-console-services",
        :group => "pe-console-services",
        :mode => "0640"
      )
    end

    it { should contain_pe_hocon_setting('console-services.console.rbac-server').with_value('http://127.0.0.1:4432/rbac-api') }
    it { should contain_pe_hocon_setting('console-services.console.classifier-server').with_value('http://127.0.0.1:4432/classifier-api') }
    it { should contain_pe_hocon_setting('console-services.console.activity-server').with_value('http://127.0.0.1:4432/activity-api') }
    it { should contain_pe_hocon_setting('console-services.console.puppet-master').with_value("https://master.rspec:8140") }

    it do
      should contain_file("#{services_confdir}/console.conf").with(
               :owner => "pe-console-services",
               :group => "pe-console-services",
               :mode => "0640"
             )
    end
    it do
      should contain_pe_hocon_setting('console-services.classifier.database.subname').with_value \
             "//database.rspec:1234/pe-classifier?ssl=true" +
             "&sslfactory=org.postgresql.ssl.jdbc4.LibPQFactory&sslmode=verify-full" +
             "&sslrootcert=/etc/puppetlabs/puppet/ssl/certs/ca.pem" +
             "&sslkey=#{services_sharedir}/certs/console-rspec.private_key.pk8" +
             "&sslcert=#{services_sharedir}/certs/console-rspec.cert.pem"
    end

    it do
      should contain_pe_hocon_setting('console-services.rbac.database.subname').with_value \
             "//database.rspec:1234/pe-rbac?ssl=true" +
             "&sslfactory=org.postgresql.ssl.jdbc4.LibPQFactory&sslmode=verify-full" +
             "&sslrootcert=/etc/puppetlabs/puppet/ssl/certs/ca.pem" +
             "&sslkey=#{services_sharedir}/certs/console-rspec.private_key.pk8" +
             "&sslcert=#{services_sharedir}/certs/console-rspec.cert.pem"
    end

    it { should contain_puppet_enterprise__trapperkeeper__rbac("console-services") }
  end

  context "managing certs" do
    it { should contain_class('puppet_enterprise::profile::console::certs') }
  end

  context "managing console-services config" do
    it { should contain_class('puppet_enterprise::profile::console::console_services_config') }
  end

  context "managing certificate whitelists" do
    context "rbac certificate whitelist" do
      it { should contain_file(rbac_cert_whitelist) }
      it do
        should contain_pe_file_line("#{rbac_cert_whitelist}:#{@params['certname']}").with(
        'path' => rbac_cert_whitelist,
          'line' => @params['certname']
        )
      end
      it do
        should contain_pe_file_line("#{rbac_cert_whitelist}:#{@params['master_certname']}").with(
                 'path' => rbac_cert_whitelist,
                 'line' => @params['master_certname']
               )
      end

      context "storeconfigs is enabled" do
        let(:node) { 'puppetmaster.storeconfigstrue.42.test' }
        before :each do
          Puppet::Parser::Functions.newfunction(:puppetdb_query,
                                                :type => :rvalue,
                                                :arity => 1) do |args|
            [{'certname' => 'dynamic_master_1'},
             {'certname' => 'dynamic_master_2'}].shuffle
          end

          Puppet.settings[:storeconfigs] = true
          Puppet.settings[:storeconfigs_backend] = 'store_configs_testing'
        end

        it do
          should contain_pe_file_line("#{rbac_cert_whitelist}:dynamic_master_1").with(
                   'path' => rbac_cert_whitelist,
                   'line' => 'dynamic_master_1'
                 )
        end

        it do
          should contain_pe_file_line("#{rbac_cert_whitelist}:dynamic_master_2").with(
                   'path' => rbac_cert_whitelist,
                   'line' => 'dynamic_master_2'
                 )
        end
      end
    end

  end

  it { should satisfy_all_relationships }

  context "with send_analytics_data set to true" do
    it { should contain_file('/etc/puppetlabs/analytics-opt-out').with_ensure('absent').with_require('Package[pe-console-services]') }
    it { should satisfy_all_relationships }
  end

  context "with send_analytics_data disabled" do
    before :each do
      @params['send_analytics_data'] = false
    end

    it { should contain_file('/etc/puppetlabs/analytics-opt-out').with_ensure('file').with_require('Package[pe-console-services]') }
    it { should satisfy_all_relationships }
  end
end
