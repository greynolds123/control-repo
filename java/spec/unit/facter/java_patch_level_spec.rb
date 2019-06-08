<<<<<<< HEAD
require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
  }

  describe "java_patch_level" do
    context "if java is installed" do
      context 'returns java patch version extracted from java_version fact' do
        before :each do
          Facter.fact(:java_version).stubs(:value).returns('1.7.0_71')
        end
        it do
          expect(Facter.fact(:java_patch_level).value).to eq("71")
        end
      end
    end

    context "if java is not installed" do
      context 'returns nil' do
        before :each do
          Facter.fact(:java_version).stubs(:value).returns(nil)
        end
        it do
          expect(Facter.fact(:java_patch_level).value).to be_nil
        end
      end
=======
require 'spec_helper'

describe 'java_patch_level' do
  before(:each) do
    Facter.clear
  end

  context 'when java is installed returns java patch version extracted from java_version fact' do
    before :each do
      Facter.fact(:java_version).stubs(:value).returns('1.7.0_71')
    end
    it do
      expect(Facter.fact(:java_patch_level).value).to eq('71')
    end
  end

  context 'when java is not installed returns nil' do
    before :each do
      Facter.fact(:java_version).stubs(:value).returns(nil)
    end
    it do
      expect(Facter.fact(:java_patch_level).value).to be_nil
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    end
  end
end
