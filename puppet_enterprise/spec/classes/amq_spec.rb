require 'spec_helper'

describe 'puppet_enterprise::amq' do
  before :all do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'fqdn'              => 'amq.local.domain',
    }

    @params = {
      'brokername' => 'puppetdb.local.domain',
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  it { should contain_class('puppet_enterprise::amq::config') }
end

