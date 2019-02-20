require 'spec_helper'

describe 'puppet_enterprise::mcollective::service' do

  before :each do
    @facter_facts = {}
    @params = {}
  end

  let(:facts)  { @facter_facts }
  let(:params) { @params }

  context "default is mcollective service running and enabled" do
    it { should contain_service('mcollective').with_ensure('running') }
    it { should contain_service('mcollective').with('enable' => true) }
  end

  context "can override ensure setting to stopped on mcollective service" do
    before :each do
      @params['ensure'] = 'stopped'
      @params['enable'] = false
    end
    it { should contain_service('mcollective').with_ensure('stopped') }
    it { should contain_service('mcollective').with('enable' => false) }
  end

  it { should satisfy_all_relationships }
end
