require 'spec_helper'

describe 'apt_package_updates fact' do
  subject { Facter.fact(:apt_package_updates).value }
  after(:each) { Facter.clear }

  describe 'when apt has no updates' do
    before { 
      Facter.fact(:apt_has_updates).stubs(:value).returns false
    }
    it { is_expected.to be nil }
  end

  describe 'when apt has updates' do
    before { 
      Facter.fact(:osfamily).stubs(:value).returns 'Debian'
      File.stubs(:executable?) # Stub all other calls
      Facter::Util::Resolution.stubs(:exec) # Catch all other calls
<<<<<<< HEAD
      File.expects(:executable?).with('/usr/bin/apt-get').returns true
      Facter::Util::Resolution.expects(:exec).with('/usr/bin/apt-get -s upgrade 2>&1').returns ""+
        "Inst tzdata [2015f-0+deb8u1] (2015g-0+deb8u1 Debian:stable-updates [all])\n"+
        "Conf tzdata (2015g-0+deb8u1 Debian:stable-updates [all])\n"+
        "Inst unhide.rb [13-1.1] (22-2~bpo8+1 Debian Backports:jessie-backports [all])\n"+
        "Conf unhide.rb (22-2~bpo8+1 Debian Backports:jessie-backports [all])\n"
    }
    it {
      if Facter.version < '2.0.0'
        is_expected.to eq('tzdata,unhide.rb')
      else
        is_expected.to eq(['tzdata','unhide.rb'])
=======
      File.expects(:executable?).with('/usr/lib/update-notifier/apt-check').returns true
      Facter::Util::Resolution.expects(:exec).with('/usr/lib/update-notifier/apt-check 2>&1').returns "1;2"
      Facter::Util::Resolution.expects(:exec).with('/usr/lib/update-notifier/apt-check -p 2>&1').returns "puppet-common\nlinux-generic\nlinux-image-generic"
    }
    it {
      if Facter.version < '2.0.0'
        is_expected.to eq('puppet-common,linux-generic,linux-image-generic')
      else
        is_expected.to eq(['puppet-common', 'linux-generic', 'linux-image-generic'])
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
      end
    }
  end
end
