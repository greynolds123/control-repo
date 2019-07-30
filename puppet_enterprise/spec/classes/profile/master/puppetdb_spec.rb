require 'spec_helper'

describe 'puppet_enterprise::profile::master::puppetdb' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'puppetdb.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir'    => '/tmp/file',
    }

    @params = {
      'puppetdb_host' => 'puppetdb.rspec',
      'puppetdb_port' => '1234',
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:confdir) { "/etc/puppetlabs/puppet" }

  context "managing puppet.conf" do
    it { should contain_pe_ini_setting('storeconfigs').with_value('true') }
    it { should contain_pe_ini_setting('storeconfigs_backend').with_value('puppetdb') }
    it { should contain_pe_ini_subsetting('reports_puppetdb').with_setting('reports').with_subsetting('puppetdb') }
  end
  context "remove reports setting from puppet.conf" do
    before :each do
        @params['report_processor_ensure'] = 'absent'
    end

    it { should contain_pe_ini_subsetting('reports_puppetdb').with_setting('reports').with_ensure('absent') }
  end
  context "managing puppetdb.conf" do
    it { should contain_file("#{confdir}/puppetdb.conf").with_ensure('file') }
    it { should contain_pe_ini_setting('puppetdb.conf_server_urls').with_value('https://puppetdb.rspec:1234') }
    it { should contain_pe_ini_setting('puppetdb.conf_soft_write_failure').with_value('false') }
    it { should contain_pe_ini_setting('puppetdb.conf_include_unchanged_resources').with_value('true') }
  end

  context "managing puppetdb.conf with PuppetDB HA" do
    before :each do
      @params['puppetdb_host'] = ['puppetdb.rspec', 'replica.vm']
      @params['puppetdb_port'] = ['7888', '8081']
    end
    it { should contain_file("#{confdir}/puppetdb.conf").with_ensure('file') }
    it { should contain_pe_ini_setting('puppetdb.conf_server_urls').with_value('https://puppetdb.rspec:7888,https://replica.vm:8081') }
  end
end
