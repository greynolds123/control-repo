require 'spec_helper'

describe 'puppet_enterprise::certs::puppetdb_whitelist' do
  context 'on a supported platform' do
    let(:title) { 'export: some-cert for puppetdb' }

    let(:facts) do
      {
        :osfamily => 'RedHat',
        :fqdn     => 'test.domain.local'
      }
    end

    let(:params) do
      {
        :certnames => ['some-cert'],
      }
    end

    it { should contain_pe_file_line("/etc/puppetlabs/puppetdb/certificate-whitelist:some-cert").with('line' => 'some-cert') }
  end

end
