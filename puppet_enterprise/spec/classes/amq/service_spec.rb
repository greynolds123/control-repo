require 'spec_helper'

describe 'puppet_enterprise::amq::service' do

  before :each do
    @facter_facts = {}
    @params = {}
  end

  let(:facts)  { @facter_facts }
  let(:params) { @params }

  context "default is pe-activemq service running and enabled" do
    it { should contain_service('pe-activemq').with_ensure('running') }
    it { should contain_service('pe-activemq').with('enable' => true) }
  end

  context "can override ensure setting to stopped on pe-activemq service" do
    before :each do
      @params['ensure'] = 'stopped'
      @params['enable'] = false
    end
    it { should contain_service('pe-activemq').with_ensure('stopped') }
    it { should contain_service('pe-activemq').with('enable' => false) }
  end
end
