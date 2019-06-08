<<<<<<< HEAD
require "spec_helper"

describe Facter::Util::Fact do
  before {
=======
require 'spec_helper'

describe 'java_libjvm_path' do
  before(:each) do
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns('Linux')
    java_default_home = '/usr/lib/jvm/java-8-openjdk-amd64'
    Facter.fact(:java_default_home).stubs(:value).returns(java_default_home)
<<<<<<< HEAD
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
    Dir.stubs(:glob).with("#{java_default_home}/jre/lib/**/libjvm.so").returns(['/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so'])
  end

  context 'when on Linux, return libjvm path' do
    it do
      expect(Facter.value(:java_libjvm_path)).to eql '/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server'
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    end
  end
end
