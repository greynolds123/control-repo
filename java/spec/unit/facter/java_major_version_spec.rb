<<<<<<< HEAD
require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe "java_major_version" do
    context 'returns major version when java_version fact present' do
      before :each do
        Facter.fact(:java_version).stubs(:value).returns('1.7.0_71')
      end
      it do
        expect(Facter.fact(:java_major_version).value).to eq("7")
      end
    end

    context 'returns nil when java not present' do
      before :each do
        Facter.fact(:java_version).stubs(:value).returns(nil)
      end
      it do
        expect(Facter.fact(:java_major_version).value).to be_nil
      end
=======
require 'spec_helper'

describe 'java_major_version' do
  before(:each) do
    Facter.clear
  end

  context 'when java_version fact present, returns major version' do
    before :each do
      allow(Facter.fact(:java_version)).to receive(:value).and_return('1.7.0_71')
    end
    it do
      expect(Facter.fact(:java_major_version).value).to eq('7')
    end
  end

  context 'when java not present, returns nil' do
    before :each do
      allow(Facter.fact(:java_version)).to receive(:value).and_return('nil')
    end
    it do
      expect(Facter.fact(:java_major_version).value).to be_nil
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    end
  end
end
