require 'spec_helper'

describe 'puppet_enterprise::profile::amq::broker' do
  context 'when default parameters' do
    it { should satisfy_all_relationships }
    it { should contain_class('puppet_enterprise::amq') }
    it { should contain_file('/etc/sysconfig/pe-activemq').with_content(/UseDedicatedTaskRunner=false/) }
  end

  context 'when managing certs' do
    it { should contain_file("/etc/puppetlabs/activemq/broker.ts").with_mode('0640') }
    it { should contain_file("/etc/puppetlabs/activemq/broker.ks").with_mode('0640') }
  end

  describe '#network_connector' do
    context 'when a single broker' do
      it { should_not contain_puppet_enterprise__amq__config__network_connector(/topic/) }
      it { should_not contain_puppet_enterprise__amq__config__network_connector(/queue/) }
    end

    context 'when hub and spoke' do
      let(:params) {{ :brokername => 'broker.localhost', :activemq_hubname => 'amq-hub.localhost' }}

      it { should contain_puppet_enterprise__amq__config__network_connector('broker.localhost to amq-hub.localhost-topic') }
      it { should contain_puppet_enterprise__amq__config__network_connector('broker.localhost to amq-hub.localhost-queue') }
    end
  end
end
