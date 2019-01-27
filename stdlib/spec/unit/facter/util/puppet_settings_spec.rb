<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
require 'spec_helper'
require 'facter/util/puppet_settings'

describe Facter::Util::PuppetSettings do
<<<<<<< HEAD

  describe "#with_puppet" do
    context "Without Puppet loaded" do
      before(:each) do
        Module.expects(:const_get).with("Puppet").raises(NameError)
      end

      it 'should be nil' do
        expect(subject.with_puppet { Puppet[:vardir] }).to be_nil
      end
      it 'should not yield to the block' do
=======
  describe '#with_puppet' do
    context 'without Puppet loaded' do
      before(:each) do
        Module.expects(:const_get).with('Puppet').raises(NameError)
      end

      it 'is nil' do
        expect(subject.with_puppet { Puppet[:vardir] }).to be_nil
      end
      it 'does not yield to the block' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        Puppet.expects(:[]).never
        expect(subject.with_puppet { Puppet[:vardir] }).to be_nil
      end
    end
<<<<<<< HEAD
    context "With Puppet loaded" do
      module Puppet; end
      let(:vardir) { "/var/lib/puppet" }
=======
    context 'with Puppet loaded' do
      module Puppet; end
      let(:vardir) { '/var/lib/puppet' }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

      before :each do
        Puppet.expects(:[]).with(:vardir).returns vardir
      end

<<<<<<< HEAD
      it 'should yield to the block' do
        subject.with_puppet { Puppet[:vardir] }
      end
      it 'should return the nodes vardir' do
=======
      it 'yields to the block' do
        subject.with_puppet { Puppet[:vardir] }
      end
      it 'returns the nodes vardir' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        expect(subject.with_puppet { Puppet[:vardir] }).to eq vardir
      end
    end
  end
end
