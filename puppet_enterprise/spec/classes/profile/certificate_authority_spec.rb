require 'spec_helper'

describe 'puppet_enterprise::profile::certificate_authority' do
  before :each do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'master.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
      'aio_agent_build'   => '1.3.3',
    }
    @params = {}
    Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
      '1.3.3'
    end
  end

  let(:facts)   { @facter_facts }
  let(:confdir) { "/etc/puppetlabs/puppetserver" }
  let(:params)  { @params }
  let(:authconf) { "#{confdir}/conf.d/auth.conf" }

  it { should satisfy_all_relationships }

  context 'client-whitelist certs' do
    context 'deprecated list removed' do
      it { should contain_pe_hocon_setting('certificate-authority.certificate-status').with_ensure('absent') }
    end

    context 'default list' do
      it { should contain_pe_puppet_authorization__rule('puppetlabs certificate status')
        .with_match_request_path('/puppet-ca/v1/certificate_status')
        .with_match_request_type('path')
        .with_match_request_method(['get', 'put', 'delete'])
        .with_allow(['console.rspec'])
        .with_sort_order(500)
        .with_path(authconf)
        .with_notify('Service[pe-puppetserver]') }
    end

    context 'using custom certs' do
      before :each do
        @params['client_whitelist'] = ['foo', 'bar']
      end

      it { should contain_pe_puppet_authorization__rule('puppetlabs certificate status')
        .with_match_request_path('/puppet-ca/v1/certificate_status')
        .with_match_request_type('path')
        .with_match_request_method(['get', 'put', 'delete'])
        .with_allow(['console.rspec', 'foo', 'bar'])
        .with_sort_order(500)
        .with_path(authconf)
        .with_notify('Service[pe-puppetserver]') }
    end
  end

  context 'fileserver.conf' do
    it do
      should contain_augeas('fileserver.conf pe_modules')
        .with_changes([
          "set /files/etc/puppetlabs/puppet/fileserver.conf/pe_modules/path /opt/puppetlabs/server/share/installer/modules",
          "set /files/etc/puppetlabs/puppet/fileserver.conf/pe_modules/allow *",
        ])
        .with_incl('/etc/puppetlabs/puppet/fileserver.conf')
        .with_load_path('/opt/puppetlabs/puppet/share/augeas/lenses/dist')
        .with_lens('PuppetFileserver.lns')
    end

    it do
      should contain_augeas('fileserver.conf pe_modules').that_comes_before('Pe_anchor[puppet_enterprise:barrier:ca]')
    end
  end
end
