require 'spec_helper'

describe 'puppet_enterprise::trapperkeeper::console_services' do
  require 'puppet/resource/catalog'
  require 'puppet/indirector/memory'
  class ::Puppet::Resource::Catalog::StoreConfigsTesting < Puppet::Indirector::Memory; end

  before :all do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'classifier_ui.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
    }

    @params = {
      'proxy_idle_timeout'    => 60,
      'puppetdb_host'         => 'puppetdb.rspec',
      'master_host'           => 'master.rspec',
      'puppetdb_port'         => 54321,
      'classifier_host'       => 'classifier.rspec',
      'classifier_port'       => '4242',
      'classifier_url_prefix' => '/classifier-api',
      'rbac_host'             => 'rbac.rspec',
      'rbac_port'             => '4244',
      'rbac_url_prefix'       => '/rbac-api',
      'activity_host'         => 'activity.rspec',
      'activity_port'         => '4243',
      'activity_url_prefix'   => '/activity-api',
      'client_certname'       => 'classifier_ui.rspec',
      'status_proxy_enabled'  => false,
      'pcp_broker_host'       => 'pcp_broker.rspec',
      'pcp_broker_port'       => 4245,
      'service_alert_timeout' => 5000,
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:title) { 'console-services' }

  context "when the parameters are valid" do
    it { should contain_file("/etc/puppetlabs/console-services/conf.d/console.conf").with(:owner => "pe-console-services",
                                                                                             :group => "pe-console-services",
                                                                                             :mode => "0640") }
    it { should contain_pe_hocon_setting("#{title}.console.assets-dir").with_value('dist') }
    it { should contain_pe_hocon_setting("#{title}.console.rbac-server").with_value('http://rbac.rspec:4244/rbac-api') }
    it { should contain_pe_hocon_setting("#{title}.console.classifier-server").with_value('http://classifier.rspec:4242/classifier-api') }
    it { should contain_pe_hocon_setting("#{title}.console.activity-server").with_value('http://activity.rspec:4243/activity-api') }
    it { should contain_pe_hocon_setting("#{title}.console.puppetdb-server").with_value('https://puppetdb.rspec:54321') }
    it { should contain_pe_hocon_setting("#{title}.console.certs.ssl-key").with_value('/opt/puppetlabs/server/data/console-services/certs/classifier_ui.rspec.private_key.pem') }
    it { should contain_pe_hocon_setting("#{title}.console.certs.ssl-cert").with_value('/opt/puppetlabs/server/data/console-services/certs/classifier_ui.rspec.cert.pem') }
    it { should contain_pe_hocon_setting("#{title}.console.certs.ssl-ca-cert").with_value('/etc/puppetlabs/puppet/ssl/certs/ca.pem') }
    it { should contain_pe_hocon_setting("#{title}.console.proxy-idle-timeout").with_value('60') }
    it { should contain_pe_hocon_setting("#{title}.console.pcp-broker-url").with_value('wss://pcp_broker.rspec:4245/pcp/')}
    it { should contain_pe_hocon_setting("#{title}.console.certs.pcp-ssl-key").with_value('/opt/puppetlabs/server/data/console-services/certs/classifier_ui.rspec.private_key.pem') }
    it { should contain_pe_hocon_setting("#{title}.console.certs.pcp-ssl-cert").with_value('/opt/puppetlabs/server/data/console-services/certs/classifier_ui.rspec.cert.pem') }
    it { should contain_pe_hocon_setting("#{title}.console.certs.pcp-ssl-ca-cert").with_value('/etc/puppetlabs/puppet/ssl/certs/ca.pem') }
    it { should contain_pe_hocon_setting("#{title}.console.pcp-client-type").with_value('console') }
    it { should contain_pe_hocon_setting("#{title}.console.pcp-request-timeout").with_value(5) }
    it { should contain_pe_hocon_setting("#{title}.console.display-local-time").with_value('false') }
    # would prefer to use the hocon setting, but it doesn't support non-replace, so must use a file resource instead
    #it { should contain_pe_hocon_setting("#{title}.console.cookie-secret-key").with_value(%r[(.){16}]) }

    it { should contain_file("/etc/puppetlabs/console-services/conf.d/console_secret_key.conf").with(:owner => "pe-console-services",
                                                                                                      :group => "pe-console-services",
                                                                                                      :mode => "0640",
                                                                                                      :replace => false,
                                                                                                      :content => %r[cookie-secret-key: "(\d|a|b|c|d|e|f){16}"]) }

    it { should contain_pe_concat__fragment('console-services pe-console-ui-service') }
    it { should contain_pe_concat__fragment('console-services pe-console-auth-ui-service') }
    it { should contain_pe_concat__fragment('console-services jetty9-service') }
    it { should contain_pe_concat__fragment('console-services rbac-authn-service') }
    it { should contain_pe_concat__fragment('console-services rbac-authn-middleware') }
    it { should contain_pe_concat__fragment('console-services rbac-service') }
    it { should contain_pe_concat__fragment('console-services rbac-consumer-service') }
    it { should contain_pe_concat__fragment('console-services rbac-status-service') }
    it { should contain_pe_concat__fragment('console-services rbac-storage-service') }
    it { should contain_pe_concat__fragment('console-services rbac-authz-service') }
    it { should contain_pe_concat__fragment('console-services rbac-authn-service') }
    it { should contain_pe_concat__fragment('console-services webrouting-service') }
    it { should contain_pe_concat__fragment('console-services status-service') }
    it { should_not contain_pe_concat__fragment('console-services status-proxy-service') }
    context "when status proxy is enabled" do
      before(:each) do
        params['status_proxy_enabled'] = true
      end
      it { should contain_pe_concat__fragment('console-services status-proxy-service') }
    end

    context "Service Alert" do
      it { should contain_pe_hocon_setting("#{title}.console.service-alert-timeout").with_value(5000) }
      it { should contain_pe_hocon_setting('console-services.console.service-alert').with_value([]) }
      it { should contain_pe_hocon_setting('console-services.console.service-alert.activity').with_value(
        {'url'=>'http://activity.rspec:4243',   'type'=>'activity'}) }
      it { should contain_pe_hocon_setting('console-services.console.service-alert.classifier').with_value(
        {'url'=>'http://classifier.rspec:4242', 'type'=>'classifier'}) }
      it { should contain_pe_hocon_setting('console-services.console.service-alert.rbac').with_value(
        {'url'=>'http://rbac.rspec:4244', 'type'=>'rbac'}) }
      it { should contain_pe_hocon_setting('console-services.console.service-alert.puppetdb.puppetdb.rspec.54321').with_value(
                      {'url'=>'https://puppetdb.rspec:54321', 'type'=>'puppetdb'}) }
      it { should contain_pe_hocon_setting('console-services.console.service-alert.master.master.rspec').with_value(
                      {'url'=>'https://master.rspec:8140',    'type'=>'master'}) }

      context "with PuppetDB HA" do
        before :each do
          @params['puppetdb_host'] = ['pdb1','pdb2']
          @params['puppetdb_port'] = [1111,2222]
        end
        it { should contain_pe_hocon_setting('console-services.console.service-alert.puppetdb.pdb1.1111').with_value(
                        {'url'=>'https://pdb1:1111', 'type'=>'puppetdb'}) }
        it { should contain_pe_hocon_setting('console-services.console.service-alert.puppetdb.pdb2.2222').with_value(
                        {'url'=>'https://pdb2:2222', 'type'=>'puppetdb'}) }
      end

      context "with puppetdb_query stubbed" do
        let(:node) { 'puppetmaster.storeconfigstrue.1.test' }
        before :each do
          Puppet::Parser::Functions.newfunction(:puppetdb_query,
                                                :type => :rvalue,
                                                :arity => 1) do |args|
            case args[0]
            when ['from', 'resources',
                   ['extract', ['certname'],
                    ['and', ['=', 'type', 'Class'],
                     ['=', 'title', 'Puppet_enterprise::Profile::Master'],
                     ["=", ["node","active"], true]]]]
              [{'certname' => 'dbquery_master_1'}, {'certname' => 'dbquery_master_2'}]
            when  ['from', 'resources',
                   ['extract', ['certname', 'parameters'],
                    ['and', ['=', 'type', 'Class'],
                     ['=', 'title', 'Puppet_enterprise::Master::Code_manager'],
                     ["=", ["node","active"], true]]]]
              [{'certname' => 'code_manager_host_1', 'parameters' => {'webserver_ssl_port' => '10000'}},
               {'certname' => 'code_manager_host_2', 'parameters' => {'webserver_ssl_port' => '10001'}}]
            else
              raise Puppet::Error,
                    "Expecting a query for master profile or code-manager classes. Instead got query for: #{args[0]}"
            end
          end
          Puppet.settings[:storeconfigs] = true
          Puppet.settings[:storeconfigs_backend] = 'store_configs_testing'
        end

        context "code-manager optional config" do
          it { should contain_pe_hocon_setting('console-services.console.service-alert.code-manager.code_manager_host_1.8140').with_value(
                          {'url'=>'https://code_manager_host_1:8140', 'type'=>'code-manager'}) }
          it { should contain_pe_hocon_setting('console-services.console.service-alert.code-manager.code_manager_host_2.8140').with_value(
                          {'url'=>'https://code_manager_host_2:8140', 'type'=>'code-manager'}) }
        end

        context "with Multi-Master installation" do
          it { should contain_pe_hocon_setting('console-services.console.service-alert.master.master.rspec').with_value(
            {'url'=>'https://master.rspec:8140',     'type'=>'master'}) }
          it { should contain_pe_hocon_setting('console-services.console.service-alert.master.dbquery_master_1').with_value(
            {'url'=>'https://dbquery_master_1:8140', 'type'=>'master'}) }
          it { should contain_pe_hocon_setting('console-services.console.service-alert.master.dbquery_master_2').with_value(
            {'url'=>'https://dbquery_master_2:8140', 'type'=>'master'}) }
        end

      end
    end
  end

  context "when params are undef" do
    before(:each) do
      params['proxy_idle_timeout'] = ''
    end

    it { should contain_pe_hocon_setting("#{title}.console.proxy-idle-timeout").with_ensure('absent') }
  end

  context "when PuppetDB HA is configured" do
    before(:each) do
      params['puppetdb_host'] = ['puppetdb.rspec', 'replica.vm']
      params['puppetdb_port'] = ['54321', '8081']
    end

    # We only grab the first PuppetDB from the list of PuppetDB's for the
    # Console when HA is configured
    it { should contain_pe_hocon_setting("#{title}.console.puppetdb-server").with_value('https://puppetdb.rspec:54321') }
  end
end
