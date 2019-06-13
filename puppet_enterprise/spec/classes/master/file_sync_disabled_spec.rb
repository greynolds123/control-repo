require 'spec_helper'

describe 'puppet_enterprise::master::file_sync_disabled' do
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
      'code_id_command'      => '/usr/bin/justin-is-amazing.sh',
      'code_content_command' => '/usr/bin/justin-loves-this-idea.sh',
    }
  end

  let(:confdir) { "/etc/puppetlabs/puppetserver" }
  let(:params)  { @params }
  let(:facts)   { @facter_facts }

  context "remove the file-sync.conf file" do
    it { should contain_file("#{confdir}/conf.d/file-sync.conf").with_ensure('absent')}
  end

  context "manages the versioned-code.conf file and settings" do
    it { should contain_file("#{confdir}/conf.d/versioned-code.conf").with_ensure('present')}
    it { should contain_pe_hocon_setting('versioned-code.code-id-command').with_value(@params['code_id_command'])}
    it { should contain_pe_hocon_setting('versioned-code.code-content-command').with_value(@params['code_content_command'])}
  end

  context "explodes with only one set" do
    before :each do
      @params = { 'code_id_command' => '/usr/bin/justin-is-amazing.sh' }
    end
    it { should_not contain_file("#{confdir}/conf.d/versioned-code.conf"), "The catalogue DOES contain the file. HOW CAN THIS BE?"}
    it { should_not contain_pe_hocon_setting('versioned-code.code-id-command'), "The catalogue DOES contain the setting. HOW CAN THIS BE?"}
    it { should_not contain_pe_hocon_setting('versioned-code.code-content-command'), "The catalogue DOES contain the setting. HOW CAN THIS BE?"}
    it { should contain_notify('missing-code-command-configuration') }
  end

  context "does nothing if neither is set" do
    before :each do
      @params = { }
    end
    it { should contain_file("#{confdir}/conf.d/versioned-code.conf").with_ensure('absent'), "The catalogue DOES contain the file. HOW CAN THIS BE?"}
    it { should_not contain_pe_hocon_setting('versioned-code.code-id-command'), "The catalogue DOES contain the setting. HOW CAN THIS BE?"}
    it { should_not contain_pe_hocon_setting('versioned-code.code-content-command'), "The catalogue DOES contain the setting. HOW CAN THIS BE?"}
    it { should_not contain_notify('missing-code-command-configuration') }
  end

  context "add the versioned code service to the bootstrap.cfg" do
    # Make sure we aren't adding the disabled service.
    it { should_not contain_pe_concat__fragment('puppetserver file-sync-versioned-code-disabled-service') }

    it { should contain_pe_concat__fragment('puppetserver versioned-code-service') }
  end

  context "remove the authorization rules" do
    it { should contain_pe_puppet_authorization__rule('puppetlabs file sync api')
      .with_path('/etc/puppetlabs/puppetserver/conf.d/auth.conf')
      .with_notify('Service[pe-puppetserver]') }
    it { should contain_pe_puppet_authorization__rule('puppetlabs file sync repo')
      .with_path('/etc/puppetlabs/puppetserver/conf.d/auth.conf')
      .with_notify('Service[pe-puppetserver]') }
  end
end
