require 'spec_helper'

describe 'apt_has_updates fact' do
  subject { Facter.fact(:apt_has_updates).value }
  after(:each) { Facter.clear }

  describe 'on non-Debian distro' do
    before {
      Facter.fact(:osfamily).expects(:value).at_least(1).returns 'RedHat'
    }
    it { is_expected.to be_nil }
  end

<<<<<<< HEAD
  describe 'on Debian based distro missing apt-get' do
    before {
      Facter.fact(:osfamily).expects(:value).at_least(1).returns 'Debian'
      File.stubs(:executable?) # Stub all other calls
      File.expects(:executable?).with('/usr/bin/apt-get').returns false
=======
  describe 'on Debian based distro missing update-notifier-common' do
    before {
      Facter.fact(:osfamily).expects(:value).at_least(1).returns 'Debian'
      File.stubs(:executable?) # Stub all other calls
      File.expects(:executable?).with('/usr/lib/update-notifier/apt-check').returns false
    }
    it { is_expected.to be_nil }
  end

  describe 'on Debian based distro with broken packages' do
    before {
      Facter.fact(:osfamily).expects(:value).at_least(1).returns 'Debian'
      File.stubs(:executable?) # Stub all other calls
      Facter::Util::Resolution.stubs(:exec) # Catch all other calls
      File.expects(:executable?).with('/usr/lib/update-notifier/apt-check').returns true
      Facter::Util::Resolution.expects(:exec).with('/usr/lib/update-notifier/apt-check 2>&1').returns "E: Error: BrokenCount > 0"
    }
    it { is_expected.to be_nil }
  end

  describe 'on Debian based distro with unknown error with semicolons' do
    before {
      Facter.fact(:osfamily).expects(:value).at_least(1).returns 'Debian'
      File.stubs(:executable?) # Stub all other calls
      Facter::Util::Resolution.stubs(:exec) # Catch all other calls
      File.expects(:executable?).with('/usr/lib/update-notifier/apt-check').returns true
      Facter::Util::Resolution.expects(:exec).with('/usr/lib/update-notifier/apt-check 2>&1').returns "E: Unknown Error: 'This error contains something that could be parsed like 4;3' (10)"
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
    }
    it { is_expected.to be_nil }
  end

  describe 'on Debian based distro' do
    before {
      Facter.fact(:osfamily).expects(:value).at_least(1).returns 'Debian'
      File.stubs(:executable?) # Stub all other calls
      Facter::Util::Resolution.stubs(:exec) # Catch all other calls
<<<<<<< HEAD
      File.expects(:executable?).with('/usr/bin/apt-get').returns true
      Facter::Util::Resolution.expects(:exec).with('/usr/bin/apt-get -s upgrade 2>&1').returns ""+
        "Inst tzdata [2015f-0+deb8u1] (2015g-0+deb8u1 Debian:stable-updates [all])\n"+
        "Conf tzdata (2015g-0+deb8u1 Debian:stable-updates [all])\n"+
        "Inst unhide.rb [13-1.1] (22-2~bpo8+1 Debian Backports:jessie-backports [all])\n"+
        "Conf unhide.rb (22-2~bpo8+1 Debian Backports:jessie-backports [all])\n"
=======
      File.expects(:executable?).with('/usr/lib/update-notifier/apt-check').returns true
      Facter::Util::Resolution.expects(:exec).with('/usr/lib/update-notifier/apt-check 2>&1').returns "4;3"
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
    }
    it { is_expected.to be true }
  end
end

