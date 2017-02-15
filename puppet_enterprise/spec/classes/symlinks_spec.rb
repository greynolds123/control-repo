require 'spec_helper'

describe 'puppet_enterprise::symlinks' do
  before :each do
    @facter_facts = {
      'kernel'                    => 'Linux',
      'platform_symlink_writable' => true,
    }

    @params = {}
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  context "when non boolean is passed for paramater manage_symlinks" do
    before :each do
      @params['manage_symlinks'] = 'IamAString'
    end

    it { should_not compile }
  end
end
