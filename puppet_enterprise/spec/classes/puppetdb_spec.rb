require 'spec_helper'

describe 'puppet_enterprise::puppetdb' do
  before :all do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'fqdn'              => 'puppetdb.local.domain',
    }

    @params = {
      'certname'            => 'puppetdb.local.domain',
      'database_host'       => 'database.local.domain',
      'cert_whitelist_path' => '/etc/puppetlabs/puppetdb/certificate-whitelist',
      'database_port'       => 5432,
      'database_user'       => 'pe-puppetdb',
      'database_properties' => '',
      'command_processing_threads' => 4,
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:sharedir) { '/opt/puppet/share/puppet-dashboard' }
  let(:ssldir) { '/etc/puppetlabs/puppet/ssl' }

  context "when managing packages" do
    it { should contain_package('pe-java') }
    it { should contain_package('pe-puppetdb') }
  end

  context "when managing default java_args" do
    it { should contain_pe_ini_subsetting("pe-puppetdb_'Xmx'").with_value( '256m' ) }
    it { should contain_pe_ini_subsetting("pe-puppetdb_'Xms'").with_value( '256m' ) }
  end

  context "wth custom java_args" do
    before(:all) { @params['java_args'] = { 'Xmx' => '128m' } }
    it { should contain_pe_ini_subsetting("pe-puppetdb_'Xmx'").with(
     'value'   => '128m',
     'require' => 'Package[pe-puppetdb]',
    ) }
  end

  context "managing service defaults" do
    it { should contain_pe_ini_setting('pe-puppetdb initconf java_bin')
         .with_setting('JAVA_BIN')
         .with_value('"/opt/puppetlabs/server/bin/java"')
         .with_path('/etc/default/pe-puppetdb') }
    it { should contain_pe_ini_setting('pe-puppetdb initconf user')
         .with_setting('USER')
         .with_value('pe-puppetdb') }
    it { should contain_pe_ini_setting('pe-puppetdb initconf group')
         .with_setting('GROUP')
         .with_value('pe-puppetdb') }
    it { should contain_pe_ini_setting('pe-puppetdb initconf install_dir')
         .with_setting('INSTALL_DIR')
         .with_value('"/opt/puppetlabs/server/apps/puppetdb"') }
    it { should contain_pe_ini_setting('pe-puppetdb initconf config')
         .with_setting('CONFIG')
         .with_value('"/etc/puppetlabs/puppetdb/conf.d"') }
    it { should contain_pe_ini_setting('pe-puppetdb initconf bootstrap_config')
         .with_setting('BOOTSTRAP_CONFIG')
         .with_value('"/etc/puppetlabs/puppetdb/bootstrap.cfg"') }
    it { should contain_pe_ini_setting('pe-puppetdb initconf service_stop_retries')
         .with_setting('SERVICE_STOP_RETRIES')
         .with_value('60') }
    it { should contain_pe_ini_setting('pe-puppetdb initconf start_timeout')
         .with_setting('START_TIMEOUT')
         .with_value('120') }

    context "with overrides" do
      before(:each) do
        @params['service_stop_retries'] = 12345
        @params['start_timeout'] = 67890
      end

      it { should contain_pe_ini_setting('pe-puppetdb initconf service_stop_retries')
           .with_setting('SERVICE_STOP_RETRIES')
           .with_value('12345') }
      it { should contain_pe_ini_setting('pe-puppetdb initconf start_timeout')
           .with_setting('START_TIMEOUT')
           .with_value('67890') }
    end
  end

  it { should contain_class('puppet_enterprise::puppetdb::database_ini') }
  it { should contain_class('puppet_enterprise::puppetdb::jetty_ini') }
  it { should contain_class('puppet_enterprise::puppetdb::rbac_consumer_conf') }
  it { should contain_class('puppet_enterprise::puppetdb::service') }
  it { should contain_file('/var/log/puppetlabs/puppetdb').with(
    'ensure' => 'directory',
    'owner'  => 'pe-puppetdb',
    'group'  => 'pe-puppetdb',
    'mode'   => '0640'
  )}
  it { should contain_file('/var/log/puppetlabs/puppetdb/puppetdb.log').with(
    'ensure'  => 'present',
    'owner'   => 'pe-puppetdb',
    'group'   => 'pe-puppetdb',
    'mode'    => '0640',
  )}

  context "when not managing sync.ini" do
    it { should_not contain_class('puppet_enterprise::puppetdb::sync_ini') }
  end

  context "when managing sync.ini" do
    before(:all) { @params['sync_peers'] = [] }
    it { should contain_class('puppet_enterprise::puppetdb::sync_ini') }
  end

  describe 'when using default values' do
    it { should contain_pe_ini_setting('[read-database]-maximum-pool-size').
         with(
          'ensure'  => 'present',
          'path'    => '/etc/puppetlabs/puppetdb/conf.d/read_database.ini',
          'section' => 'read-database',
          'setting' => 'maximum-pool-size',
          'value'   => 25
    )}
    it { should contain_pe_ini_setting('[read-database]-puppetdb_psdatabase_username').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/read_database.ini',
           'section' => 'read-database',
           'setting' => 'username',
           'value'   => 'pe-puppetdb'
    )}
    it { should_not contain_pe_ini_setting('[read-database]-puppetdb_psdatabase_password') }
    it { should contain_pe_ini_setting('[read-database]-puppetdb_subname').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/read_database.ini',
           'section' => 'read-database',
           'setting' => 'subname',
           'value'   => '//database.local.domain:5432/pe-puppetdb'
    )}
  end
  describe 'when setting read database connections' do
    before(:each) do
      @params['read_maximum_pool_size'] = 41
    end
    it { should contain_pe_ini_setting('[read-database]-maximum-pool-size').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/read_database.ini',
           'section' => 'read-database',
           'setting' => 'maximum-pool-size',
           'value'   => 41
    )}
  end
  describe 'when using a box with 32 cores' do
    before(:each) do
      @params['command_processing_threads'] = 16
    end
    it { should contain_pe_ini_setting('[database]-maximum-pool-size').
         with(
          'ensure'  => 'present',
          'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
          'section' => 'database',
          'setting' => 'maximum-pool-size',
          'value'   => 32
    )}
  end
  describe 'when using a box with 32 cores and overwriting maximum-pool-size' do
    before(:each) do
      @params['command_processing_threads'] = 16
      @params['write_maximum_pool_size']    = 18
    end
    it { should contain_pe_ini_setting('[database]-maximum-pool-size').
         with(
          'ensure'  => 'present',
          'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
          'section' => 'database',
          'setting' => 'maximum-pool-size',
          'value'   => 18
    )}
  end
  describe 'when setting read and write databases seperately' do
    before(:each) do
      @params['database_host']            = 'write-database.local.domain'
      @params['read_database_host']       = 'read-database.local.domain'
      @params['database_name']            = 'write-pdb-database'
      @params['read_database_name']       = 'read-pdb-database'
      @params['database_port']            = 1234
      @params['read_database_port']       = 5678
      @params['database_user']            = 'write-pe-puppetdb'
      @params['read_database_user']       = 'read-pe-puppetdb'
      @params['database_properties']      = ''
      @params['read_database_properties'] = ''
    end

    it { should contain_pe_ini_setting('[read-database]-puppetdb_psdatabase_username').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/read_database.ini',
           'section' => 'read-database',
           'setting' => 'username',
           'value'   => 'read-pe-puppetdb'
    )}
    it { should contain_pe_ini_setting('[database]-puppetdb_psdatabase_username').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
           'section' => 'database',
           'setting' => 'username',
           'value'   => 'write-pe-puppetdb'
    )}
    it { should_not contain_pe_ini_setting('[read-database]-puppetdb_psdatabase_password') }
    it { should_not contain_pe_ini_setting('[database]-puppetdb_psdatabase_password') }
    it { should contain_pe_ini_setting('[read-database]-puppetdb_subname').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/read_database.ini',
           'section' => 'read-database',
           'setting' => 'subname',
           'value'   => '//read-database.local.domain:5678/read-pdb-database'
    )}
    it { should contain_pe_ini_setting('[database]-puppetdb_subname').
         with(
           'ensure'  => 'present',
           'path'    => '/etc/puppetlabs/puppetdb/conf.d/database.ini',
           'section' => 'database',
           'setting' => 'subname',
           'value'   => '//write-database.local.domain:1234/write-pdb-database'
    )}
  end
end
