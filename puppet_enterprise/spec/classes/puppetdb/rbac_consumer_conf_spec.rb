require 'spec_helper'

describe 'puppet_enterprise::puppetdb::rbac_consumer_conf', :type => :class do
  before :all do
    @facter_facts = {
      'osfamily' => 'RedHat',
      'fqdn'     => 'test.domain.local',
    }
    @params = {
      'certname'    => 'test.domain.local',
      'localcacert' => '/path/to/cacert.pem',
      'confdir'     => '/path/to/conf.d',
      'rbac_url'    => 'https://rbac.local.domain:4433/rbac-url-prefix',
    }
  end
  context 'on a supported platform' do
    let(:facts) { @facter_facts }
    let(:params) { @params }

    let(:certname) do
      'test.domain.local'
    end

    it { should contain_class('puppet_enterprise::puppetdb::rbac_consumer_conf') }
    it { should contain_file('/path/to/conf.d/rbac_consumer.conf') }

    describe 'when using default values' do
      it { should contain_pe_hocon_setting('puppetdb_rbac_consumer_api_url').
                   with(
                     'ensure'  => 'present',
                     'path'    => '/path/to/conf.d/rbac_consumer.conf',
                     'setting' => 'rbac-consumer.api-url',
                     'value'   => 'https://rbac.local.domain:4433/rbac-url-prefix'
                   )}
      it { should contain_pe_hocon_setting('puppetdb_rbac_consumer_ssl_key').
                   with(
                     'ensure'  => 'present',
                     'path'    => '/path/to/conf.d/rbac_consumer.conf',
                     'setting' => 'global.certs.ssl-key',
                     'value'   => '/etc/puppetlabs/puppetdb/ssl/test.domain.local.private_key.pem'
                   )}
      it { should contain_pe_hocon_setting('puppetdb_rbac_consumer_ssl_cert').
                   with(
                     'ensure'  => 'present',
                     'path'    => '/path/to/conf.d/rbac_consumer.conf',
                     'setting' => 'global.certs.ssl-cert',
                     'value'   => '/etc/puppetlabs/puppetdb/ssl/test.domain.local.cert.pem'
                   )}
      it { should contain_pe_hocon_setting('puppetdb_rbac_consumer_ssl_ca_cert').
                   with(
                     'ensure'  => 'present',
                     'path'    => '/path/to/conf.d/rbac_consumer.conf',
                     'setting' => 'global.certs.ssl-ca-cert',
                     'value'   => '/path/to/cacert.pem'
                   )}
    end
  end
end
