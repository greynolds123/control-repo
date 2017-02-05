require 'spec_helper'

describe 'puppet_enterprise::amq::config' do
  before :each do
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

    @params = {
      'brokername' => 'console.rspec'
    }

  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  describe "managing activemq.xml" do
    let(:file) { '/etc/puppetlabs/activemq/activemq.xml' }
    it { should contain_file(file).with(:owner => 'root',
                                        :group => 'pe-activemq',
                                        :mode => '0640') }
  end
end
