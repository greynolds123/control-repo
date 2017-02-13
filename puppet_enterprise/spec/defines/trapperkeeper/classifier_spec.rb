require 'spec_helper'

describe 'puppet_enterprise::trapperkeeper::classifier' do
  before :all do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'classifier.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
    }

    @params = {
      'database_host'          => 'db.rspec',
      'database_port'          => 54321,
      'database_user'          => 'custom_user',
      'database_name'          => 'pe-classifier',
      'client_certname'        => 'console.rspec',
      'synchronization_period' => 180,
      'prune_days_threshold'   => 14,
    }
  end

  let(:facts)  { @facter_facts }
  let(:params) { @params }
  let(:title)  { 'classifier' }

  context "when the parameters are valid" do
    it do
      should contain_file("/etc/puppetlabs/classifier/conf.d/classifier.conf").with(
        :owner => "pe-classifier",
        :group => "pe-classifier",
        :mode => "0640"
      )
    end
    it { should contain_pe_hocon_setting("#{title}.classifier.database.subname").with_value('//db.rspec:54321/pe-classifier') }
    it { should contain_pe_hocon_setting("#{title}.classifier.database.user").with_value('custom_user') }
    it { should_not contain_pe_hocon_setting("#{title}.classifier.database.password") }
    it { should contain_pe_hocon_setting("#{title}.classifier.puppet-master").with_ensure('absent') }
    it { should contain_pe_hocon_setting("#{title}.classifier.ssl-key").with_value('/opt/puppetlabs/server/data/classifier/certs/console.rspec.private_key.pem') }
    it { should contain_pe_hocon_setting("#{title}.classifier.ssl-cert").with_value('/opt/puppetlabs/server/data/classifier/certs/console.rspec.cert.pem') }
    it { should contain_pe_hocon_setting("#{title}.classifier.ssl-ca-cert").with_value('/etc/puppetlabs/puppet/ssl/certs/ca.pem') }
    it { should contain_pe_hocon_setting("#{title}.classifier.synchronization-period").with_value('180') }
    it { should contain_pe_hocon_setting("#{title}.classifier.prune-days-threshold").with_value('14') }
    it { should contain_pe_concat__fragment('classifier classifier-service') }
    it { should contain_pe_concat__fragment('classifier activity-reporting-service') }
    it { should contain_pe_concat__fragment('classifier jetty9-service') }
  end

  context "with custom synchronization period" do
    before(:each) do
      @params['synchronization_period'] = 300
    end
    it { should contain_pe_hocon_setting("#{title}.classifier.synchronization-period").with_value('300') }
  end

  context "with custom master host" do
    before(:each) do
      @params['master_host'] = 'custom.puppet.master'
    end
    it { should contain_pe_hocon_setting("#{title}.classifier.puppet-master").with_value('https://custom.puppet.master:8140') }
  end

end
