require 'spec_helper'

describe 'puppet_enterprise::master::code_manager' do
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
      'servername'        => 'master.rspec'
    }

    @params = {
      'certname'         => 'master.rspec',
    }
  end

  let(:facts)   { @facter_facts }
  let(:params)  { @params }
  let(:confdir) { "/etc/puppetlabs/puppetserver" }

  context 'no control repo configuration provided' do
    it { should contain_pe_hocon_setting('code-manager.sources').with_ensure('absent') }
  end

  context 'with a proxy' do
    let(:proxy) { "http://user:password@proxy.example.com:3128" }
    before(:each) { @params['proxy'] = proxy }

    it { should contain_pe_hocon_setting('code-manager.proxy').with_ensure('present') }
    it { should contain_pe_hocon_setting('code-manager.proxy').with_value(proxy) }
  end

  context 'without forge_settings' do
    it { should contain_pe_hocon_setting('code-manager.forge').with_ensure('absent') }
    it { should contain_pe_hocon_setting('code-manager.forge-settings').with_ensure('absent') }
  end

  context 'with forge_settings' do
    before(:each) { @params['forge_settings'] = {'proxy' => 'https://forge.proxy'} }
    it { should contain_pe_hocon_setting('code-manager.forge').with_ensure('present') }
    it { should contain_pe_hocon_setting('code-manager.forge').with_value({'proxy' => 'https://forge.proxy'}) }
    it { should contain_pe_hocon_setting('code-manager.forge-settings').with_ensure('absent') }
  end

  context 'with a remote repo information provided' do
    before :each do
      @params['remote'] = 'git@github.com:puppetlabs/puppetlabs-modules'
    end

    it do
      sources = { 'puppet' => { 'remote' => 'git@github.com:puppetlabs/puppetlabs-modules'}}
      should contain_pe_hocon_setting('code-manager.sources').with_value(sources)
    end
  end

  context 'with sources provided' do
    before :each do
      @params['sources'] = { 'puppet' => {} }
    end

    it do
      should contain_pe_hocon_setting('code-manager.sources').with_value(@params['sources'])
    end
  end

  context 'without invalid-branches' do
    it { should contain_pe_hocon_setting('code-manager.invalid-branches').with_ensure('absent') }
  end

  context 'with invalid-branches provided' do
    before :each do
      @params['invalid_branches'] = 'correct'
    end

    it do
      should contain_pe_hocon_setting('code-manager.invalid-branches').with_ensure('present')
      should contain_pe_hocon_setting('code-manager.invalid-branches').with_value('correct')
    end
  end

  context 'with file_sync_auto_commit' do
    it { should contain_pe_hocon_setting('code-manager.environmentdir').with_value('/etc/puppetlabs/code-staging/environments') }
    it { should contain_puppet_enterprise__trapperkeeper__bootstrap_cfg('code-manager-v1') }
  end

  context 'with file_sync_auto_commit' do
    before :each do
      @params['file_sync_auto_commit'] = false
    end

    it { should contain_pe_hocon_setting('code-manager.environmentdir').with_value('/etc/puppetlabs/code/environments') }
    it { should contain_puppet_enterprise__trapperkeeper__bootstrap_cfg('code-manager-v1-no-file-sync') }
  end

  context 'Without a private_key' do
    it do
      should contain_pe_hocon_setting('code-manager.git').with_ensure('absent')
    end

    context 'With a git_settings_hash' do
      before(:each) { @params['git_settings'] = {"proxy" => "https://example.com"} }
      after(:each) { @params.delete('git_settings') }
      it do
        should contain_pe_hocon_setting('code-manager.git').with_value(@params['git_settings'])
      end
    end
  end

  context 'with a private key provided' do
    before(:each) { @params['private_key'] = '/etc/puppetlabs/code-manager/id_rsa' }
    it do
      should contain_pe_hocon_setting('code-manager.private-key').with_ensure('absent')
      should contain_pe_hocon_setting('code-manager.git').with_value({"private-key" => @params['private_key']})
    end

    context "with private_key and git_settings" do
      before(:each) { @params['git_settings'] = {"proxy" => "https://example.com"} }
      it do
        expect {should compile}.to raise_error(/Both private_key and git/)
      end
    end
  end
end
