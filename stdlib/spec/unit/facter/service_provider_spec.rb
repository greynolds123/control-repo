<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
require 'spec_helper'
require 'puppet/type'
require 'puppet/type/service'

describe 'service_provider', :type => :fact do
<<<<<<< HEAD
  before { Facter.clear }
  after { Facter.clear }

  context "macosx" do
    it "should return launchd" do
=======
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  context 'when macosx' do
    it 'returns launchd' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      provider = Puppet::Type.type(:service).provider(:launchd)
      Puppet::Type.type(:service).stubs(:defaultprovider).returns provider

      expect(Facter.fact(:service_provider).value).to eq('launchd')
    end
  end

<<<<<<< HEAD
  context "systemd" do
    it "should return systemd" do
=======
  context 'when systemd' do
    it 'returns systemd' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      provider = Puppet::Type.type(:service).provider(:systemd)
      Puppet::Type.type(:service).stubs(:defaultprovider).returns provider

      expect(Facter.fact(:service_provider).value).to eq('systemd')
    end
  end

<<<<<<< HEAD
  context "redhat" do
    it "should return redhat" do
=======
  context 'when redhat' do
    it 'returns redhat' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      provider = Puppet::Type.type(:service).provider(:redhat)
      Puppet::Type.type(:service).stubs(:defaultprovider).returns provider

      expect(Facter.fact(:service_provider).value).to eq('redhat')
    end
  end
<<<<<<< HEAD

=======
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
