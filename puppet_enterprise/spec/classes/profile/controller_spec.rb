require 'spec_helper'

describe 'puppet_enterprise::profile::controller' do
  it { should contain_package("pe-client-tools") }

  [
    "/etc/puppetlabs/client-tools",
    "/etc/puppetlabs/client-tools/ssl",
    "/etc/puppetlabs/client-tools/ssl/certs"
  ].each do |path|
    it { should contain_file(path)
         .with_ensure('directory')
         .with_owner('root')
         .with_group('root')
         .with_mode('0755')
         .with_recurse(false) }
  end

  it { should contain_file("/etc/puppetlabs/client-tools/ssl/certs/ca.pem")
         .with_ensure('present')
         .with_owner('root')
         .with_group('root')
         .with_mode('0444')
         .with_source("/etc/puppetlabs/puppet/ssl/certs/ca.pem") }

  describe "puppet-code" do
    describe "when manage_puppet_code is false" do
      let(:params) { {"manage_puppet_code" => false} }
      it { should_not contain_file("/etc/puppetlabs/client-tools/puppet-code.conf") }
    end

    describe "when manage_puppet_code is true" do
      let(:params) { {"manage_puppet_code" => true} }
      it { should contain_file("/etc/puppetlabs/client-tools/puppet-code.conf")
           .with_ensure('present')
           .with_owner('root')
           .with_group('root')
           .with_mode('0444') }

      it "defaults the service URL to the CA server for puppet-code" do
        raw = catalogue.resource('file', '/etc/puppetlabs/client-tools/puppet-code.conf')[:content]
        json = JSON.parse(raw)
        expect(json['service-url']).to eq("https://master.rspec:8170/code-manager")
      end
    end
  end

  describe "orchestrator" do
    describe "when manage_orchestrator is false" do
      let(:params) { {"manage_orchestrator" => false} }
      it { should_not contain_file("/etc/puppetlabs/client-tools/orchestrator.conf") }
    end

    describe "when manage_orchestrator is true" do
      let(:params) { {"manage_orchestrator" => true} }
      it { should contain_file("/etc/puppetlabs/client-tools/orchestrator.conf")
           .with_ensure('present')
           .with_owner('root')
           .with_group('root')
           .with_mode('0444') }

      it "defaults the service URL to the CA server for orchestrator" do
        raw = catalogue.resource('file', '/etc/puppetlabs/client-tools/orchestrator.conf')[:content]
        json = JSON.parse(raw)
        expect(json['options']['service-url']).to eq("https://master.rspec:8143")
      end
    end
  end

  describe "puppet-access" do
    it { should contain_file("/etc/puppetlabs/client-tools/puppet-access.conf")
         .with_ensure('present')
         .with_owner('root')
         .with_group('root')
         .with_mode('0444') }

    it "defaults the service URL to the console-server rbac instance" do
      raw = catalogue.resource('file', '/etc/puppetlabs/client-tools/puppet-access.conf')[:content]
      json = JSON.parse(raw)
      expect(json['service-url']).to eq("https://console.rspec:4433/rbac-api")
      expect(json['certificate-file']).to eq("/etc/puppetlabs/puppet/ssl/certs/ca.pem")
    end
  end

  describe "puppetdb-cli" do
    it { should contain_file("/etc/puppetlabs/client-tools/puppetdb.conf")
                 .with_ensure('present')
                 .with_owner('root')
                 .with_group('root')
                 .with_mode('0444') }

    it "defaults the service URL to the PuppetDB instance" do
      raw = catalogue.resource('file', '/etc/puppetlabs/client-tools/puppetdb.conf')[:content]
      json = JSON.parse(raw)['puppetdb']
      expect(json['server_urls']).to eq(["https://puppetdb.rspec:8081"])
      expect(json['cacert']).to eq("/etc/puppetlabs/puppet/ssl/certs/ca.pem")
    end
  end

  describe "puppetdb-cli with multiple PuppetDBs" do
    let(:pre_condition) {
      <<-PRE_COND
class {'puppet_enterprise':
  certificate_authority_host   => 'ca.rspec',
  puppet_master_host           => 'master.rspec',
  console_host                 => 'console.rspec',
  puppetdb_host                => ['puppetdb.rspec', 'other.rspec'],
  puppetdb_port                => ['8080', '9999'],
  database_host                => 'database.rspec',
  mcollective_middleware_hosts => ['mco.rspec'],
  pcp_broker_host              => 'pcp_broker.rspec',
}
PRE_COND
    }

    it { should contain_file("/etc/puppetlabs/client-tools/puppetdb.conf")
                  .with_ensure('present')
                  .with_owner('root')
                  .with_group('root')
                  .with_mode('0444') }

    it "defaults the service URL to the PuppetDB instance" do
      raw = catalogue.resource('file', '/etc/puppetlabs/client-tools/puppetdb.conf')[:content]
      json = JSON.parse(raw)['puppetdb']
      expect(json['server_urls']).to eq(["https://puppetdb.rspec:8080", "https://other.rspec:9999"])
      expect(json['cacert']).to eq("/etc/puppetlabs/puppet/ssl/certs/ca.pem")
    end
  end

  it { should satisfy_all_relationships }
end
