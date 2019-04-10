require 'spec_helper'

describe 'puppet_enterprise::profile::master::classifier' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'master.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir'    => '/tmp/file',
    }

    @params = { 'classifier_host'      => 'classifier.rspec',
                'classifier_url_prefix'  => '/classifier-api',
                'classifier_port' => '1234', }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:confdir) { "/etc/puppetlabs/puppet" }

  context "managing puppet.conf" do
    it { should contain_pe_ini_setting('node_terminus').with_value('classifier') }
  end
  context "managing puppet to talk to the classifier" do
    it { should contain_file("#{confdir}/classifier.yaml").with_content(%r[prefix:\s*/classifier-api]) }
  end
  context "specifying a custom node_terminus" do
    let(:params) do
      { 'classifier_host'       => 'classifier.rspec',
                     'classifier_url_prefix' => '/classifier-api',
                     'classifier_port'       => '1234',
                     'node_terminus'         => 'custom',
                   }
    end
    it { should contain_pe_ini_setting('node_terminus').with_value('custom') }
  end
end
