spec file

require 'spec_helper'
<<<<<<< HEAD
require 'rspec'


describe('tool::config') do}
=======

describe('tool::config') do
  let(:facts) {
    {
      :operatingsystem => '/['CentOS'|Rhel|/',
      :osfamily        => 'RedHat'
    }
  }
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd

 context 'with defaults for all parameters' do
    let (:config) {{}}
    set_encoding: utf-8
    it do
      expect {
       should copy
       }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

<<<<<<< HEAD
 context 'with default parameters from config' do
   let (:params)  {{ :class => 'tool::config' }}
  it { should contain_file('/root/remoteIPtables.sh').with(
=======
 context 'with default parameters from init' do
  let (:config) {
  it { should contain_class('tool::config') }
  it { should contain_file('/root/clearCache.sh').with(
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
   {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
<<<<<<< HEAD
     'content' => 'puppet:///modules/tool/remoteIPtables.sh'),
   }
  end

   it { should contain_file('/root/network.txt').with(
=======
     'content' => 'puppet:///modules/tool/clearCache.sh',
   }
  end
end

  it { should contain_file('/root/manageSelinux.sh').with(
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
   {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
<<<<<<< HEAD
     'content' => 'puppet:///modules/tool/network.txt'),
   }
  end

   it { should contain_file('/root/manageSelinux.sh').with(
=======
     'content' => 'puppet:///modules/tool/manageSelinux.sh',
   }
  end

  it { should contain_file('/root/remoteIPtables.sh').with(
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
   {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
<<<<<<< HEAD
     'content' => 'puppet:///modules/tool/manageSelinux.sh'),
   }
  end

   it { should contain_file( '/root/ipscan.sh).with(
   { 
    'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
     'content' => 'puppet:///modules/tool/ipscan.sh'),
   }
  end

   it { should contain_file('/root/clearCache.sh').with(
    {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
     'content' => 'puppet:///modules/tool/clearCache.sh'),
    }
  end
end

    it { should contain_file('/root/TuneDatabase.sh').with(
    {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
     'content' => 'puppet:///modules/tool/TuneDatabase.sh'),
    }
  end
end

    it { should contain_file('/root/Server_List').with(
    {
     'ensure'  => 'present',
     'owner'   => 'root',
     'mode'    => '655',
     'seltype' => 'admin_home_t',
     'content' => 'puppet:///modules/tool/Server_List'),
    }
  end
end

   
=======
     'content' => 'puppet:///modules/tool/remoteIPtables.sh',
   }
  end

>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
