require 'spec_helper'

  require config_spec.rb
  require nmap_spec.rb
  require policy_spec.rb

 context 'with defaults for all parameters' do
    it { should contain_class('init') }
  end
end



