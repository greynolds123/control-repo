require 'spec_helper'

describe 'puppet_enterprise::master::file_sync' do
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
        'certname'                                  => 'master.rspec',
        'puppet_master_host'                        => 'master.rspec',
        'master_of_masters_certname'                => 'master.rspec',
        'puppetserver_jruby_puppet_master_code_dir' => '/etc/puppetlabs/code',
        'puppetserver_webserver_ssl_port'           => '8140',
        'localcacert'                               => 'master.rspec',
        'compile_master'                            => false,
    }
  end

  let(:facts)   { @facter_facts }
  let(:params)  { @params }
  let(:confdir) { "/etc/puppetlabs/puppetserver" }
  let(:authconf) { "#{confdir}/conf.d/auth.conf" }

  context "managing files" do
    it { should contain_file("#{confdir}/conf.d/file-sync.conf").with_mode('0640') }
  end

  context "managing file permissions for file sync" do
    it { should contain_file('/etc/puppetlabs/code').with_mode('0740') }
  end

  context "managing the poll interval" do
    before :each do
      @params['file_sync_poll_interval'] = '4'
    end

    it { should contain_pe_hocon_setting('file-sync.client.poll-interval').with_value('4') }
  end

  context "managing the forceful sync" do
    before :each do
      @params['file_sync_enable_forceful_sync'] = false
    end

    it { should contain_pe_hocon_setting('file-sync.client.enable-forceful-sync').with_value(false) }
  end

  context "managing preserve-deleted-submodules" do
    before :each do
      @params['file_sync_preserve_deleted_submodules'] = true
    end

    it { should contain_pe_hocon_setting('file-sync.preserve-deleted-submodules').with_value(true) }
  end

  context "configuring file sync" do
    context "it should configure the storage service on the MoM" do
      it { should contain_puppet_enterprise__trapperkeeper__bootstrap_cfg('filesystem-watch-service').with_namespace('puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service') }
      it { should contain_pe_hocon_setting('web-router-service/file-sync-web-service').with_value('/file-sync') }
      it { should contain_pe_hocon_setting('web-router-service/file-sync-storage-service/repo-servlet').with_value('/file-sync-git') }
      it { should contain_pe_hocon_setting('file-sync.repos.puppet-code.staging-dir').with_value('/etc/puppetlabs/code-staging') }
      it { should contain_file('/etc/puppetlabs/code-staging').with_mode('0640') }
    end

    context "it should set submodules-dir only on the MoM when provided" do
      before :each do
        @params['file_sync_submodules_dir'] = 'thisdir'
      end

      it { should contain_pe_hocon_setting('file-sync.repos.puppet-code.submodules-dir').with_value('thisdir') }
    end

    context "it should not configure the storage service on Compile Masters" do
      before :each do
        @params['file_sync_submodules_dir'] = 'thisdir'
        @params['compile_master'] = true
      end

      it { should_not contain_puppet_enterprise__trapperkeeper__bootstrap_cfg('filesystem-watch-service').with_namespace('puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service') }
      it { should_not contain_pe_hocon_setting('web-router-service/file-sync-storage-service/api') }
      it { should_not contain_pe_hocon_setting('web-router-service/file-sync-storage-service/repo-servlet') }
      it { should_not contain_file('/etc/puppetlabs/code-staging') }
      it { should contain_pe_hocon_setting('file-sync.repos.puppet-code.staging-dir').with_ensure('absent') }
      it { should contain_pe_hocon_setting('file-sync.repos.puppet-code.submodules-dir').with_value('thisdir') }
    end

    context "it should configure the file sync web service on Compile Masters" do
      before :each do
        @params['compile_master'] = true
      end

      it { should contain_pe_hocon_setting('web-router-service/file-sync-web-service').with_value('/file-sync') }
    end

    context "it should configure the file sync locking" do
      before :each do
        @params['file_sync_locking_enabled'] = 'booyah'
      end

      it { should contain_pe_hocon_setting('pe-puppetserver.enable-file-sync-locking').with_value('booyah') }
    end

  end

  context "file-sync client certname list for MoM" do
    before :each do
      Puppet::Parser::Functions.newfunction(:puppetdb_query,
                                            :type => :rvalue,
                                            :arity => 1) do |args|
        if args[0] != ['from', 'resources',
                       ['extract', ['certname'],
                        ['and', ['=', 'type', 'Class'],
                         ['=', 'title', 'Puppet_enterprise::Profile::Master'],
                         ["=", ["node","active"], true]]]]
          raise Puppet::Error,
                "Expecting a query for nodes including the master profile. " +
                "Instead got query for: #{args[0]}"
        end
        [{'certname' => 'dbquery_master_1'}, {'certname' => 'dbquery_master_2'},
         {'certname' => 'dbquery_master_3'}, {'certname' => 'dbquery_master_4'},
         {'certname' => 'dbquery_master_5'}].shuffle
      end

      @params['compile_master'] = false
      @params['whitelisted_certnames'] = ["whitelist_master_1", "whitelist_master_2"]
    end

    context "get_masters_from_puppetdb set to false" do
      # rspec-puppet caches catalogs based on node name, manifest, facts and hiera config.
      # The settings are not part of this cache index, so catalogs which differ only by
      # Puppet.settings changes will end up returning the same catalog from rspec-puppet,
      # hence the need to change node name for some of these tests.
      let(:node) { 'puppetmaster.storeconfigsfalse.test' }

      before :each do
        Puppet[:storeconfigs] = false
      end

      it { should contain_pe_hocon_setting('file-sync.client.client-certnames').with_value([@params['certname']]) }
    end

    context "get_masters_from_puppetdb set to true" do
      let(:node) { 'puppetmaster.filesync.storeconfigstrue.1.test' }
      let(:sorted_masters) do
        ['dbquery_master_1', 'dbquery_master_2', 'dbquery_master_3',
         'dbquery_master_4', 'dbquery_master_5', @params['certname']].uniq.sort
      end

      before :each do
        Puppet.settings[:storeconfigs] = true
        Puppet.settings[:storeconfigs_backend] = 'store_configs_testing'
      end

      it { should contain_pe_hocon_setting('file-sync.client.client-certnames').with_value(sorted_masters) }
    end
  end

  context "authorization rules config for non-compile master" do
    let(:node) { 'puppetmaster.storeconfigstrue.2.test' }
    let(:masters) { [ 'dbquery_master_1',
                      'dbquery_master_2',
                      'master.rspec',
                      'whitelist_master_1',
                      'whitelist_master_2']}

    before :each do
      Puppet::Parser::Functions.newfunction(:puppetdb_query,
                                            :type => :rvalue,
                                            :arity => 1) do |args|
        if args[0] != ['from', 'resources',
                       ['extract', ['certname'],
                        ['and', ['=', 'type', 'Class'],
                         ['=', 'title', 'Puppet_enterprise::Profile::Master'],
                         ["=", ["node","active"], true]]]]
          raise Puppet::Error,
                "Expecting a query for nodes including the master profile. " +
                    "Instead got query for: #{args[0]}"
        end
        [{'certname' => 'dbquery_master_1'}, {'certname' => 'dbquery_master_2'}]
      end

      @params['whitelisted_certnames'] = ["whitelist_master_1",
                                          "whitelist_master_2"]
      @params['compile_master'] = false
      Puppet[:storeconfigs] = true
      Puppet[:storeconfigs_backend] = 'store_configs_testing'
    end

    it { should contain_pe_puppet_authorization__rule('puppetlabs file sync api')
      .with_match_request_path('/file-sync/v1/')
      .with_match_request_type('path')
      .with_allow(masters)
      .with_sort_order(500)
      .with_path(authconf)
      .with_notify('Service[pe-puppetserver]') }

    it { should contain_pe_puppet_authorization__rule('puppetlabs file sync repo')
      .with_match_request_path('/file-sync-git/')
      .with_match_request_type('path')
      .with_allow(masters)
      .with_sort_order(500)
      .with_path(authconf)
      .with_notify('Service[pe-puppetserver]') }
  end

  context 'authorization rules with re-ordered masters (PE-13295)' do
    let(:node) { 'puppetmaster.storeconfigstrue.3.test' }

    let(:masters) { [ 'master 1',
                      'master 2',
                      'master 3',
                      'master 4',
                      'master 5']}

    before :each do
      Puppet::Parser::Functions.newfunction(:puppetdb_query,
                                            :type => :rvalue,
                                            :arity => 1) do |args|
        if args[0] != ['from', 'resources',
                       ['extract', ['certname'],
                        ['and', ['=', 'type', 'Class'],
                         ['=', 'title', 'Puppet_enterprise::Profile::Master'],
                         ["=", ["node","active"], true]]]]
          raise Puppet::Error,
                "Expecting a query for nodes including the master profile. " +
                "Instead got query for: #{args[0]}"
        end
        [{'certname' => 'master 4'}, {'certname' => 'master 1'}]
      end

      @params['certname'] = 'master 3'
      @params['whitelisted_certnames'] = ["master 2", "master 5"]
      @params['compile_master'] = false
      Puppet[:storeconfigs] = true
      Puppet[:storeconfigs_backend] = 'store_configs_testing'
    end

    it { should contain_pe_puppet_authorization__rule('puppetlabs file sync api')
      .with_allow(masters) }

    it { should contain_pe_puppet_authorization__rule('puppetlabs file sync repo')
      .with_allow(masters) }
  end

  context "authorization rules config for compile master" do
    let(:certs) { [ 'com.rspec',
                    'master.rspec']}

    before :each do
      @params['compile_master'] = true
      @params['certname'] = 'com.rspec'
    end

    it { should contain_pe_puppet_authorization__rule('puppetlabs file sync api')
      .with_match_request_path('/file-sync/v1/')
      .with_match_request_type('path')
      .with_sort_order(500)
      .with_allow(certs)
      .with_path(authconf)
      .with_notify('Service[pe-puppetserver]') }

    it { should contain_pe_puppet_authorization__rule('puppetlabs file sync repo')
      .with_path(authconf)
      .with_notify('Service[pe-puppetserver]') }
  end

  context 'custom codedir' do
    before :each do
        @params['puppetserver_jruby_puppet_master_code_dir'] = '/tmp/code'
    end
    it { should contain_pe_hocon_setting('file-sync.repos.puppet-code.live-dir').with_value('/tmp/code') }
  end

end
