require 'spec_helper'
describe 'moodle' do

  context 'with defaults for all parameters' do
    it { should contain_class('moodle') }
  end
end
