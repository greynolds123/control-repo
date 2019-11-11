require 'spec_helper'
require 'puppet/type'
require 'puppet/type/package'

describe 'package_provider', :type => :fact do
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  ['4.2.2', '3.7.1 (Puppet Enterprise 3.2.1)'].each do |puppetversion|
    describe "on puppet ''#{puppetversion}''" do
      before :each do
<<<<<<< HEAD
        Facter.stubs(:value).returns puppetversion
=======
        allow(Facter).to receive(:value).and_return(puppetversion)
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      end

      context 'when darwin' do
        it 'returns pkgdmg' do
          provider = Puppet::Type.type(:package).provider(:pkgdmg)
<<<<<<< HEAD
          Puppet::Type.type(:package).stubs(:defaultprovider).returns provider
=======
          allow(Puppet::Type.type(:package)).to receive(:defaultprovider).and_return(provider)
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

          expect(Facter.fact(:package_provider).value).to eq('pkgdmg')
        end
      end

      context 'when centos 7' do
        it 'returns yum' do
          provider = Puppet::Type.type(:package).provider(:yum)
<<<<<<< HEAD
          Puppet::Type.type(:package).stubs(:defaultprovider).returns provider
=======
          allow(Puppet::Type.type(:package)).to receive(:defaultprovider).and_return(provider)
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

          expect(Facter.fact(:package_provider).value).to eq('yum')
        end
      end

      context 'when ubuntu' do
        it 'returns apt' do
          provider = Puppet::Type.type(:package).provider(:apt)
<<<<<<< HEAD
          Puppet::Type.type(:package).stubs(:defaultprovider).returns provider
=======
          allow(Puppet::Type.type(:package)).to receive(:defaultprovider).and_return(provider)
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

          expect(Facter.fact(:package_provider).value).to eq('apt')
        end
      end
    end
  end
end
