require 'spec_helper'

describe 'puppet_enterprise::trapperkeeper::orchestrator' do
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
      'database_host' => 'db.rspec',
      'master_url' => 'https://master.rspec:8140',
      'puppetdb_url' => 'https://puppetdb.rspec:8081',
      'classifier_url' => 'https://classifier.rspec:4433/classifier-api',
      'console_services_url' => 'https://console.rspec:4433',
      'rbac_url' => 'https://rbac.rspec:4433/rbac-api',
      'pcp_broker_url' => 'wss://pcp.rspec:8142/pcp',
      'console_url' => 'https://console.rspec',
    }

  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:title) { 'orchestration-services' }
  let(:confdir) { "/etc/puppetlabs/#{title}" }

  it { should contain_file("#{confdir}/conf.d/orchestrator.conf").with(:owner => 'pe-orchestration-services',
                                                                       :group => 'pe-orchestration-services',
                                                                       :mode  => '0640') }

  context "configuring the SSL client" do
    it { should contain_pe_hocon_setting("#{title}.orchestrator.ssl-cert").with_value("#{confdir}/ssl/master.rspec.cert.pem") }
    it { should contain_pe_hocon_setting("#{title}.orchestrator.ssl-key").with_value("#{confdir}/ssl/master.rspec.private_key.pem") }
    it { should contain_pe_hocon_setting("#{title}.orchestrator.ssl-ca-cert").with_value("/etc/puppetlabs/puppet/ssl/certs/ca.pem") }
  end

  context "managing integration with other services" do
    it { should contain_pe_hocon_setting("#{title}.orchestrator.master-url").with_value('https://master.rspec:8140') }
    it { should contain_pe_hocon_setting("#{title}.orchestrator.puppetdb-url").with_value('https://puppetdb.rspec:8081') }
    it { should contain_pe_hocon_setting("#{title}.orchestrator.classifier-service").with_value('https://classifier.rspec:4433/classifier-api') }
    it { should contain_pe_hocon_setting("#{title}.orchestrator.console-services-url").with_value('https://console.rspec:4433') }
    it { should contain_pe_hocon_setting("#{title}.rbac-consumer.api-url").with_value('https://rbac.rspec:4433/rbac-api') }
    it { should contain_pe_hocon_setting("#{title}.orchestrator.pcp-broker-url").with_value('wss://pcp.rspec:8142/pcp') }
    it { should contain_pe_hocon_setting("#{title}.orchestrator.console-url").with_value('https://console.rspec') }
  end

  context "configuring database settings" do
    it { should contain_pe_hocon_setting("#{title}.orchestrator.database.subname").with_value('//db.rspec:5432/pe-orchestrator') }
    it { should contain_pe_hocon_setting("#{title}.orchestrator.database.user").with_value('pe-orchestrator') }
    it { should_not contain_pe_hocon_setting("#{title}.orchestrator.database.password") }
  end

  context "configuring bootstrap.cfg" do
    it { should contain_pe_concat__fragment('orchestration-services orchestrator-service') }
    it { should contain_pe_concat__fragment('orchestration-services jetty9-service') }
    it { should contain_pe_concat__fragment('orchestration-services status-service') }
    it { should contain_pe_concat__fragment('orchestration-services metrics-service') }
    it { should contain_pe_concat__fragment('orchestration-services remote-rbac-consumer-service') }
  end

  context "configuring other settings" do
    context "with pcp-timeout set" do
      before :each do
        @params['pcp_timeout'] = 10
      end
      it { should contain_pe_hocon_setting("orchestration-services.orchestrator.pcp-timeout").with(:ensure => 'present', :value => 10) }
    end

    context "without pcp-timeout set" do
      it { should contain_pe_hocon_setting("orchestration-services.orchestrator.pcp-timeout").with(:ensure => 'absent') }
    end

    context "using a global concurrency compile setting" do
      before :each do
        @params['global_concurrent_compiles'] = 8
      end

      it { should contain_pe_hocon_setting("orchestration-services.orchestrator.global-concurrent-compiles").with(:ensure => 'present', :value => 8) }
    end

    context "without global-concurrent-compiles set" do
      it { should contain_pe_hocon_setting("orchestration-services.orchestrator.global-concurrent-compiles").with(:ensure => 'absent') }
    end

    context "with job-prune-threshold specified" do
      before :each do
        @params['job_prune_threshold'] = 21
      end

      it { should contain_pe_hocon_setting("orchestration-services.orchestrator.job-prune-threshold").with(:ensure => 'present', :value => 21) }
    end

    context "without job-prune-threshold set" do
      it { should contain_pe_hocon_setting("orchestration-services.orchestrator.job-prune-threshold").with(:ensure => 'absent') }
    end
  end
end
