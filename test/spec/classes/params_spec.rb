require 'spec_helper'
describe 'params' do
  context 'with default values for all parameters' do
    it { should contain_class('params') }
  end
end
