<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'facter/facter_dot_d'

describe Facter::Util::DotD do

  context 'returns a simple fact' do
=======
require 'spec_helper'
require 'facter/facter_dot_d'

describe Facter::Util::DotD do # rubocop:disable RSpec/FilePath : Spec path is as it should be
  context 'with a simple fact' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    before :each do
      Facter.stubs(:version).returns('1.6.1')
      subject.stubs(:entries).returns(['/etc/facter/facts.d/fake_fact.txt'])
      File.stubs(:readlines).with('/etc/facter/facts.d/fake_fact.txt').returns(['fake_fact=fake fact'])
      subject.create
    end

<<<<<<< HEAD
    it 'should return successfully' do
=======
    it 'returns successfully' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      expect(Facter.fact(:fake_fact).value).to eq('fake fact')
    end
  end

<<<<<<< HEAD
  context 'returns a fact with equals signs' do
=======
  context 'with a fact with equals signs' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    before :each do
      Facter.stubs(:version).returns('1.6.1')
      subject.stubs(:entries).returns(['/etc/facter/facts.d/foo.txt'])
      File.stubs(:readlines).with('/etc/facter/facts.d/foo.txt').returns(['foo=1+1=2'])
      subject.create
    end

<<<<<<< HEAD
    it 'should return successfully' do
=======
    it 'returns successfully' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      expect(Facter.fact(:foo).value).to eq('1+1=2')
    end
  end
end
