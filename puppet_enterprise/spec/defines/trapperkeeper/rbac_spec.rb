require 'spec_helper'

describe 'puppet_enterprise::trapperkeeper::rbac' do
  before :all do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'rbac.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
    }

    @params = {
      'certname'          => 'blah.foo.bar',
      'database_host'     => 'db.rspec',
      'database_port'     => 54321,
      'database_password' => 'secretly',
      'database_name'     => 'pe-rbac',
    }

    @customization_params = {
      'password_reset_expiration' => 24,
      'session_timeout'           => 1440,
      'token_auth_lifetime'       => "666m",
      'failed_attempts_lockout'   => 3,
      'ds_trust_chain'            => "/foo/bar",
    }
  end

  let(:facts)          { @facter_facts }
  let(:params)         { @params }
  let(:title)          { 'rbac' }
  let(:config_file)    { '/etc/puppetlabs/rbac/conf.d/rbac.conf'}
  let(:db_config_file) { '/etc/puppetlabs/rbac/conf.d/rbac-database.conf'}

  context "when the parameters are valid" do
    it { should contain_pe_hocon_setting("#{title}.rbac.certificate-whitelist").with_value('/etc/puppetlabs/rbac/rbac-certificate-whitelist') }
    it { should contain_pe_hocon_setting("#{title}.rbac.token-private-key").with_value('/opt/puppetlabs/server/data/rbac/certs/blah.foo.bar.private_key.pem') }
    it { should contain_pe_hocon_setting("#{title}.rbac.token-public-key").with_value('/opt/puppetlabs/server/data/rbac/certs/blah.foo.bar.cert.pem') }
    it { should contain_pe_hocon_setting("#{title}.rbac.database.subname").with_value('//db.rspec:54321/pe-rbac') }
    it { should contain_pe_hocon_setting("#{title}.rbac.database.maximum-pool-size").with_value(10) }
    it { should contain_pe_hocon_setting("#{title}.rbac.database.connection-timeout").with_value(30000) }
    it { should contain_pe_hocon_setting("#{title}.rbac.database.connection-check-timeout").with_value(5000) }

    it do
      should contain_file(config_file).with(
        :owner => "pe-rbac",
        :group => "pe-rbac",
        :mode => "0640"
      )
    end
    it { should contain_pe_hocon_setting("#{title}.rbac.password-reset-expiration").with_ensure('absent') }
    it { should contain_pe_hocon_setting("#{title}.rbac.session-timeout").with_ensure('absent') }
    it { should contain_pe_hocon_setting("#{title}.rbac.token-auth-lifetime").with_ensure('absent') }
    it { should contain_pe_hocon_setting("#{title}.rbac.failed-attempts-lockout").with_ensure('absent') }
    it { should contain_pe_hocon_setting("#{title}.rbac.ds-trust-chain").with_ensure('absent') }
    it { should contain_pe_concat__fragment('rbac rbac-service') }
    it { should contain_pe_concat__fragment('rbac rbac-storage-service') }
    it { should contain_pe_concat__fragment('rbac rbac-http-api-service') }
    it { should contain_pe_concat__fragment('rbac activity-reporting-service') }
    it { should contain_pe_concat__fragment('rbac jetty9-service') }
  end

  context "using a malformed lifetime" do
    ["bananas", {:foo => :bar}, 1.0, "10k"].each do |lifetime|
      let(:params) { @params.merge({'token_auth_lifetime' => lifetime}) }
      it { should compile.and_raise_error(/token_auth_lifetime must either be an integer/) }
    end
  end

  context "using customization parameters" do
    let(:params) { @params.merge(@customization_params) }
    it { should contain_pe_hocon_setting("#{title}.rbac.password-reset-expiration").with_value('24') }
    it { should contain_pe_hocon_setting("#{title}.rbac.session-timeout").with_value('1440') }
    it { should contain_pe_hocon_setting("#{title}.rbac.token-auth-lifetime").with_value('666m') }
    it { should contain_pe_hocon_setting("#{title}.rbac.failed-attempts-lockout").with_value('3') }
    it { should contain_pe_hocon_setting("#{title}.rbac.ds-trust-chain").with_value('/foo/bar') }
  end
end
