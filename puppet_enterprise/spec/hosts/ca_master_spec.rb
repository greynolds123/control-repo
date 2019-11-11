require 'spec_helper'

describe 'ca_master', :type => :host do
  before :each do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'master.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
    }

    Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
      nil
    end
  end

  let(:facts) { @facter_facts }
  let(:pre_condition) {}

  it { should satisfy_all_relationships }

  context "when compiled" do
    it { should contain_pe_concat__fragment('puppetserver certificate-authority-service') }
    it { should contain_pe_puppet_authorization__rule('puppetlabs certificate status')
      .with_match_request_path('/puppet-ca/v1/certificate_status')
      .with_match_request_type('path')
      .with_match_request_method(['get', 'put', 'delete'])
      .with_allow(['console.rspec'])
      .with_sort_order(500)
      .with_path('/etc/puppetlabs/puppetserver/conf.d/auth.conf')
      .with_notify('Service[pe-puppetserver]') }
    it { should contain_pe_hocon_setting('certificate-authority.proxy-config').with_ensure('absent') }
    it do
      should contain_pe_hocon_setting('certificate-authority.proxy-config.proxy-target-url')
        .with_ensure('absent')
    end
    it do
      should contain_pe_hocon_setting('certificate-authority.proxy-config.ssl-opts.ssl-cert')
        .with_ensure('absent')
    end
    it do
      should contain_pe_hocon_setting('certificate-authority.proxy-config.ssl-opts.ssl-key')
        .with_ensure('absent')
    end
    it do
      should contain_pe_hocon_setting('certificate-authority.proxy-config.ssl-opts.ssl-ca-cert')
        .with_ensure('absent')
    end
  end

end
