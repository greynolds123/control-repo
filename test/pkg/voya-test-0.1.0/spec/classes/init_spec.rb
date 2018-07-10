require 'spec_helper'
describe 'test' do
  context 'with default values for all parameters' do
    it { should contain_class('test') }
  end
end
