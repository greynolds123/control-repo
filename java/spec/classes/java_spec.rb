require 'spec_helper'

describe 'java', :type => :class do

  context 'select openjdk for Centos 5.8' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Centos', :operatingsystemrelease => '5.8'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.6.0-openjdk-devel') }
=======
    it { should contain_package('java').with_name('java-1.6.0-openjdk-devel') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select openjdk for Centos 6.3' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Centos', :operatingsystemrelease => '6.3'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk-devel') }
=======
    it { should contain_package('java').with_name('java-1.7.0-openjdk-devel') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select openjdk for Centos 7.1.1503' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Centos', :operatingsystemrelease => '7.1.1503'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.8.0-openjdk-devel') }
=======
    it { should contain_package('java').with_name('java-1.8.0-openjdk-devel') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select openjdk for Centos 6.2' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Centos', :operatingsystemrelease => '6.2'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.6.0-openjdk-devel') }
    it { is_expected.to_not contain_exec('update-java-alternatives') }
=======
    it { should contain_package('java').with_name('java-1.6.0-openjdk-devel') }
    it { should_not contain_exec('update-java-alternatives') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select Oracle JRE with alternatives for Centos 6.3' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Centos', :operatingsystemrelease => '6.3'} }
    let(:params) { { 'package' => 'jre', 'java_alternative' => '/usr/bin/java', 'java_alternative_path' => '/usr/java/jre1.7.0_67/bin/java'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('jre') }
    it { is_expected.to contain_exec('create-java-alternatives').with_command('alternatives --install /usr/bin/java java /usr/java/jre1.7.0_67/bin/java 20000') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('alternatives --set java /usr/java/jre1.7.0_67/bin/java') }
=======
    it { should contain_package('java').with_name('jre') }
    it { should contain_exec('create-java-alternatives').with_command('alternatives --install /usr/bin/java java /usr/java/jre1.7.0_67/bin/java 20000') }
    it { should contain_exec('update-java-alternatives').with_command('alternatives --set java /usr/java/jre1.7.0_67/bin/java') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select openjdk for Fedora 20' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Fedora', :operatingsystemrelease => '20'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk-devel') }
=======
    it { should contain_package('java').with_name('java-1.7.0-openjdk-devel') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select openjdk for Fedora 21' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Fedora', :operatingsystemrelease => '21'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.8.0-openjdk-devel') }
=======
    it { should contain_package('java').with_name('java-1.8.0-openjdk-devel') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select passed value for Fedora 20' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Fedora', :operatingsystemrelease => '20'} }
    let(:params) { { 'distribution' => 'jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk') }
=======
    it { should contain_package('java').with_name('java-1.7.0-openjdk') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select passed value for Fedora 21' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Fedora', :operatingsystemrelease => '21'} }
    let(:params) { { 'distribution' => 'jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.8.0-openjdk') }
=======
    it { should contain_package('java').with_name('java-1.8.0-openjdk') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end
  
  context 'select passed value for Fedora 21 with yum option' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Fedora', :operatingsystemrelease => '21'} }
    let(:params) { { 'distribution' => 'jre' } }
    let(:params) { { 'package_options'  => ['--skip-broken'] } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java') }
=======
    it { should contain_package('java') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select passed value for Centos 5.3' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Centos', :operatingsystemrelease => '5.3'} }
    let(:params) { { 'package' => 'jdk' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('jdk') }
    it { is_expected.to_not contain_exec('update-java-alternatives') }
=======
    it { should contain_package('java').with_name('jdk') }
    it { should_not contain_exec('update-java-alternatives') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select default for Centos 5.3' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Centos', :operatingsystemrelease => '5.3'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.6.0-openjdk-devel') }
    it { is_expected.to_not contain_exec('update-java-alternatives') }
=======
    it { should contain_package('java').with_name('java-1.6.0-openjdk-devel') }
    it { should_not contain_exec('update-java-alternatives') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select default for Debian Wheezy' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistcodename => 'wheezy', :operatingsystemrelease => '7.1', :architecture => 'amd64',} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('openjdk-7-jdk') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-1.7.0-openjdk-amd64 --jre') }
=======
    it { should contain_package('java').with_name('openjdk-7-jdk') }
    it { should contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-1.7.0-openjdk-amd64 --jre') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select Oracle JRE for Debian Wheezy' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistcodename => 'wheezy', :operatingsystemrelease => '7.1', :architecture => 'amd64',} }
    let(:params) { { 'distribution' => 'oracle-jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('oracle-j2re1.7') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set j2re1.7-oracle --jre') }
=======
    it { should contain_package('java').with_name('oracle-j2re1.7') }
    it { should contain_exec('update-java-alternatives').with_command('update-java-alternatives --set j2re1.7-oracle --jre') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select OpenJDK JRE for Debian Wheezy' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistcodename => 'wheezy', :operatingsystemrelease => '7.1', :architecture => 'amd64',} }
    let(:params) { { 'distribution' => 'jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('openjdk-7-jre-headless') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-1.7.0-openjdk-amd64 --jre-headless') }
=======
    it { should contain_package('java').with_name('openjdk-7-jre-headless') }
    it { should contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-1.7.0-openjdk-amd64 --jre-headless') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select default for Debian Squeeze' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistcodename => 'squeeze', :operatingsystemrelease => '6.0.5', :architecture => 'amd64',} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('openjdk-6-jdk') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-openjdk-amd64 --jre') }
=======
    it { should contain_package('java').with_name('openjdk-6-jdk') }
    it { should contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-openjdk-amd64 --jre') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select Oracle JRE for Debian Squeeze' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistcodename => 'squeeze', :operatingsystemrelease => '6.0.5', :architecture => 'amd64',} }
    let(:params) { { 'distribution' => 'sun-jre', } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('sun-java6-jre') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-sun --jre') }
=======
    it { should contain_package('java').with_name('sun-java6-jre') }
    it { should contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-sun --jre') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select OpenJDK JRE for Debian Squeeze' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistcodename => 'squeeze', :operatingsystemrelease => '6.0.5', :architecture => 'amd64',} }
    let(:params) { { 'distribution' => 'jre', } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('openjdk-6-jre-headless') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-openjdk-amd64 --jre-headless') }
=======
    it { should contain_package('java').with_name('openjdk-6-jre-headless') }
    it { should contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-openjdk-amd64 --jre-headless') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select random alternative for Debian Wheezy' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistcodename => 'wheezy', :operatingsystemrelease => '7.1', :architecture => 'amd64',} }
    let(:params) { { 'java_alternative' => 'bananafish' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('openjdk-7-jdk') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set bananafish --jre') }
=======
    it { should contain_package('java').with_name('openjdk-7-jdk') }
    it { should contain_exec('update-java-alternatives').with_command('update-java-alternatives --set bananafish --jre') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select jdk for Ubuntu Vivid (15.04)' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbdistcodename => 'vivid', :operatingsystemrelease => '15.04', :architecture => 'amd64',} }
    let(:params) { { 'distribution' => 'jdk' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('openjdk-8-jdk') }
=======
    it { should contain_package('java').with_name('openjdk-8-jdk') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select jre for Ubuntu Vivid (15.04)' do
    let(:facts) { {:osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbdistcodename => 'vivid', :operatingsystemrelease => '15.04', :architecture => 'amd64',} }
    let(:params) { { 'distribution' => 'jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('openjdk-8-jre-headless') }
=======
    it { should contain_package('java').with_name('openjdk-8-jre-headless') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select openjdk for Amazon Linux' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Amazon', :operatingsystemrelease => '3.4.43-43.43.amzn1.x86_64'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk-devel') }
=======
    it { should contain_package('java').with_name('java-1.7.0-openjdk-devel') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select passed value for Amazon Linux' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Amazon', :operatingsystemrelease => '5.3.4.43-43.43.amzn1.x86_64'} }
    let(:params) { { 'distribution' => 'jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk') }
=======
    it { should contain_package('java').with_name('java-1.7.0-openjdk') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select openjdk for Oracle Linux' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'OracleLinux', :operatingsystemrelease => '6.4'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk-devel') }
=======
    it { should contain_package('java').with_name('java-1.7.0-openjdk-devel') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select openjdk for Oracle Linux 6.2' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'OracleLinux', :operatingsystemrelease => '6.2'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.6.0-openjdk-devel') }
=======
    it { should contain_package('java').with_name('java-1.6.0-openjdk-devel') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select passed value for Oracle Linux' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'OracleLinux', :operatingsystemrelease => '6.3'} }
    let(:params) { { 'distribution' => 'jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk') }
=======
    it { should contain_package('java').with_name('java-1.7.0-openjdk') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select passed value for Scientific Linux' do
    let(:facts) { {:osfamily => 'RedHat', :operatingsystem => 'Scientific', :operatingsystemrelease => '6.4'} }
    let(:params) { { 'distribution' => 'jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk') }
=======
    it { should contain_package('java').with_name('java-1.7.0-openjdk') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select default for OpenSUSE 12.3' do
    let(:facts) { {:osfamily => 'Suse', :operatingsystem => 'OpenSUSE', :operatingsystemrelease => '12.3'}}
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('java-1_7_0-openjdk-devel')}
  end

  context 'select default for SLES 11.3' do
    let(:facts) { {:osfamily => 'Suse', :operatingsystem => 'SLES', :operatingsystemrelease => '11.3'}}
    it { should contain_package('java').with_name('java-1_6_0-ibm-devel')}
  end

  context 'select default for SLES 11.4' do
    let(:facts) { {:osfamily => 'Suse', :operatingsystem => 'SLES', :operatingsystemrelease => '11.4'}}
    it { should contain_package('java').with_name('java-1_7_0-ibm-devel')}
  end

  context 'select default for SLES 12.1' do
    let(:facts) { {:osfamily => 'Suse', :operatingsystem => 'SLES', :operatingsystemrelease => '12.1', :operatingsystemmajrelease => '12'}}
=======
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    it { should contain_package('java').with_name('java-1_7_0-openjdk-devel')}
  end

  context 'select jdk for OpenBSD' do
    let(:facts) { {:osfamily => 'OpenBSD'} }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('jdk') }
=======
    it { should contain_package('java').with_name('jdk') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'select jre for OpenBSD' do
    let(:facts) { {:osfamily => 'OpenBSD'} }
    let(:params) { { 'distribution' => 'jre' } }
<<<<<<< HEAD
    it { is_expected.to contain_package('java').with_name('jre') }
=======
    it { should contain_package('java').with_name('jre') }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  describe 'incompatible OSs' do
    [
      {
        # C14706
        :osfamily               => 'windows',
        :operatingsystem        => 'windows',
        :operatingsystemrelease => '8.1',
      },
      {
        # C14707
        :osfamily               => 'Darwin',
        :operatingsystem        => 'Darwin',
        :operatingsystemrelease => '13.3.0',
      },
      {
        # C14708
        :osfamily               => 'AIX',
        :operatingsystem        => 'AIX',
        :operatingsystemrelease => '7100-02-00-000',
      },
      {
        # C14708
        :osfamily               => 'AIX',
        :operatingsystem        => 'AIX',
        :operatingsystemrelease => '6100-07-04-1216',
      },
      {
        # C14708
        :osfamily               => 'AIX',
        :operatingsystem        => 'AIX',
        :operatingsystemrelease => '5300-12-01-1016',
      },
    ].each do |facts|
      let(:facts) { facts }
<<<<<<< HEAD
      it "is_expected.to fail on #{facts[:operatingsystem]} #{facts[:operatingsystemrelease]}" do
=======
      it "should fail on #{facts[:operatingsystem]} #{facts[:operatingsystemrelease]}" do
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        expect { catalogue }.to raise_error Puppet::Error, /unsupported platform/
      end
    end
  end
end
