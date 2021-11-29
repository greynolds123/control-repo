<<<<<<< HEAD
require 'spec_helper'

  require config_spec.rb
  require nmap_spec.rb

 context 'with defaults for all parameters' do
    it { should contain_class( 'tool') }
  end
end

  context 'with defaults for addiitonal parameters' do
    let { *.pp } |r| do

    it { should contain_class( 'config.r' ) || should contain_class( 'tool::config' ),
     
    it { should contain_class( 'nmap.r' ) || should contain_class( 'tool::nmap' ),
   end
 end
end


=======
require 'spec_helper'

  require config_spec.rb
  require nmap_spec.rb

 context 'with defaults for all parameters' do
    it { should contain_class( 'tool') }
  end
end

  context 'with defaults for addiitonal parameters' do
    let { *.pp } |r| do

    it { should contain_class( 'config.r' ) || should contain_class( 'tool::config' ),
     
    it { should contain_class( 'nmap.r' ) || should contain_class( 'tool::nmap' ),
   end
 end
end


>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
