require 'spec_helper'

describe 'puppet_enterprise::profile::orchestrator' do
  before :each do
    @facter_facts = {
      'kernel'            => 'Linux',
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'serverversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'master.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir'    => '/tmp/file',
    }

    @params = {
      'certname' => 'orchestrator.rspec',
      'database_host' => 'db.rspec',
      'master_host' => 'master.rspec',
      'puppetdb_host' => 'puppetdb.rspec',
      'classifier_host' => 'classifier.rspec',
      'rbac_host' => 'rbac.rspec',
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  context "when managing default java_args" do
    it { should contain_pe_ini_subsetting("pe-orchestration-services_'Xmx'").with_value( '192m' ) }
    it { should contain_pe_ini_subsetting("pe-orchestration-services_'Xms'").with_value( '192m' ) }
  end

  context "with custom java_args" do
    before(:each) { @params['java_args'] = { 'Xmx' => '128m' } }
    it { should contain_pe_ini_subsetting("pe-orchestration-services_'Xmx'").with(
     'value'   => '128m',
     'require' => 'Package[pe-orchestration-services]',
    ) }
  end

  context "with valid parameters" do
    context "configuring the webserver" do
      it { should contain_pe_hocon_setting("orchestration-services.webserver.pcp-broker.client-auth").with_value('want') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.pcp-broker.ssl-host").with_value('0.0.0.0') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.pcp-broker.ssl-port").with_value(8142) }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.pcp-broker.ssl-ca-cert").with_value('/etc/puppetlabs/puppet/ssl/certs/ca.pem') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.pcp-broker.ssl-cert").with_value('/etc/puppetlabs/orchestration-services/ssl/orchestrator.rspec.cert.pem') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.pcp-broker.ssl-key").with_value('/etc/puppetlabs/orchestration-services/ssl/orchestrator.rspec.private_key.pem') }
      it { should contain_pe_hocon_setting("orchestration-services.web-router-service.broker-service").with(
        :setting => 'web-router-service."puppetlabs.pcp.broker.service/broker-service"',
        :value => {
          'websocket' => {
            'route' => '/pcp',
            'server' => 'pcp-broker'
          },
          'v1' => {
            'route' => '/pcp',
            'server' => 'pcp-broker'
          },
          'metrics' => {
            'route' => '/',
            'server' => 'pcp-broker'
          }
        }) }
    end

    it { should contain_puppet_enterprise__certs('master.rspec').with(:certname => 'master.rspec') }

    it { should contain_pe_concat__fragment('orchestration-services webrouting-service') }


    context "managing the global config file" do
      it { should contain_pe_hocon_setting("orchestration-services.global.certs.ssl-cert").with_value("/etc/puppetlabs/orchestration-services/ssl/master.rspec.cert.pem") }
      it { should contain_pe_hocon_setting("orchestration-services.global.certs.ssl-key").with_value("/etc/puppetlabs/orchestration-services/ssl/master.rspec.private_key.pem") }
      it { should contain_pe_hocon_setting("orchestration-services.global.certs.ssl-ca-cert").with_value("/etc/puppetlabs/puppet/ssl/certs/ca.pem") }

      it { should contain_pe_hocon_setting("orchestration-services.global.logging-config").with_value("/etc/puppetlabs/orchestration-services/logback.xml") }
    end

    context "managing orchestrator config" do
      it { should contain_service('pe-orchestration-services').with(:ensure => true, :enable => true) }

      it { should contain_puppet_enterprise__trapperkeeper__orchestrator('orchestration-services').with(:database_host => 'db.rspec',
                                                                                                      :database_user => 'pe-orchestrator',
                                                                                                      :classifier_url => 'https://classifier.rspec:4433/classifier-api',
                                                                                                      :rbac_url => 'https://rbac.rspec:4433/rbac-api',
                                                                                                      :pcp_broker_url => 'wss://orchestrator.rspec:8142/pcp') }
      it { should contain_puppet_enterprise__trapperkeeper__pcp_broker('orchestration-services').with(:accept_consumers => '2',
                                                                                                    :delivery_consumers => '2') }

      it { should contain_pe_hocon_setting("orchestration-services.webserver.orchestrator.client-auth").with_value('want') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.orchestrator.default-server").with_value(true) }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.orchestrator.access-log-config").with_value('/etc/puppetlabs/orchestration-services/request-logging.xml') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.orchestrator.ssl-host").with_value('0.0.0.0') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.orchestrator.ssl-port").with_value(8143) }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.orchestrator.ssl-ca-cert").with_value('/etc/puppetlabs/puppet/ssl/certs/ca.pem') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.orchestrator.ssl-cert").with_value('/etc/puppetlabs/orchestration-services/ssl/orchestrator.rspec.cert.pem') }
      it { should contain_pe_hocon_setting("orchestration-services.webserver.orchestrator.ssl-key").with_value('/etc/puppetlabs/orchestration-services/ssl/orchestrator.rspec.private_key.pem') }
      it { should contain_pe_hocon_setting("orchestration-services.web-router-service.orchestrator-service").with_value('route' => '/orchestrator/v1', 'server' => 'orchestrator') }
      it { should contain_pe_hocon_setting("orchestration-services.web-router-service.status-service").with_value('route' => '/status', 'server' => 'orchestrator') }
    end

    context "when stopping orchestration-services" do
      before(:each) { @params['run_service'] = false }
      it { should contain_service('pe-orchestration-services').with(:ensure => false, :enable => false) }
    end

  end
end
