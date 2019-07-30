require 'spec_helper'

describe 'puppet_enterprise::trapperkeeper::pcp_broker' do
  before :each do
    @facter_facts = {
      'kernel'            => 'Linux',
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'serverversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'is_pe'             => 'true',
      'fqdn'              => 'master.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir'    => '/tmp/file',
    }

    @params = {}
  end

  let(:facts) { @facter_facts }
  let(:params) { @params }
  let(:title) { 'orchestration-services' }
  let(:confdir) { "/etc/puppetlabs/#{title}" }

  context "configuring the pcp-broker" do
    it { should contain_file("#{confdir}/conf.d/pcp-broker.conf").with(:owner => 'pe-orchestration-services',
                                                                       :group => 'pe-orchestration-services',
                                                                       :mode  => '0640') }

    it { should contain_pe_hocon_setting("#{title}.pcp-broker.accept-consumers").with_value(2) }
    it { should contain_pe_hocon_setting("#{title}.pcp-broker.delivery-consumers").with_value(2) }
  end

  context "configuring authorization" do
    it { should contain_file("#{confdir}/conf.d/authorization.conf").with(:owner => 'pe-orchestration-services',
                                                                          :group => 'pe-orchestration-services',
                                                                          :mode  => '0640') }

    it { should contain_pe_hocon_setting("#{title}.authorization.version").with_value(1) }
    it { should contain_pe_puppet_authorization__rule('pxp commands')
      .with_match_request_path('/pcp-broker/send')
      .with_match_request_type('path')
      .with_match_request_query_params({'message_type' => [
        'http://puppetlabs.com/rpc_non_blocking_request',
        'http://puppetlabs.com/rpc_blocking_request']})
      .with_allow([
        'console.rspec',
        'master.rspec'])
      .with_path("#{confdir}/conf.d/authorization.conf")
      .with_sort_order(400) }
    it { should contain_pe_puppet_authorization__rule('inventory request')
      .with_match_request_path('/pcp-broker/send')
      .with_match_request_type('path')
      .with_match_request_query_params({'message_type' => [
        'http://puppetlabs.com/inventory_request']})
      .with_allow([
        'console.rspec',
        'master.rspec'])
      .with_path("#{confdir}/conf.d/authorization.conf")
      .with_sort_order(400) }
    it { should contain_pe_puppet_authorization__rule('multi-cast with destination_report')
      .with_match_request_path('/pcp-broker/send')
      .with_match_request_type('path')
      .with_match_request_query_params({'targets' => [
        'pcp://*/agent',
        'pcp://*/*'],
        'destination_report' => 'true'})
      .with_allow([])
      .with_path("#{confdir}/conf.d/authorization.conf")
      .with_sort_order(399) }
    it { should contain_pe_puppet_authorization__rule('pcp-broker message')
      .with_match_request_path('/pcp-broker/send')
      .with_match_request_type('path')
      .with_allow_unauthenticated(true)
      .with_path("#{confdir}/conf.d/authorization.conf")
      .with_sort_order(420) }
    it { should contain_pe_puppet_authorization__rule('pcp messages')
      .with_ensure('absent')
      .with_path("#{confdir}/conf.d/authorization.conf") }
  end

  context "configuring bootstrap.cfg" do
    it { should contain_pe_concat__fragment('orchestration-services broker-service') }
    it { should contain_pe_concat__fragment('orchestration-services authorization-service') }
    it { should contain_pe_concat__fragment('orchestration-services jetty9-service') }
    it { should contain_pe_concat__fragment('orchestration-services webrouting-service') }
    it { should contain_pe_concat__fragment('orchestration-services metrics-service') }
  end
end
