require "spec_helper"

describe Facter::Util::Fact do
  before {
    Facter.clear
    Facter.fact(:kernel).stubs(:value).returns('Linux')
  }

  describe "java_default_home" do
    context 'returns java home path when readlink present' do
      it do
        java_path_output = <<-EOS
/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
        EOS
        Facter::Util::Resolution.expects(:which).with("readlink").returns(true)
        Facter::Util::Resolution.expects(:exec).with("readlink -e /usr/bin/java").returns(java_path_output)
<<<<<<< HEAD
        expect(Facter.value(:java_default_home)).to eql "/usr/lib/jvm/java-7-openjdk-amd64"
=======
        Facter.value(:java_default_home).should == "/usr/lib/jvm/java-7-openjdk-amd64"
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      end
    end

    context 'returns nil when readlink not present' do
      it do
        Facter::Util::Resolution.stubs(:exec)
        Facter::Util::Resolution.expects(:which).with("readlink").at_least(1).returns(false)
<<<<<<< HEAD
        expect(Facter.value(:java_default_home)).to be_nil
=======
        Facter.value(:java_default_home).should be_nil
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      end
    end
  end
end
