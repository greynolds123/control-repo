require 'spec_helper'

describe 'puppet_enterprise::profile::database' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'database.rspec',
      'memorysize'        => '2.00 GB',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir'    => '/tmp/file',
    }

    @params = { 'certname' => 'puppetdb.local.domain' }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:certname) { @params['certname'] }
  let(:sharedir) { '/etc/puppetlabs/puppet/ssl' }
  let(:pgsqldir) { '/opt/puppetlabs/server/data/postgresql/9.4/data' }

  context "validating parameters" do
    context "listen_addresses" do
      let(:params) { @params.merge({ 'database_listen_addresses' => 'localhost' }) }

      it { should contain_class('pe_postgresql::server').with_listen_addresses('localhost') }
    end
  end

  context "when the parameters are valid" do
    it do
      should contain_class('pe_postgresql::server')
        .with(:listen_addresses => '*')
        .with(:package_ensure  => 'latest')
    end
    it { should contain_class('pe_postgresql::server::contrib').with('package_ensure' => 'latest') }
    it do
      should contain_class('pe_postgresql::client')
        .with('package_ensure' => 'latest')
        .with('package_name'   => 'pe-postgresql')
        .with('bindir'         => '/opt/puppetlabs/server/bin')
    end
    it { should contain_service('postgresqld').with('name'                    => 'pe-postgresql', 'ensure' => 'running', 'enable' => true) }
    it { should contain_file('/opt/puppetlabs/server/data/postgresql/9.4').with(:ensure => 'directory') }

    context "when managing the databases" do
      let(:params) { @params.merge({ 'puppetdb_database_password' => 'blah',
                                     'classifier_database_password' => 'blah',
                                     'rbac_database_password' => 'blah',
                                     'activity_database_password' => 'blah',
                                     'orchestrator_database_password' => 'blah', }) }

      it { should contain_pe_postgresql__server__tablespace('pe-puppetdb') }
      it { should contain_pe_postgresql__server__db('pe-puppetdb').with_user('pe-puppetdb') }
      it { should contain_pe_postgresql_psql('pe-puppetdb extension pg_trgm').with_db('pe-puppetdb') }
      it { should contain_pe_postgresql_psql('pe-puppetdb extension pgcrypto').with_db('pe-puppetdb') }
      it { should contain_pe_postgresql__server__tablespace('pe-classifier') }
      it { should contain_pe_postgresql__server__db('pe-classifier').with_user('pe-classifier') }
      it { should contain_pe_postgresql__server__tablespace('pe-rbac') }
      it { should contain_pe_postgresql__server__db('pe-rbac').with_user('pe-rbac') }
      it { should contain_pe_postgresql_psql('pe-rbac extension citext').with_db('pe-rbac') }
      it { should contain_pe_postgresql__server__tablespace('pe-activity') }
      it { should contain_pe_postgresql__server__db('pe-activity').with_user('pe-activity') }
      it { should contain_pe_postgresql__server__tablespace('pe-orchestrator') }
      it { should contain_pe_postgresql__server__db('pe-orchestrator').with_user('pe-orchestrator') }

      it { should satisfy_all_relationships }
    end

    context "when setting database names equal to each other" do
      let(:params) { @params.merge({ 'puppetdb_database_name' => 'blah',
                                     'classifier_database_name' => 'blah',
                                     'rbac_database_name' => 'blah',
                                     'activity_database_name' => 'blah',
                                     'orchestrator_database_name' => 'blah', }) }

      it { should_not compile.and_raise_error('Database names must be unique')  }
    end

    context "when hacking around RedHat-related bugs in the puppetlabs-postgresql module" do
      before :each do
        @facter_facts['osfamily'] = 'RedHat'
        @facter_facts['operatingsystem'] = 'RedHat'
        @facter_facts['operatingsystemrelease'] = '6'
      end

      it { should contain_file('/etc/sysconfig/pgsql').with(:ensure => 'directory') }
      it { should contain_file('/etc/sysconfig/pe-pgsql').with(:ensure => 'directory') }
      it { should contain_file('/etc/sysconfig/pe-pgsql/pe-postgresql').with(:ensure => 'link', :target => '/etc/sysconfig/pgsql/postgresql') }
    end

    context "managing certs" do
      it { should contain_file("#{pgsqldir}/certs").with_mode('0600') }
      it { should contain_file("#{pgsqldir}/certs/#{certname}.cert.pem").with(:source => "#{sharedir}/certs/#{certname}.pem", :mode => '0400') }
      it { should contain_file("#{pgsqldir}/certs/#{certname}.private_key.pem").with(:source => "#{sharedir}/private_keys/#{certname}.pem", :mode => '0400') }
    end

    context "when configuring postgresql.conf" do
      it { should contain_pe_postgresql__server__config_entry('ssl').with(:value => 'on') }
      it { should contain_pe_postgresql__server__config_entry('ssl_cert_file').with(:value => "certs/#{certname}.cert.pem") }
      it { should contain_pe_postgresql__server__config_entry('ssl_key_file').with(:value => "certs/#{certname}.private_key.pem") }
      it { should contain_pe_postgresql__server__config_entry('effective_cache_size').with(:value => '921MB') }
      it { should contain_pe_postgresql__server__config_entry('shared_buffers').with(:value => '384MB') }
      it { should contain_pe_postgresql__server__config_entry('maintenance_work_mem').with(:value => '256MB') }
      it { should contain_pe_postgresql__server__config_entry('wal_buffers').with(:value => '8MB') }
      it { should contain_pe_postgresql__server__config_entry('work_mem').with(:value => '4MB') }
      it { should contain_pe_postgresql__server__config_entry('checkpoint_segments').with(:value => '16') }
      it { should contain_pe_postgresql__server__config_entry('log_min_duration_statement').with(:value => '5000') }
      it { should contain_pe_postgresql__server__config_entry('max_connections').with(:value => '200') }
      it { should contain_pe_postgresql__server__config_entry('log_line_prefix').with(:value => '%m [db:%d,sess:%c,pid:%p,vtid:%v,tid:%x] ') }
      it { should contain_pe_postgresql__server__config_entry('ssl_ca_file').with(:value => "/etc/puppetlabs/puppet/ssl/certs/ca.pem") }
      it { should contain_pe_postgresql__server__config_entry('autovacuum_vacuum_scale_factor').with(:value => '0.08') }
      it { should contain_pe_postgresql__server__config_entry('autovacuum_analyze_scale_factor').with(:value => '0.04') }
    end

    context "when configuring postgresql.conf with custom max_connections setting" do
      before :each do
        @params['max_connections'] = 543
        @params['autovacuum_vacuum_scale_factor'] = 0.15
        @params['autovacuum_analyze_scale_factor'] = 0.07
      end
      it { should contain_pe_postgresql__server__config_entry('max_connections').with(:value => '543') }
      it { should contain_pe_postgresql__server__config_entry('autovacuum_vacuum_scale_factor').with(:value => '0.15') }
      it { should contain_pe_postgresql__server__config_entry('autovacuum_analyze_scale_factor').with(:value => '0.07') }
    end

    context "when configuring postgresql.conf with custom max_connections setting below 200" do
      before :each do
        @params['max_connections'] = 1
      end
      it { should contain_pe_postgresql__server__config_entry('max_connections').with(:value => '200') }
    end

    context "when configuring postgresql.conf with low memory" do
      before :each do
        @facter_facts['memorysize'] = '512MB'
      end

      it { should contain_pe_postgresql__server__config_entry('effective_cache_size').with(:value => '128MB') }
      it { should contain_pe_postgresql__server__config_entry('shared_buffers').with(:value => '32MB') }
    end

    context "when configuring pg_hba.conf" do
      it { should contain_pe_concat__fragment('pg_hba_rule_allow access to all ipv6').with(
        :content => %r[host\s+all\s+all\s+\:\:\/0\s+md5]
      )}
      it { should contain_pe_postgresql__server__pg_hba_rule('pe-puppetdb ipv6 cert auth rule').with(
        :type        => 'hostssl',
        :database    => 'pe-puppetdb',
        :user        => 'pe-puppetdb',
        :address     => '::/0',
        :auth_method => 'cert',
        :auth_option => "map=pe-puppetdb-map clientcert=1",
      )}
      it { should contain_pe_postgresql__server__pg_hba_rule('pe-puppetdb cert auth rule').with(
        :type        => 'hostssl',
        :database    => 'pe-puppetdb',
        :user        => 'pe-puppetdb',
        :address     => '0.0.0.0/0',
        :auth_method => 'cert',
        :auth_option => "map=pe-puppetdb-map clientcert=1",
      )}
    end
  end
end
