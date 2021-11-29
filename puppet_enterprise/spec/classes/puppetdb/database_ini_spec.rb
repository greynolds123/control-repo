require 'spec_helper'

describe 'puppet_enterprise::puppetdb::database_ini', :type => :class do
  before :all do
    @params = {
      'database_port'           => 5432,
      'database_host'           => 'test.domain.local',
      'write_maximum_pool_size' => 25
    }
  end

  let(:params) { @params }

  context 'on a supported platform' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :fqdn     => 'test.domain.local',
      }
    end

    it { should contain_class('puppet_enterprise::puppetdb::database_ini') }
    it { should contain_file('/etc/puppetlabs/puppetdb/conf.d/database.ini') }

    describe 'when using default values' do
      it { should contain_pe_ini_setting('[database]-puppetdb_psdatabase_username').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
             'section' => 'database',
             'setting' => 'username',
             'value'   => 'pe-puppetdb'
      )}
      it { should_not contain_pe_ini_setting('[database]-puppetdb_psdatabase_password') }
      it { should contain_pe_ini_setting('[database]-puppetdb_subname').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
             'section' => 'database',
             'setting' => 'subname',
             'value'   => '//test.domain.local:5432/pe-puppetdb'
      )}
      it { should contain_pe_ini_setting('[database]-maximum-pool-size').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
             'section' => 'database',
             'setting' => 'maximum-pool-size',
             'value'   => 25
      )}
    end

    describe 'when setting write database connections' do
      before(:each) do
        @params['write_maximum_pool_size'] = 13
      end

      it { should contain_pe_ini_setting('[database]-maximum-pool-size').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
             'section' => 'database',
             'setting' => 'maximum-pool-size',
             'value'   => 13
      )}
    end

    describe 'when attempting to set the database_password to an empty string' do
      before :all do
        @params['database_password'] = ''
      end
      it { should_not compile }
    end

    describe 'when using a database password' do
      before :all do
        @params['database_password'] = 'pa$$w0rd'
      end

      it { should contain_pe_ini_setting('[database]-puppetdb_psdatabase_password').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
             'section' => 'database',
             'setting' => 'password',
             'value'   => 'pa$$w0rd'
      )}
    end
  end
end
