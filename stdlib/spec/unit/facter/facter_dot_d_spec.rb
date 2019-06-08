require 'spec_helper'
require 'facter/facter_dot_d'

describe Facter::Util::DotD do # rubocop:disable RSpec/FilePath : Spec path is as it should be
  context 'with a simple fact' do
    before :each do
<<<<<<< HEAD
      Facter.stubs(:version).returns('1.6.1')
      subject.stubs(:entries).returns(['/etc/facter/facts.d/fake_fact.txt'])
      File.stubs(:readlines).with('/etc/facter/facts.d/fake_fact.txt').returns(['fake_fact=fake fact'])
=======
      allow(Facter).to receive(:version).and_return('1.6.1')
      allow(subject).to receive(:entries).and_return(['/etc/facter/facts.d/fake_fact.txt'])
      allow(File).to receive(:readlines).with('/etc/facter/facts.d/fake_fact.txt').and_return(['fake_fact=fake fact'])
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      subject.create
    end

    it 'returns successfully' do
      expect(Facter.fact(:fake_fact).value).to eq('fake fact')
    end
  end

  context 'with a fact with equals signs' do
    before :each do
<<<<<<< HEAD
      Facter.stubs(:version).returns('1.6.1')
      subject.stubs(:entries).returns(['/etc/facter/facts.d/foo.txt'])
      File.stubs(:readlines).with('/etc/facter/facts.d/foo.txt').returns(['foo=1+1=2'])
=======
      allow(Facter).to receive(:version).and_return('1.6.1')
      allow(subject).to receive(:entries).and_return(['/etc/facter/facts.d/foo.txt'])
      allow(File).to receive(:readlines).with('/etc/facter/facts.d/foo.txt').and_return(['foo=1+1=2'])
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
      subject.create
    end

    it 'returns successfully' do
      expect(Facter.fact(:foo).value).to eq('1+1=2')
    end
  end
end
