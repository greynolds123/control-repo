require 'spec_helper'

describe 'puppet_enterprise::certs::whitelist_entry', :type => :define do
  context 'on a supported platform' do
    let(:title) { 'pe-internal-dashboard' }

    let(:facts) do
      {
        :osfamily => 'RedHat',
        :fqdn     => 'test.domain.local'
      }
    end

    let(:params) do
      {
        :target   => '/etc/puppetlabs/puppetdb/certificate-whitelist',
        :certname => title,
      }
    end

    it { should contain_pe_file_line("#{params[:target]}:#{params[:certname]}").with('line' => params[:certname]) }
  end
end

