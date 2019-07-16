require 'spec_helper'
describe 'puppet_enterprise' do

  context 'with defaults for all parameters' do
    it { should contain_class('puppet_enterprise') }
  end
end
