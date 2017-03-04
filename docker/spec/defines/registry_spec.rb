require 'spec_helper'

describe 'docker::registry', :type => :define do
  let(:title) { 'localhost:5000' }
<<<<<<< HEAD
<<<<<<< HEAD
  it { should contain_exec('auth against localhost:5000') }

  context 'with ensure => present' do
    let(:params) { { 'ensure' => 'absent' } }
    it { should contain_exec('auth against localhost:5000').with_command('docker logout localhost:5000') }
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
  it { should contain_exec('localhost:5000 auth') }

  context 'with ensure => present' do
    let(:params) { { 'ensure' => 'absent' } }
    it { should contain_exec('localhost:5000 auth').with_command('docker logout localhost:5000') }
<<<<<<< HEAD
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  end

  context 'with ensure => present' do
    let(:params) { { 'ensure' => 'present' } }
<<<<<<< HEAD
<<<<<<< HEAD
    it { should contain_exec('auth against localhost:5000').with_command('docker login localhost:5000') }
=======
    it { should contain_exec('localhost:5000 auth').with_command('docker login localhost:5000') }
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
    it { should contain_exec('localhost:5000 auth').with_command('docker login localhost:5000') }
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  end

  context 'with ensure => present and username => user1' do
    let(:params) { { 'ensure' => 'present', 'username' => 'user1' } }
<<<<<<< HEAD
<<<<<<< HEAD
    it { should contain_exec('auth against localhost:5000').with_command('docker login localhost:5000') }
=======
    it { should contain_exec('localhost:5000 auth').with_command('docker login localhost:5000') }
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
    it { should contain_exec('localhost:5000 auth').with_command('docker login localhost:5000') }
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  end

  context 'with ensure => present and password => secret' do
    let(:params) { { 'ensure' => 'present', 'password' => 'secret' } }
<<<<<<< HEAD
<<<<<<< HEAD
    it { should contain_exec('auth against localhost:5000').with_command('docker login localhost:5000') }
=======
    it { should contain_exec('localhost:5000 auth').with_command('docker login localhost:5000') }
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
    it { should contain_exec('localhost:5000 auth').with_command('docker login localhost:5000') }
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  end

  context 'with ensure => present and email => user1@example.io' do
    let(:params) { { 'ensure' => 'present', 'email' => 'user1@example.io' } }
<<<<<<< HEAD
<<<<<<< HEAD
    it { should contain_exec('auth against localhost:5000').with_command('docker login localhost:5000') }
=======
    it { should contain_exec('localhost:5000 auth').with_command('docker login localhost:5000') }
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
    it { should contain_exec('localhost:5000 auth').with_command('docker login localhost:5000') }
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  end

  context 'with ensure => present and username => user1, and password => secret and email => user1@example.io' do
    let(:params) { { 'ensure' => 'present', 'username' => 'user1', 'password' => 'secret', 'email' => 'user1@example.io' } }
<<<<<<< HEAD
<<<<<<< HEAD
    it { should contain_exec('auth against localhost:5000').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_environment('password=secret') }
=======
    it { should contain_exec('localhost:5000 auth').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_environment('password=secret') }
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
    it { should contain_exec('localhost:5000 auth').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_environment('password=secret') }
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  end

  context 'with username => user1, and password => secret and email => user1@example.io' do
    let(:params) { { 'username' => 'user1', 'password' => 'secret', 'email' => 'user1@example.io' } }
<<<<<<< HEAD
<<<<<<< HEAD
    it { should contain_exec('auth against localhost:5000').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_environment('password=secret') }
=======
    it { should contain_exec('localhost:5000 auth').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_environment('password=secret') }
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
    it { should contain_exec('localhost:5000 auth').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_environment('password=secret') }
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  end

  context 'with username => user1, and password => secret, and email => user1@example.io and local_user => testuser' do
    let(:params) { { 'username' => 'user1', 'password' => 'secret', 'email' => 'user1@example.io', 'local_user' => 'testuser' } }
<<<<<<< HEAD
<<<<<<< HEAD
    it { should contain_exec('auth against localhost:5000').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_user('testuser').with_environment('password=secret') }
=======
    it { should contain_exec('localhost:5000 auth').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_user('testuser').with_environment('password=secret') }
>>>>>>> c887bd06d1850eff2505a6dc00584284155634ad
=======
    it { should contain_exec('localhost:5000 auth').with_command("docker login -u 'user1' -p \"${password}\" -e 'user1@example.io' localhost:5000").with_user('testuser').with_environment('password=secret') }
>>>>>>> 5b05f9928392d20140da52f72c42e34ca7b3c890
  end

  context 'with an invalid ensure value' do
    let(:params) { { 'ensure' => 'not present or absent' } }
    it do
      expect {
        should contain_exec('docker logout localhost:5000')
      }.to raise_error(Puppet::Error)
    end
  end
end
