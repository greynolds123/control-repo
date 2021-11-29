describe Puppet::Type.type(:cobbler_system) do
  # Validating parameters
  context "when validating parameters" do
    [
      :name,
      :provider
    ].each do |param|
      it "should have a #{param} parameter" do
        expect(Puppet::Type.type(:cobbler_system).attrtype(param)).to eq(:param)
      end
    end
  end
  # Valiadting properties
  context "when validating properties" do
    [
      :hostname,
      :interfaces,
      :profile,
      :redhat_management_key,
      :redhat_management_server,
      :server,
      :netboot_enabled,
    ].each do |prop|
      it "should have a #{prop} property" do
        expect(Puppet::Type.type(:cobbler_system).attrtype(prop)).to eq(:property)
      end
    end
  end

  context "when validating parameters values" do
    context "ensure" do
      it "should support :present"  do
        Puppet::Type.type(:cobbler_system).new(
          :name    => "testsystem1",
          :ensure  => :present,
          :profile => "testprofile1",
        )
      end
      it "should support :absent" do
        Puppet::Type.type(:cobbler_system).new(
          :name    => "testsystem1",
          :ensure  => :absent,
          :profile => "testprofile1",
        )
      end
    end
  end

  context "when validating properties values" do
    context "profile" do
      it "raise error if not set" do
        expect {
          Puppet::Type.type(:cobbler_system).new(
            :name           => "testsystem1",
            :ensure         => :present,
          )
        }.to raise_error(Puppet::ResourceError)
      end
    end
    context "interfaces" do
      it "should suppot hash" do
        Puppet::Type.type(:cobbler_system).new(
          :name             => "testsystem1",
          :ensure           => :present,
          :profile          => 'testprofile1',
          :interfaces       => {
            'eth0'          => {
              'ip_address'  => '192.168.0.2',
              'if_gateway'  => '192.168.0.1',
              'netmask'     => '255.255.255.0',
              'mac_address' => '52:54:00:00:38:78',
            },
            'eth1' => {
              'ip_address'  => '192.168.1.2',
              'if_gateway'  => '192.168.1.1',
              'netmask'     => '255.255.255.0',
              'mac_address' => '52:54:00:00:38:79',
            }
          }
        )
      end
      it "should raise error if not valid ip_address" do
        expect {
          Puppet::Type.type(:cobbler_system).new(
            :name             => "testsystem1",
            :ensure           => :present,
            :profile          => 'testprofile1',
            :interfaces       => {
              'eth0'          => {
                'ip_address'  => 'not_valid_ip_address',
                'if_gateway'  => '192.168.0.1',
                'netmask'     => '255.255.255.0',
                'mac_address' => '52:54:00:00:38:78',
              },
            }
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "should raise error if not valid if_gateway" do
        expect {
          Puppet::Type.type(:cobbler_system).new(
            :name             => "testsystem1",
            :ensure           => :present,
            :profile          => 'testprofile1',
            :interfaces       => {
              'eth0'          => {
                'ip_address'  => '192.168.0.2',
                'if_gateway'  => 'not_valid_gateway',
                'netmask'     => '255.255.255.0',
                'mac_address' => '52:54:00:00:38:78',
              },
            }
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "should raise error if not valid netmask" do
        expect {
          Puppet::Type.type(:cobbler_system).new(
            :name             => "testsystem1",
            :ensure           => :present,
            :profile          => 'testprofile1',
            :interfaces       => {
              'eth0'          => {
                'ip_address'  => '192.168.0.2',
                'if_gateway'  => '192.168.0.1',
                'netmask'     => 'not_valid_netmask',
                'mac_address' => '52:54:00:00:38:78',
              },
            }
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "should raise error if not valid mac_address" do
        expect {
          Puppet::Type.type(:cobbler_system).new(
            :name             => "testsystem1",
            :ensure           => :present,
            :profile          => 'testprofile1',
            :interfaces       => {
              'eth0'          => {
                'ip_address'  => '192.168.0.2',
                'if_gateway'  => '192.168.0.1',
                'netmask'     => '255.255.255.0',
                'mac_address' => 'not_valid_mac_address',
              },
            }
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "should default to {}" do
        type = Puppet::Type.type(:cobbler_system).new(
          :name    => "testsystem1",
          :ensure  => :present,
          :profile => 'testprofile1',
        )
        expect(type.should("interfaces")).to eq({})
      end

    end
    context "netboot enabled" do
      it "should support :true" do
        Puppet::Type.type(:cobbler_system).new(
          :name            => "testsystem1",
          :ensure          => :present,
          :profile         => 'testprofile1',
          :netboot_enabled => :true,
        )
      end
      it "should support :false" do
        Puppet::Type.type(:cobbler_system).new(
          :name            => "testsystem1",
          :ensure          => :present,
          :profile         => 'testprofile1',
          :netboot_enabled => :true,
        )
      end
      it "raise error if any other value" do
        expect {
          Puppet::Type.type(:cobbler_system).new(
            :name            => "testsystem1",
            :ensure          => :present,
            :profile         => 'testprofile1',
            :netboot_enabled => 'not_true_or_false'
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "should default to nil" do
        type = Puppet::Type.type(:cobbler_system).new(
          :name    => "testsystem1",
          :ensure  => :present,
          :profile => 'testprofile1',
        )
        expect(type.should(:netboot_enabled)).nil?
      end
    end
    [
      :hostname,
      :redhat_management_key,
      :redhat_management_server,
      :server
    ].each do |param|
      context param do
        it "should support string value" do
          Puppet::Type.type(:cobbler_system).new(
            :name        => "testsystem1",
            :ensure      => :present,
            :profile     => 'testprofile1',
            param.intern => "test#{param}1",
          )
        end
        it "should default to ''" do
          type = Puppet::Type.type(:cobbler_system).new(
            :name    => "testsystem1",
            :ensure  => :present,
            :profile => 'testprofile1',
          )
          expect(type.should(param.intern)).nil?
        end
      end
    end
  end
end
