require 'spec_helper'

describe 'puppet_enterprise::puppetdb::sync_ini' do
  require 'puppet/resource/catalog'
  require 'puppet/indirector/memory'
  class ::Puppet::Resource::Catalog::StoreConfigsTesting < Puppet::Indirector::Memory; end

  before :all do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'master.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
      'servername'        => 'master.rspec',
      'pe_server_version' => '2015.3.0',
    }
    @params = {
      'peers' => [{'host' => 'remote1',
                   'port' => 1234,
                   'sync_interval_minutes' => 2},
                  {'host' => 'remote2',
                   'port' => 5678,
                   'sync_interval_minutes' => 42}]
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }

  it { should contain_class('puppet_enterprise::puppetdb::sync_ini') }
  it { should contain_file('/etc/puppetlabs/puppetdb/conf.d/sync.ini') }

  it { should contain_pe_ini_setting('puppetdb_sync_server_urls').
               with('ensure' => 'present',
                    'path' => '/etc/puppetlabs/puppetdb/conf.d/sync.ini',
                    'section' => 'sync',
                    'value' => 'https://remote1:1234,https://remote2:5678',
                    'setting' => 'server_urls')}

  it { should contain_pe_ini_setting('puppetdb_sync_intervals').
               with('ensure'  => 'present',
                    'path'    => '/etc/puppetlabs/puppetdb/conf.d/sync.ini',
                    'section' => 'sync',
                    'setting' => 'intervals',
                    'value'   => '2m,42m')}
end
