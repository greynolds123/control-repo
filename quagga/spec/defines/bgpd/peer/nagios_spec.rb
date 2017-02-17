require 'spec_helper'
require 'shared_contexts'

describe 'quagga::bgpd::peer::nagios' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  let(:title) { '192.0.2.2' }
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      routes: ['192.0.2.0/24', '10.0.0.0/24']
    }
  end
  let(:node) { 'foo.example.com' }
  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      describe 'check default config' do
        subject { exported_resources }
        # add these two lines in a single test block to enable puppet and hiera debug mode
        # Puppet::Util::Log.level = :debug
        # Puppet::Util::Log.newdestination(:console)
        it do
          is_expected.to compile.with_all_deps
        end

        it do
          is_expected.to contain_nagios_service('foo.example.com_BGP_NEIGHBOUR_192.0.2.2')
            .with(
              'check_command'       => 'check_nrpe_args!check_bgp!192.0.2.2!192.0.2.0/24 10.0.0.0/24',
              'ensure'              => 'present',
              'host_name'           => 'foo.example.com',
              'service_description' => 'BGP_NEIGHBOUR_192.0.2.2',
              'use'                 => 'generic-service'

            )
        end
      end

      # You will have to correct any values that should be bool
      describe 'check bad type' do
        context 'routes' do
          before { params.merge!( routes: false ) }
          it { expect { subject.call }.to raise_error(Puppet::Error) }
        end
      end
    end
  end
end
