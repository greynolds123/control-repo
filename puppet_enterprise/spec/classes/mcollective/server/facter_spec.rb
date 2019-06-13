require 'spec_helper'

describe 'puppet_enterprise::mcollective::server::facter' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'RedHat',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'somenode.rspec',
      'clientcert'        => 'awesomecert',
    }

    @params = {
      'mco_facter_interval_offset' => 7
    }
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:winfile) { 'refresh-mcollective-metadata.bat' }
  let(:unixfile) { '/opt/puppetlabs/puppet/bin/refresh-mcollective-metadata' }
  let(:cronname) { 'pe-mcollective-metadata' }

  context "on a AIX machine" do
    before :each do
      @facter_facts['operatingsystem'] = 'AIX'
    end

    it { should compile }

    it { should contain_file(unixfile).with(
      'owner' => 'root',
      'group' => 'system',
      'mode'  => '0775',
    )}

    it { should contain_cron(cronname).with(
      'user'   => 'root',
      'minute' => [ '7', '22', '37', '52' ],
    )}

    it { should satisfy_all_relationships }
  end

  context "on a RedHat machine" do
    it { should compile }

    it { should contain_file(unixfile).with(
      'owner' => 'root',
      'group' => 'root',
      'mode'  => '0775',
    )}

    describe "Cron job resource defaults to managed" do
      it { should contain_cron(cronname).with(
        'user'   => 'root',
        'minute' => [ '7', '22', '37', '52' ],
      )}
    end

    describe "Cron job resource can be disabled" do
      before :each do
        @params = {'manage_metadata_cron' => false }
      end

      it { should_not contain_cron(cronname) }
    end

    it { should satisfy_all_relationships }
  end

  context "with custom cron settings" do
    before :each do
      @params['mco_facter_cron_hour']     = [ '0', '6', '12' ]
      @params['mco_facter_cron_minute']   = [ '0', '30' ]
      @params['mco_facter_cron_month']    = '*/2'
      @params['mco_facter_cron_monthday'] = '*/2'
      @params['mco_facter_cron_weekday']  = [ '0' ]
    end

    it { should contain_cron(cronname).with(
      'user'     => 'root',
      'hour'     => [ '0', '6', '12' ],
      'minute'   => [ '0', '30' ],
      'month'    => '*/2',
      'monthday' => '*/2',
      'weekday'  => [ '0' ]
    )}
  end

  context "with a custom run interval" do
    before :each do
      @params['mco_facter_interval']        = 30
      @params['mco_facter_interval_offset'] = 4
    end

    it { should contain_cron(cronname).with(
      'user'     => 'root',
      'minute'   => [ '4', '34' ]
    )}
  end

  # Spec order affects Puppet's supports_acl? being present when this spec is
  # run independently (see spec.classes/mcollective/server/certs_spec.rb for
  # more gory details
  context "on a windows machine" do
    before :each do
      @facter_facts['osfamily'] = 'windows'
      @facter_facts['operatingsystem'] = 'windows'
      @facter_facts['common_appdata'] = '/ProgramData'
    end

    it { catalogue }

    it { should contain_scheduled_task('pe-mcollective-metadata') }

    it { should satisfy_all_relationships }
  end

  context "on a windows machine disabling metadata scheduled task" do
    before :each do
      @facter_facts['osfamily']        = 'windows'
      @facter_facts['operatingsystem'] = 'windows'
      @params['manage_metadata_cron']  = false
      @facter_facts['common_appdata'] = '/ProgramData'
    end

    it { catalogue }

    it { should_not contain_scheduled_task('pe-mcollective-metadata') }

    it { should satisfy_all_relationships }
  end
end
