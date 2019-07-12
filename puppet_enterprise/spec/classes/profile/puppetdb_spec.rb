require 'spec_helper'

describe 'puppet_enterprise::profile::puppetdb' do
  before :each do
    @facter_facts = {
      'osfamily'   => 'Debian',
      'fqdn'       => 'console.rspec',
      'clientcert' => 'awesomecert',
      'processors' => {"count"=>8, "speed"=>"2.5 GHz"},
    }

    @params = {
      'certname'          => 'puppetdb.local.domain',
      'database_host'     => 'database.local.domain',
      'master_certname'       => 'master.local.domain',
      'whitelisted_certnames' => ['pe-internal-dashboard', 'cert1']
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:certname) { @params['certname'] }
  let(:sharedir) { '/etc/puppetlabs/puppetdb/ssl' }
  let(:ssldir) { '/etc/puppetlabs/puppet/ssl' }
  let(:cert_whitelist_path) { '/etc/puppetlabs/puppetdb/certificate-whitelist' }

  it { should contain_class('puppet_enterprise::puppetdb') }

  context "managing certs" do
    it { should contain_file("#{sharedir}").with_mode('0600') }
    it { should contain_file("#{sharedir}/#{certname}.cert.pem").with(:source => "#{ssldir}/certs/#{certname}.pem", :mode => '0400') }
    it { should contain_file("#{sharedir}/#{certname}.private_key.pem").with(:source => "#{ssldir}/private_keys/#{certname}.pem", :mode => '0400') }
  end

  context "managing certificate-whitelist" do
    it { should contain_file(cert_whitelist_path) }

    it { should contain_pe_file_line("#{cert_whitelist_path}:pe-internal-dashboard").with(
      'path' => cert_whitelist_path,
      'line' => 'pe-internal-dashboard'
    )}
    it { should contain_pe_file_line("#{cert_whitelist_path}:cert1").with(
      'path' => cert_whitelist_path,
      'line' => 'cert1'
    )}
    it { should contain_pe_file_line("#{cert_whitelist_path}:#{certname}").with(
      'path' => cert_whitelist_path,
      'line' => @params['certname']
    )}
    it { should contain_pe_file_line("#{cert_whitelist_path}:master.local.domain").with(
      'path' => cert_whitelist_path,
      'line' => 'master.local.domain'
    )}
  end

  context "connecting PuppetDB to pgsql" do
    it { should contain_pe_ini_setting('[database]-puppetdb_subname').with(
      'value' => '//database.local.domain:5432/pe-puppetdb?ssl=true' +
                 '&sslfactory=org.postgresql.ssl.jdbc4.LibPQFactory' +
                 '&sslmode=verify-full' +
                 '&sslrootcert=/etc/puppetlabs/puppet/ssl/certs/ca.pem' +
                 '&sslkey=/etc/puppetlabs/puppetdb/ssl/puppetdb.local.domain.private_key.pk8' +
                 '&sslcert=/etc/puppetlabs/puppetdb/ssl/puppetdb.local.domain.cert.pem'
    )}

    context "when not using ssl" do
      let(:pre_condition) do
<<-PRE_COND
class {'puppet_enterprise':
  certificate_authority_host   => 'ca.rspec',
  puppet_master_host           => 'master.rspec',
  console_host                 => 'console.rspec',
  puppetdb_host                => 'puppetdb.rspec',
  database_host                => 'database.rspec',
  mcollective_middleware_hosts => ['mco.rspec'],
  pcp_broker_host              => 'pcp_broker.rspec',
  database_ssl                 => false,
}
PRE_COND

      end

      it { should contain_pe_ini_setting('[database]-puppetdb_subname').with(
        'value' => '//database.local.domain:5432/pe-puppetdb'
      )}
    end
  end

  context "when using default certname" do
    before :each do
      @params.delete('certname')
    end
    it { should contain_class('puppet_enterprise::puppetdb').with(:certname => @facter_facts['clientcert']) }

    it { should contain_pe_file_line("#{cert_whitelist_path}:#{@facter_facts['clientcert']}").with(
      'path' => cert_whitelist_path,
      'line' => @facter_facts['clientcert'],
    )}
  end

  it { should satisfy_all_relationships }
end
