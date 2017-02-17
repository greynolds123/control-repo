require 'spec_helper'

describe 'puppet_enterprise::profile::master::mcollective' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
    }
  end

  let(:facts) { @facter_facts }
  let(:ssldir) { '/etc/puppetlabs/puppet/ssl' }
  let(:mco_ssl_dir) { '/etc/puppetlabs/mcollective/ssl' }
  let(:mco_credentials_path) { '/etc/puppetlabs/mcollective/credentials' }
  let(:mco_shared_keypair_name) { 'pe-internal-mcollective-servers' }
  let(:mco_peadmin_keypair_name) { 'pe-internal-peadmin-mcollective-client' }
  let(:mco_console_keypair_name) { 'pe-internal-puppet-console-mcollective-client' }

  it { should satisfy_all_relationships }

  context "mco credentials" do
    it { should contain_file(mco_credentials_path).with(:mode => '0600') }
  end

  context "mco shared keypair" do
    it { should contain_file("#{mco_shared_keypair_name}.private_key.pem") }
    it { should contain_file("#{mco_shared_keypair_name}.public_key.pem") }
  end

  context "mco clients" do
    context "peadmin" do
      it { should contain_file("#{mco_peadmin_keypair_name}.private_key.pem") }
      it { should contain_file("#{mco_peadmin_keypair_name}.public_key.pem") }
    end

    context "console" do
      it { should contain_file("#{mco_console_keypair_name}.private_key.pem") }
      it { should contain_file("#{mco_console_keypair_name}.public_key.pem") }
    end

    context "user clients" do
      let(:params) { {"user_clients" => ['test1','test2','test3', mco_peadmin_keypair_name] } }
      it { should contain_file("test1.private_key.pem") }
      it { should contain_file("test2.private_key.pem") }
      it { should contain_file("test3.private_key.pem") }
      it { should contain_file("test1.public_key.pem") }
      it { should contain_file("test2.public_key.pem") }
      it { should contain_file("test3.public_key.pem") }
      it { should contain_file("#{mco_console_keypair_name}.private_key.pem") }
      it { should contain_file("#{mco_console_keypair_name}.public_key.pem") }
    end
  end
end
