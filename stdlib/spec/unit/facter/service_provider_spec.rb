require 'spec_helper'
require 'puppet/type'
require 'puppet/type/service'

describe 'service_provider', :type => :fact do
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  context 'when macosx' do
    it 'returns launchd' do
      provider = Puppet::Type.type(:service).provider(:launchd)
<<<<<<< HEAD
      Puppet::Type.type(:service).stubs(:defaultprovider).returns provider
=======
      allow(Puppet::Type.type(:service)).to receive(:defaultprovider).and_return(provider)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

      expect(Facter.fact(:service_provider).value).to eq('launchd')
    end
  end

  context 'when systemd' do
    it 'returns systemd' do
      provider = Puppet::Type.type(:service).provider(:systemd)
<<<<<<< HEAD
      Puppet::Type.type(:service).stubs(:defaultprovider).returns provider
=======
      allow(Puppet::Type.type(:service)).to receive(:defaultprovider).and_return(provider)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

      expect(Facter.fact(:service_provider).value).to eq('systemd')
    end
  end

  context 'when redhat' do
    it 'returns redhat' do
      provider = Puppet::Type.type(:service).provider(:redhat)
<<<<<<< HEAD
      Puppet::Type.type(:service).stubs(:defaultprovider).returns provider
=======
      allow(Puppet::Type.type(:service)).to receive(:defaultprovider).and_return(provider)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

      expect(Facter.fact(:service_provider).value).to eq('redhat')
    end
  end
end
