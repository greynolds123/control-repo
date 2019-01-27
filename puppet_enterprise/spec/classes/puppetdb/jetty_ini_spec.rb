require 'spec_helper'

describe 'puppet_enterprise::puppetdb::jetty_ini', :type => :class do
  before :all do
    @facter_facts = {
      'osfamily'          => 'RedHat',
      'fqdn'              => 'test.domain.local',
    }
    @params = {
      'certname'          => 'test.domain.local',
      'cert_whitelist_path' => '/etc/puppetlabs/puppetdb/certificate-whitelist',
    }
  end
  context 'on a supported platform' do
    let(:facts) { @facter_facts }
    let(:params) { @params }

    let(:certname) do
      'test.domain.local'
    end

    it { should contain_class('puppet_enterprise::puppetdb::jetty_ini') }
    it { should contain_file('/etc/puppetlabs/puppetdb/conf.d/jetty.ini') }

    describe 'when using default values' do
      it { should contain_pe_ini_setting('puppetdb_host').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'host',
             'value'   => '127.0.0.1'
      )}
      it { should contain_pe_ini_setting('puppetdb_port').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'port',
             'value'   => 8080
      )}
      it { should contain_pe_ini_setting('puppetdb_sslhost').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'ssl-host',
             'value'   => '0.0.0.0'
      )}
      it { should contain_pe_ini_setting('puppetdb_ssl_key').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'ssl-key',
             'value'   => "/etc/puppetlabs/puppetdb/ssl/#{certname}.private_key.pem",
      )}
      it { should contain_pe_ini_setting('puppetdb_ssl_cert').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'ssl-cert',
             'value'   => "/etc/puppetlabs/puppetdb/ssl/#{certname}.cert.pem",
      )}
      it { should contain_pe_ini_setting('puppetdb_ssl_ca_cert').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'ssl-ca-cert',
             'value'   => "/etc/puppetlabs/puppet/ssl/certs/ca.pem",
      )}
      it { should contain_pe_ini_setting('puppetdb-certificate-whitelist').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'puppetdb',
             'setting' => 'certificate-whitelist',
             'value'   => '/etc/puppetlabs/puppetdb/certificate-whitelist'
      )}
      it { should contain_pe_ini_setting('puppetdb_client_auth').
            with(
              'ensure'  => 'present',
              'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
              'section' => 'jetty',
              'setting' => 'client-auth',
              'value'   => 'want',
      )}
      it { should_not contain_pe_ini_setting('puppetdb_max-threads').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'max-threads',
             'value'   => :undef,
      )}
    end
    describe 'when specifying jetty max-threads value' do
      before :each do
        @params['tk_jetty_max_threads'] = 100
      end
      it { should contain_pe_ini_setting('puppetdb_max-threads').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'max-threads',
             'value'   => '100',
      )}
    end
    describe 'when disabling plaintext connector' do
      before :each do
        @params['listen_port'] = ''
      end

      it { should contain_pe_ini_setting('puppetdb_host').
           with(
             'ensure'  => 'absent',
             'section' => 'jetty',
             'setting' => 'host',
      )}
      it { should contain_pe_ini_setting('puppetdb_port').
           with(
             'ensure'  => 'absent',
             'section' => 'jetty',
             'setting' => 'port',
      )}
    end
    describe 'when specifying jetty request-header-max-size value' do
      it { should contain_pe_ini_setting('puppetdb_request_header_max_size').
           with(
             'ensure'  => 'present',
             'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
             'section' => 'jetty',
             'setting' => 'request-header-max-size',
             'value'   => '55',
      )}
    end
  end
end
