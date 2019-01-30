require 'spec_helper'

<<<<<<< HEAD
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
 context 'with defaults for all parameters' do
    it { should contain_class('init') }
  end
end

>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
