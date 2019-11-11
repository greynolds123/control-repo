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
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      end

      it 'is nil' do
        expect(subject.with_puppet { Puppet[:vardir] }).to be_nil
      end
      it 'does not yield to the block' do
<<<<<<< HEAD
        Puppet.expects(:[]).never
=======
        expect(Puppet).to receive(:[]).never
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        expect(subject.with_puppet { Puppet[:vardir] }).to be_nil
      end
    end
    context 'with Puppet loaded' do
<<<<<<< HEAD
=======
      # module Puppet
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      module Puppet; end
      let(:vardir) { '/var/lib/puppet' }

      before :each do
<<<<<<< HEAD
        Puppet.expects(:[]).with(:vardir).returns vardir
=======
        allow(Puppet).to receive(:[]).with(:vardir).and_return(vardir)
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
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
