require 'spec_helper'
require 'shared_contexts'

describe 'quagga::bgpd::peer' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  let(:node) { 'foo.example.com' }
  let(:title) { '64498' }
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      addr4: ['192.0.2.2'],
      #addr6: [],
      desc: 'TEST Network',
      #inbound_routes: "none",
      #communities: [],
      #multihop: undef,
      #password: undef,
      #prepend: undef,
    }
  end
  let(:pre_condition) {
    "class {'::quagga::bgpd': my_asn => '64496', router_id => '192.0.2.1', networks4 => ['192.0.2.0/24'] }"
  }
  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      describe 'check default config' do
        # add these two lines in a single test block to enable puppet and hiera debug mode
        # Puppet::Util::Log.level = :debug
        # Puppet::Util::Log.newdestination(:console)
        it do
          is_expected.to compile.with_all_deps
        end
        it { is_expected.to contain_class('Quagga::Bgpd') }

        it do
          is_expected.to contain_concat__fragment('bgpd_peer_64498')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 remote-as 64498/
            ).with_content(
              /neighbor 192.0.2.2 description TEST Network/
            ).with_content(
              /neighbor 192.0.2.2 soft-reconfiguration inbound/
            ).with_content(
              /neighbor 192.0.2.2 prefix-list prefix-v4 out/
            ).with_content(
              /neighbor 192.0.2.2 prefix-list deny in/
            ).without_content(
              /neighbor 192.0.2.2 prefix-list deny-default-route in/
            ).without_content(
              /neighbor 192.0.2.2 route-map outbound-64498 out/
            )
        end
        it do
          is_expected.to_not contain_concat__fragment('bgpd_v6peer_64498')
        end
        it do
          is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64498')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).without_content(
              /route-map outbound-64498/
            ).without_content(
              /route-map outbound-64498-v6/
            ).without_content(
              /set community/
            )
        end
      end
    end
  end
end
