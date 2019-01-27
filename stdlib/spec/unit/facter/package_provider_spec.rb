<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
require 'spec_helper'
require 'puppet/type'
require 'puppet/type/package'

describe 'package_provider', :type => :fact do
<<<<<<< HEAD
  before { Facter.clear }
  after { Facter.clear }
=======
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

  ['4.2.2', '3.7.1 (Puppet Enterprise 3.2.1)'].each do |puppetversion|
    describe "on puppet ''#{puppetversion}''" do
      before :each do
        Facter.stubs(:value).returns puppetversion
      end

<<<<<<< HEAD
      context "darwin" do
        it "should return pkgdmg" do
=======
      context 'when darwin' do
        it 'returns pkgdmg' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
          provider = Puppet::Type.type(:package).provider(:pkgdmg)
          Puppet::Type.type(:package).stubs(:defaultprovider).returns provider

          expect(Facter.fact(:package_provider).value).to eq('pkgdmg')
        end
      end

<<<<<<< HEAD
      context "centos 7" do
        it "should return yum" do
=======
      context 'when centos 7' do
        it 'returns yum' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
          provider = Puppet::Type.type(:package).provider(:yum)
          Puppet::Type.type(:package).stubs(:defaultprovider).returns provider

          expect(Facter.fact(:package_provider).value).to eq('yum')
        end
      end

<<<<<<< HEAD
      context "ubuntu" do
        it "should return apt" do
=======
      context 'when ubuntu' do
        it 'returns apt' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
          provider = Puppet::Type.type(:package).provider(:apt)
          Puppet::Type.type(:package).stubs(:defaultprovider).returns provider

          expect(Facter.fact(:package_provider).value).to eq('apt')
        end
      end
    end
  end
end
