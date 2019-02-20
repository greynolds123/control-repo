require 'spec_helper'

describe 'puppet_enterprise::mcollective::server::plugins' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'RedHat',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'somenode.rspec',
      'clientcert'        => 'awesomecert',
    }
  end

  let(:facts) { @facter_facts }
  let(:mco_plugins) { "#{mco_base}/plugins/mcollective" }

  context "on a windows machine" do
    let(:mco_base) { "/ProgramData/PuppetLabs/mcollective" }

    before :each do
      @facter_facts['osfamily'] = 'windows'
      @facter_facts['operatingsystem'] = 'windows'
      @facter_facts['common_appdata'] = '/ProgramData'
    end

    it { should compile }

    it "does not manage mco_base" do
      should_not contain_file(mco_base).with(
        'owner' => 'S-1-5-32-544',
        'group' => 'S-1-5-32-544',
        'mode'  => '0664'
      )
    end

    it { should contain_file(mco_plugins).that_notifies('Service[mcollective]') }
  end

  context "on a AIX machine" do
    let(:mco_base) { "/opt/puppetlabs/mcollective" }

    before :each do
      @facter_facts['operatingsystem'] = 'AIX'
    end

    it { should compile }
    it { should contain_file(mco_plugins).that_notifies('Service[mcollective]') }
  end

  context "on a RedHat machine" do
    let(:mco_base) { "/opt/puppetlabs/mcollective" }

    it { should compile }

    it "manages mco_base" do
      should contain_file(mco_base)
    end

    it { should contain_file(mco_plugins).that_notifies('Service[mcollective]') }
  end

  it { should satisfy_all_relationships }
end
