<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
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
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
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
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
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
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      provider = Puppet::Type.type(:service).provider(:redhat)
      Puppet::Type.type(:service).stubs(:defaultprovider).returns provider

      expect(Facter.fact(:service_provider).value).to eq('redhat')
    end
  end
<<<<<<< HEAD

=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
