require 'spec_helper'
describe 'kernel' do

  context 'with defaults for all parameters' do
    it { should contain_class('kernel') }
  end
end
