require 'spec_helper'
describe 'cron' do

  context 'with defaults for all parameters' do
    it { should include_class('cron::config') }
    it { should include_class('cron::mc_cron') }
  end
end
