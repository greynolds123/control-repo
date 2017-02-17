require 'spec_helper'
describe 'apt::params', :type => :class do
<<<<<<< HEAD
  let(:facts) { { :lsbdistid => 'Debian', :osfamily => 'Debian', :lsbdistcodename => 'wheezy', :puppetversion => Puppet.version, } }
=======
  let(:facts) { { :lsbdistid => 'Debian', :osfamily => 'Debian', :lsbdistcodename => 'wheezy', :puppetversion   => Puppet.version, } }
  let (:title) { 'my_package' }

  it { is_expected.to contain_apt__params }
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1

  # There are 4 resources in this class currently
  # there should not be any more resources because it is a params class
  # The resources are class[apt::params], class[main], class[settings], stage[main]
  it "Should not contain any resources" do
    expect(subject.call.resources.size).to eq(4)
  end

  describe "With lsb-release not installed" do
<<<<<<< HEAD
    let(:facts) { { :osfamily => 'Debian', :puppetversion => Puppet.version, } }
=======
    let(:facts) { { :osfamily => 'Debian', :puppetversion   => Puppet.version, } }
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
    let (:title) { 'my_package' }

    it do
      expect {
        subject.call
      }.to raise_error(Puppet::Error, /Unable to determine lsbdistid, please install lsb-release first/)
    end
  end
end
