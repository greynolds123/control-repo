require 'spec_helper'

describe 'puppet_enterprise::amq::certs', :type => :class do
  context 'on a supported platform' do
    let(:facts) do
      {
        :osfamily   => 'RedHat',
        :fqdn       => 'test.domain.local',
        :clientcert => 'test.domain.local',
      }
    end

    describe 'when using default values' do
      let(:params) do
        {
          :brokername => 'test.domain.local'
        }
      end

      it { should contain_file('/etc/puppetlabs/activemq/broker.ts') }
      it { should contain_file('/etc/puppetlabs/activemq/broker.ks') }

      it { should contain_pe_java_ks('puppetca:truststore').with(
        'certificate' => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        'target'      => '/etc/puppetlabs/activemq/broker.ts',
      )}

      it { should contain_pe_java_ks('test.domain.local:keystore').with(
        'certificate' => '/etc/puppetlabs/puppet/ssl/certs/test.domain.local.pem',
        'private_key' => '/etc/puppetlabs/puppet/ssl/private_keys/test.domain.local.pem',
        'target'      => '/etc/puppetlabs/activemq/broker.ks',
      )}
    end
  end
end
