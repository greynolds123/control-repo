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
  let(:title) { '64497' }
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
          is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 remote-as 64497/
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
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
        end
        it do
          is_expected.to_not contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'content' => '',
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            )
        end
        it do
          is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).without_content(
              /route-map outbound-64497/
            ).without_content(
              /route-map outbound-64497-v6/
            ).without_content(
              /set community/
            )
        end
      end

      describe 'Change Defaults' do
        context 'addr4 multible neighbours' do
          before { params.merge!( addr4: ['192.0.2.2', '192.0.2.3'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
          is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 remote-as 64497/
            ).with_content(
              /neighbor 192.0.2.2 description TEST Network/
            ).with_content(
              /neighbor 192.0.2.2 soft-reconfiguration inbound/
            ).with_content(
              /neighbor 192.0.2.2 prefix-list prefix-v4 out/
            ).with_content(
              /neighbor 192.0.2.2 prefix-list deny in/
            ).with_content(
              /neighbor 192.0.2.3 remote-as 64497/
            ).with_content(
              /neighbor 192.0.2.3 description TEST Network/
            ).with_content(
              /neighbor 192.0.2.3 soft-reconfiguration inbound/
            ).with_content(
              /neighbor 192.0.2.3 prefix-list prefix-v4 out/
            ).with_content(
              /neighbor 192.0.2.3 prefix-list deny in/
            )
          end
        end
        context 'addr6' do
          before { params.merge!( addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 2001:DB8::2 activate/
            ).with_content(
              /neighbor 2001:DB8::2 soft-reconfiguration inbound/
            ).with_content(
              /neighbor 2001:DB8::2 prefix-list prefix-v6 out/
            ).with_content(
              /neighbor 2001:DB8::2 prefix-list deny in/
            ).without_content(
              /neighbor 2001:DB8::2 route-map outbound-64497-v6 out/
            )
          end
        end
        context 'addr6 multible neighbours' do
          before { params.merge!( addr6: ['2001:DB8::2', '2001:DB8::3'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 2001:DB8::2 activate/
            ).with_content(
              /neighbor 2001:DB8::2 soft-reconfiguration inbound/
            ).with_content(
              /neighbor 2001:DB8::2 prefix-list prefix-v6 out/
            ).with_content(
              /neighbor 2001:DB8::2 prefix-list deny in/
            ).with_content(
              /neighbor 2001:DB8::3 activate/
            ).with_content(
              /neighbor 2001:DB8::3 soft-reconfiguration inbound/
            ).with_content(
              /neighbor 2001:DB8::3 prefix-list prefix-v6 out/
            ).with_content(
              /neighbor 2001:DB8::3 prefix-list deny in/
            )
          end
        end
        context 'inbound_routes all' do
          before { params.merge!( inbound_routes: 'all' ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).without_content(
              /neighbor 192.0.2.2 prefix-list deny in/
            ).without_content(
              /neighbor 192.0.2.2 prefix-list default-route in/
            ).with_content(
              /neighbor 192.0.2.2 prefix-list deny-default-route in/
            )
          end
        end
        context 'inbound_routes default' do
          before { params.merge!( inbound_routes: 'default' ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).without_content(
              /neighbor 192.0.2.2 prefix-list deny-default-route in/
            ).without_content(
              /neighbor 192.0.2.2 prefix-list deny in/
            ).with_content(
              /neighbor 192.0.2.2 prefix-list default-route in/
            )
          end
        end
        context 'inbound_routes default' do
          before { params.merge!( inbound_routes: 'v4default' ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).without_content(
              /neighbor 192.0.2.2 prefix-list deny-default-route in/
            ).without_content(
              /neighbor 192.0.2.2 prefix-list deny in/
            ).with_content(
              /neighbor 192.0.2.2 prefix-list default-route in/
            )
          end
        end
        context 'inbound_routes none with IPv6' do
          before { params.merge!( inbound_routes: 'none', addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 2001:DB8::2 prefix-list deny in/
            ).without_content(
              /neighbor 2001:DB8::2 prefix-list default-route in/
            ).without_content(
              /neighbor 2001:DB8::2 prefix-list deny-default-route in/
            )
          end
        end
        context 'inbound_routes default with IPv6' do
          before { params.merge!( inbound_routes: 'default', addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).without_content(
              /neighbor 2001:DB8::2 prefix-list deny in/
            ).with_content(
              /neighbor 2001:DB8::2 prefix-list default-route in/
            ).without_content(
              /neighbor 2001:DB8::2 prefix-list deny-default-route in/
            )
          end
        end
        context 'inbound_routes v6default with IPv6' do
          before { params.merge!( inbound_routes: 'v6default', addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).without_content(
              /neighbor 2001:DB8::2 prefix-list deny in/
            ).with_content(
              /neighbor 2001:DB8::2 prefix-list default-route in/
            ).without_content(
              /neighbor 2001:DB8::2 prefix-list deny-default-route in/
            )
          end
        end
        context 'inbound_routes all with IPv6' do
          before { params.merge!( inbound_routes: 'all', addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).without_content(
              /neighbor 2001:DB8::2 prefix-list deny in/
            ).without_content(
              /neighbor 2001:DB8::2 prefix-list default-route in/
            ).with_content(
              /neighbor 2001:DB8::2 prefix-list deny-default-route in/
            )
          end
        end
        context 'communities' do
          before { params.merge!( communities: ['666:666']) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).without_content(
              /no-export/
            ).with_content(
              /set community 666:666/
            )
          end
        end
        context 'communities NO_EXPORT' do
          before { params.merge!( communities: ['no-export']) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).with_content(
              /set community\s+no-export/
            )
          end
        end
        context 'communities multible' do
          before { params.merge!( communities: ['666:666', '111:111']) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).without_content(
              /no-export/
            ).with_content(
              /set community 666:666 111:111/
            )
          end
        end
        context 'communities multible with no export' do
          before { params.merge!( communities: ['no-export', '666:666']) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).with_content(
              /set community 666:666 no-export/
            )
          end
        end
        context 'communities with IPv6' do
          before { params.merge!( communities: ['666:666'], addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 2001:DB8::2 route-map outbound-64497-v6 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).without_content(
              /no-export/
            ).with_content(
              /set community 666:666/
            )
          end
        end
        context 'communities NO_EXPORT with IPv6' do
          before { params.merge!( communities: ['no-export'], addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 2001:DB8::2 route-map outbound-64497-v6 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).with_content(
              /set community\s+no-export/
            )
          end
        end
        context 'communities multible with IPv6' do
          before { params.merge!( communities: ['666:666', '111:111'], addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 2001:DB8::2 route-map outbound-64497-v6 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).without_content(
              /no-export/
            ).with_content(
              /set community 666:666 111:111/
            )
          end
        end
        context 'communities multible with no export with IPv6' do
          before { params.merge!( communities: ['no-export', '666:666'], addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 2001:DB8::2 route-map outbound-64497-v6 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
              .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).with_content(
              /set community 666:666 no-export/
            )
          end
        end
        context 'multihop' do
          before { params.merge!( multihop: 5 ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 ebgp-multihop 5/
            )
          end
        end
        context 'multihop with v6' do
          before { params.merge!( multihop: 5, addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 ebgp-multihop 5/
            ).with_content(
              /neighbor 2001:DB8::2 ebgp-multihop 5/
            )
          end
        end
        context 'password' do
          before { params.merge!( password: 'password' ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 password password/
            )
          end
        end
        context 'password with v6' do
          before { params.merge!( password: 'password', addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 password password/
            ).with_content(
              /neighbor 2001:DB8::2 password password/
            )
          end
        end
        context 'prepend' do
          before { params.merge!( prepend: 3 ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /set as-path prepend 64496 64496 64496/
            )
          end
        end
        context 'prepend with IPv6' do
          before { params.merge!( prepend: 3, addr6: ['2001:DB8::2'] ) }
          it { is_expected.to compile }
          # Add Check to validate change was successful
          it do
            is_expected.to contain_concat__fragment('bgpd_peer_64497')
            .with(
              'order'   => '10',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 192.0.2.2 route-map outbound-64497 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('bgpd_v6peer_64497')
            .with(
              'order'   => '40',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /neighbor 2001:DB8::2 route-map outbound-64497-v6 out/
            )
          end
          it do
            is_expected.to contain_concat__fragment('quagga_bgpd_routemap_64497')
            .with(
              'order'   => '90',
              'target'  => '/etc/quagga/bgpd.conf'
            ).with_content(
              /route-map outbound-64497 permit 10/
            ).with_content(
              /route-map outbound-64497-v6 permit 10/
            ).with_content(
              /set as-path prepend 64496 64496 64496/
            )
          end
        end
      end

      # You will have to correct any values that should be bool
      describe 'check bad type' do
        context 'addr4' do
          before { params.merge!( addr4: true ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'addr6' do
          before { params.merge!( addr6: true ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'desc' do
          before { params.merge!( desc: true ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'inbound_routes' do
          before { params.merge!( inbound_routes: true ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'inbound_routes incorrect string' do
          before { params.merge!( inbound_routes: 'foo' ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'communities' do
          before { params.merge!( communities: true ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'multihop' do
          before { params.merge!( multihop: true ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'password' do
          before { params.merge!( password: true ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
        context 'prepend' do
          before { params.merge!( prepend: true ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
