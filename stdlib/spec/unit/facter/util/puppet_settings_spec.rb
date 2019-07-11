require 'spec_helper'
require 'facter/util/puppet_settings'

describe Facter::Util::PuppetSettings do
  describe '#with_puppet' do
    context 'without Puppet loaded' do
      before(:each) do
<<<<<<< HEAD
        Module.expects(:const_get).with('Puppet').raises(NameError)
=======
        allow(Module).to receive(:const_get).with('Puppet').and_raise(NameError)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      end

      it 'is nil' do
        expect(subject.with_puppet { Puppet[:vardir] }).to be_nil
      end
      it 'does not yield to the block' do
<<<<<<< HEAD
        Puppet.expects(:[]).never
=======
        expect(Puppet).to receive(:[]).never
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        expect(subject.with_puppet { Puppet[:vardir] }).to be_nil
      end
    end
    context 'with Puppet loaded' do
<<<<<<< HEAD
=======
      # module Puppet
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      module Puppet; end
      let(:vardir) { '/var/lib/puppet' }

      before :each do
<<<<<<< HEAD
        Puppet.expects(:[]).with(:vardir).returns vardir
=======
        allow(Puppet).to receive(:[]).with(:vardir).and_return(vardir)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      end

      it 'yields to the block' do
        subject.with_puppet { Puppet[:vardir] }
      end
      it 'returns the nodes vardir' do
        expect(subject.with_puppet { Puppet[:vardir] }).to eq vardir
      end
    end
  end
end
