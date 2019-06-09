require 'spec_helper_acceptance'

describe 'quagga class' do
  context 'defaults' do
    it 'should work with no errors' do 
      pp = 'class {\'::quagga\': }'
      apply_manifest(pp ,  :catch_failures => true)
      expect(apply_manifest(pp,  :catch_failures => true).exit_code).to eq 0
    end
    describe service('quagga') do
      it { is_expected.to be_running }
    end
  end
  context 'basic IPv4 peer' do
    it 'should work with no errors' do 
      pp = <<-EOF
    class { '::quagga': }
    class { '::quagga::bgpd': 
      my_asn => 64496,
      router_id => '192.0.2.1',
      networks4 => [ '192.0.2.0/24'],
      peers => {
        '64497' => {
          'addr4' => ['192.0.2.2'],
          'desc'  => 'TEST Network'
          }
      }
    }
    EOF
      apply_manifest(pp ,  :catch_failures => true)
      expect(apply_manifest(pp,  :catch_failures => true).exit_code).to eq 0
    end
    describe service('quagga') do
      it { is_expected.to be_running }
    end
    describe process('bgpd') do
      its(:user) { should eq 'quagga' }
      it { is_expected.to be_running }
    end
    describe port(179) do
      it { is_expected.to be_listening }
    end
    describe command('vtysh -c \'show ip bgp sum\'') do
      its(:stdout) { should match /192.0.2.2\s+4\s+64497/ }
    end
    describe command('vtysh -c \'show ipv6 bgp sum\'') do
      its(:stdout) { should match /No IPv6 neighbor is configured/ }
    end
  end
  context 'basic IPv6 peer' do
    it 'should work with no errors' do 
      pp = <<-EOF
    class { '::quagga': }
    class { '::quagga::bgpd': 
      my_asn => 64496,
      router_id => '192.0.2.1',
      networks6 => [ '2001:DB8::/48'],
      peers => {
        '64497' => {
          'addr6' => ['2001:DB8::2'],
          'desc'  => 'TEST Network'
          }
      }
    }
    EOF
      apply_manifest(pp ,  :catch_failures => true)
      expect(apply_manifest(pp,  :catch_failures => true).exit_code).to eq 0
    end
    describe service('quagga') do
      it { is_expected.to be_running }
    end
    describe process('bgpd') do
      its(:user) { should eq 'quagga' }
      it { is_expected.to be_running }
    end
    describe port(179) do
      it { is_expected.to be_listening }
    end
    describe command('vtysh -c \'show ip bgp sum\'') do
      its(:stdout) { should match /No IPv4 neighbor is configured/ }
    end
    describe command('vtysh -c \'show ipv6 bgp sum\'') do
      its(:stdout) { should match /2001:DB8::2\s+4\s+64497/i }
    end
  end
  context 'basic IPv6 & IPv4 peers' do
    it 'should work with no errors' do 
      pp = <<-EOF
    class { '::quagga': }
    class { '::quagga::bgpd': 
      my_asn => 64496,
      router_id => '192.0.2.1',
      networks4 => [ '192.0.2.0/24'],
      networks6 => [ '2001:DB8::/48'],
      peers => {
        '64497' => {
          'addr4' => ['192.0.2.2'],
          'addr6' => ['2001:DB8::2'],
          'desc'  => 'TEST Network'
          }
      }
    }
    EOF
      apply_manifest(pp ,  :catch_failures => true)
      expect(apply_manifest(pp,  :catch_failures => true).exit_code).to eq 0
    end
    describe service('quagga') do
      it { is_expected.to be_running }
    end
    describe process('bgpd') do
      its(:user) { should eq 'quagga' }
      it { is_expected.to be_running }
    end
    describe port(179) do
      it { is_expected.to be_listening }
    end
    describe command('vtysh -c \'show ip bgp sum\'') do
      its(:stdout) { should match /192.0.2.2\s+4\s+64497/ }
    end
    describe command('vtysh -c \'show ipv6 bgp sum\'') do
      its(:stdout) { should match /2001:DB8::2\s+4\s+64497/i }
    end
  end
end
