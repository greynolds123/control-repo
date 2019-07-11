<<<<<<< HEAD
require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns('Linux')
    java_default_home = '/usr/lib/jvm/java-8-openjdk-amd64'
    Facter.fact(:java_default_home).stubs(:value).returns(java_default_home)
    Dir.stubs(:glob).with("#{java_default_home}/jre/lib/**/libjvm.so").returns( ['/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so'])
  }

  describe "java_libjvm_path" do
    context 'returns libjvm path' do
      context 'on Linux' do
        it do
          expect(Facter.value(:java_libjvm_path)).to eql "/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server"
        end
      end
=======
require 'spec_helper'

describe 'java_libjvm_path' do
  let(:java_default_home) { '/usr/lib/jvm/java-8-openjdk-amd64' }

  before(:each) do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).once.and_return('Linux')
    allow(Facter.fact(:java_default_home)).to receive(:value).once.and_return(java_default_home)
  end

  context 'when libjvm exists' do
    it do
      allow(Dir).to receive(:glob).with("#{java_default_home}/jre/lib/**/libjvm.so").and_return(['/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so'])
      expect(Facter.value(:java_libjvm_path)).to eql '/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server'
    end
  end

  context 'when libjvm does not exist' do
    it do
      allow(Dir).to receive(:glob).with("#{java_default_home}/jre/lib/**/libjvm.so").and_return([])
      expect(Facter.value(:java_libjvm_path)).to be nil
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    end
  end
end
