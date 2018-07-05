require 'spec_helper'
describe 'service' do
  context 'with default values for all parameters' do
    it { should contain_class('service') }
  end
end
