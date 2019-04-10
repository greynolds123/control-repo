require 'spec_helper_acceptance'


describe 'quagga class multi router' do
  router1 = find_host_with_role(:router1)
  router2 = find_host_with_role(:router2)
  router1_ip = fact_on(router1, "ipaddress")
  router1_ip6 = '2001:db8:1::1'
  router1_asn = 64496
  router2_ip = fact_on(router2, "ipaddress")
  router2_ip6 = '2001:db8:1::2'
  router2_asn = 64497
  ipv6_network = '2001:db8:1::/64'
  ipv4_network = router1_ip.sub(/\d+$/,'0/24')
  on(router1, "ip -6 addr add #{router1_ip6}/64 dev eth0", :acceptable_exit_codes => [0,2])
  on(router2, "ip -6 addr add #{router2_ip6}/64 dev eth0", :acceptable_exit_codes => [0,2])
  context 'basic' do
    it 'should work with no errors' do 
      pp1 = <<-EOF
    class { '::quagga': }
    class { '::quagga::bgpd': 
      my_asn => #{router1_asn},
      router_id => '#{router1_ip}',
      networks4 => [ '#{ipv4_network}'],
      networks6 => [ '#{ipv6_network}'],
      peers => {
        '#{router2_asn}' => {
          'addr4' => ['#{router2_ip}'],
          'addr6' => ['#{router2_ip6}'],
          'desc'  => 'TEST Network'
          }
      }
    }
    EOF
      pp2 = <<-EOF
    class { '::quagga': }
    class { '::quagga::bgpd': 
      my_asn => #{router2_asn},
      router_id => '#{router2_ip}',
      networks4 => [ '#{ipv4_network}'],
      networks6 => [ '#{ipv6_network}'],
      peers => {
        '#{router1_asn}' => {
          'addr4' => ['#{router1_ip}'],
          'addr6' => ['#{router1_ip6}'],
          'desc'  => 'TEST Network'
          }
      }
    }
    EOF
      apply_manifest(pp1 ,  :catch_failures => true)
      apply_manifest_on(router2, pp2 ,  :catch_failures => true)
      expect(apply_manifest(pp1,  :catch_failures => true).exit_code).to eq 0
      expect(apply_manifest_on(router2, pp2,  :catch_failures => true).exit_code).to eq 0
      #allow peers to configure and establish
      sleep(10)
    end
    describe command('cat /etc/quagga/bgpd.conf 2>&1' ) do
      its(:stdout) { should match(//) }
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
    describe command("ping -c 1 #{router2_ip}") do 
      its(:exit_status) { should eq 0 }
    end
    describe command("ping6 -I eth0 -c 1 #{router2_ip6}") do 
      its(:exit_status) { should eq 0 }
    end
    describe command('vtysh -c \'show ip bgp sum\'') do
      its(:stdout) { should match(/#{router2_ip}\s+4\s+#{router2_asn}/) }
    end
    describe command("vtysh -c \'show ip bgp neighbors #{router2_ip}\'") do
      its(:stdout) { should match(/BGP state = Established/) }
    end
    describe command("vtysh -c \'show ip bgp neighbors #{router2_ip} advertised-routes\'") do
      its(:stdout) { should match(/#{ipv4_network}\s+#{router1_ip}\s+0\s+32768\s+i/) }
    end
    describe command('vtysh -c \'show ipv6 bgp sum\'') do
      its(:stdout) { should match(/#{router2_ip6}\s+4\s+#{router2_asn}/i) }
    end
    describe command("vtysh -c \'show ip bgp neighbors #{router2_ip6}\'") do
      its(:stdout) { should match(/BGP state = Established/) }
    end
    describe command("vtysh -c \'show ipv6 bgp neighbors #{router2_ip6} advertised-routes\'") do
      its(:stdout) { should match(/#{ipv6_network}\s+#{router1_ip6}\s+0\s+32768\s+i/) }
    end
  end
end
