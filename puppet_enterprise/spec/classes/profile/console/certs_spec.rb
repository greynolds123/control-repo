require 'spec_helper'

describe 'puppet_enterprise::profile::console::certs' do
  before :all do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'console.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir'    => '/tmp/file',
    }

    @params = { 'certname' => 'console-rspec' }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:services_sharedir) { '/opt/puppetlabs/server/data/console-services' }
  let(:ssldir) { '/etc/puppetlabs/puppet/ssl' }

  context "managing certs" do
    it { should contain_file("#{services_sharedir}/certs").with_mode('0600') }
    it {
      should contain_file("#{services_sharedir}/certs/console-rspec.cert.pem").with(
        :source => "#{ssldir}/certs/console-rspec.pem",
      )
    }

    it {
      should contain_file("#{services_sharedir}/certs/console-rspec.private_key.pk8").with(
               :owner => "pe-console-services",
               :group => "pe-console-services",
               :mode => "0400"
             )
    }

  end
end
