require 'spec_helper'
require 'facter/root_home'
describe 'Root Home Specs' do
  describe Facter::Util::RootHome do
    context 'when solaris' do
      let(:root_ent) { 'root:x:0:0:Super-User:/:/sbin/sh' }
      let(:expected_root_home) { '/' }

      it 'returns /' do
<<<<<<< HEAD
        Facter::Util::Resolution.expects(:exec).with('getent passwd root').returns(root_ent)
=======
        expect(Facter::Util::Resolution).to receive(:exec).with('getent passwd root').and_return(root_ent)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        expect(described_class.returnt_root_home).to eq(expected_root_home)
      end
    end
    context 'when linux' do
      let(:root_ent) { 'root:x:0:0:root:/root:/bin/bash' }
      let(:expected_root_home) { '/root' }

      it 'returns /root' do
<<<<<<< HEAD
        Facter::Util::Resolution.expects(:exec).with('getent passwd root').returns(root_ent)
=======
        expect(Facter::Util::Resolution).to receive(:exec).with('getent passwd root').and_return(root_ent)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        expect(described_class.returnt_root_home).to eq(expected_root_home)
      end
    end
    context 'when windows' do
<<<<<<< HEAD
      before :each do
        Facter::Util::Resolution.expects(:exec).with('getent passwd root').returns(nil)
      end
      it 'is nil on windows' do
=======
      it 'is nil on windows' do
        expect(Facter::Util::Resolution).to receive(:exec).with('getent passwd root').and_return(nil)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        expect(described_class.returnt_root_home).to be_nil
      end
    end
  end

  describe 'root_home', :type => :fact do
    before(:each) { Facter.clear }
    after(:each) { Facter.clear }

    context 'when macosx' do
      before(:each) do
<<<<<<< HEAD
        Facter.fact(:kernel).stubs(:value).returns('Darwin')
        Facter.fact(:osfamily).stubs(:value).returns('Darwin')
=======
        allow(Facter.fact(:kernel)).to receive(:value).and_return('Darwin')
        allow(Facter.fact(:osfamily)).to receive(:value).and_return('Darwin')
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      end
      let(:expected_root_home) { '/var/root' }

      sample_dscacheutil = File.read(fixtures('dscacheutil', 'root'))

      it 'returns /var/root' do
<<<<<<< HEAD
        Facter::Util::Resolution.stubs(:exec).with('dscacheutil -q user -a name root').returns(sample_dscacheutil)
=======
        allow(Facter::Util::Resolution).to receive(:exec).with('dscacheutil -q user -a name root').and_return(sample_dscacheutil)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        expect(Facter.fact(:root_home).value).to eq(expected_root_home)
      end
    end

    context 'when aix' do
      before(:each) do
<<<<<<< HEAD
        Facter.fact(:kernel).stubs(:value).returns('AIX')
        Facter.fact(:osfamily).stubs(:value).returns('AIX')
=======
        allow(Facter.fact(:kernel)).to receive(:value).and_return('AIX')
        allow(Facter.fact(:osfamily)).to receive(:value).and_return('AIX')
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      end
      let(:expected_root_home) { '/root' }

      sample_lsuser = File.read(fixtures('lsuser', 'root'))

      it 'returns /root' do
<<<<<<< HEAD
        Facter::Util::Resolution.stubs(:exec).with('lsuser -c -a home root').returns(sample_lsuser)
=======
        allow(Facter::Util::Resolution).to receive(:exec).with('lsuser -c -a home root').and_return(sample_lsuser)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
        expect(Facter.fact(:root_home).value).to eq(expected_root_home)
      end
    end
  end
end
