require 'spec_helper'

describe 'reverse_proxy_master', :type => :host do
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
    it { should contain_pe_concat__fragment('puppetserver reverse-proxy-ca-service') }
    it { should contain_pe_hocon_setting('certificate-authority.proxy-config.proxy-target-url').with_value('https://master.rspec:8140') }
  end
end
