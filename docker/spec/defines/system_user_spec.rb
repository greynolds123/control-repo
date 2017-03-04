require 'spec_helper'

describe 'docker::system_user', :type => :define do
  let(:title) { 'testuser' }
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
	let(:facts) { {
		:osfamily                  => 'Debian',
		:operatingsystem           => 'Debian',
		:lsbdistid                 => 'Debian',
		:lsbdistcodename           => 'jessie',
		:kernelrelease             => '3.2.0-4-amd64',
		:operatingsystemmajrelease => '8',
	} }
<<<<<<< HEAD
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890

  context 'with default' do
    let(:params) { {'create_user' => true} }
    it { should contain_user('testuser') }
    it { should contain_exec('docker-system-user-testuser').with_command(/docker testuser/) }
    it { should contain_exec('docker-system-user-testuser').with_unless(/grep -qw testuser/) }
  end

  context 'with create_user => false' do
    let(:params) { {'create_user' => false} }
    it { should contain_exec('docker-system-user-testuser').with_command(/docker testuser/) }
  end

end
