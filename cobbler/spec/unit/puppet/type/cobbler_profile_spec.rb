describe Puppet::Type.type(:cobbler_profile) do
  # Validating parameters
  context "when validating parameters" do
    [
      :name,
      :provider
    ].each do |param|
      it "should have a #{param} parameter" do
        expect(Puppet::Type.type(:cobbler_profile).attrtype(param)).to eq(:param)
      end
    end
  end
  # Valiadting properties
  context "when validating properties" do
    [
      :distro,
      :kickstart,
      :kopts,
      :kopts_post,
      :ksmeta,
      :repos,
      :dhcp_tag
    ].each do |prop|
      it "should have a #{prop} property" do
        expect(Puppet::Type.type(:cobbler_profile).attrtype(prop)).to eq(:property)
      end
    end
  end

  context "when validating parameters values" do
    context "ensure" do
      it "should support :present"  do
        Puppet::Type.type(:cobbler_profile).new(
          :name   => "testprofile1",
          :ensure => :present,
          :distro => "testdistro1",
        )
      end
      it "should support :absent" do
        Puppet::Type.type(:cobbler_profile).new(
          :name => "testprofile1",
          :ensure => :absent,
          :distro => "testdistro1",
        )
      end
    end
  end

  context "when validating properties values" do
    context "distro" do
      it "raise error if not set" do
        expect {
          Puppet::Type.type(:cobbler_profile).new(
            :name           => "testprofile1",
            :ensure         => :present,
          )
        }.to raise_error(Puppet::ResourceError)
      end
    end
    context "repos" do
      it "should support array value" do
        Puppet::Type.type(:cobbler_profile).new(
          :name   => "testprofile1",
          :ensure => :present,
          :distro => 'testdistro1',
          :repos  => ['testrepo1','testrepo2'],
        )
      end
      it "should support string value" do
        Puppet::Type.type(:cobbler_profile).new(
          :name   => "testprofile1",
          :ensure => :present,
          :distro => 'testdistro1',
          :repos  => 'testrepo1',
        )
      end
      it "should default to []" do
        type = Puppet::Type.type(:cobbler_profile).new(
          :name   => "testprofile1",
          :ensure => :present,
          :distro => 'testdistro1',
        )
        expect(type.should(:repos)).to eq([])
      end
    end
    context "dhcp_tag" do
      it "should support string value" do
        Puppet::Type.type(:cobbler_profile).new(
          :name     => "testprofile1",
          :ensure   => :present,
          :distro   => 'testdistro1',
          :dhcp_tag => 'testtag1',
        )
      end
      it "should default to 'default'" do
        type = Puppet::Type.type(:cobbler_profile).new(
          :name   => "testprofile1",
          :ensure => :present,
          :distro => 'testdistro1',
        )
        expect(type.should(:dhcp_tag)).to eq('default')
      end
    end
    [
      :kopts,
      :kopts_post,
      :ksmeta
    ].each do |param|
      context param do
        it "should support hash value" do
          Puppet::Type.type(:cobbler_profile).new(
            :name   => "testprofile1",
            :ensure => :present,
            :distro => 'testdistro1',
            param   =>  {'testkopt1' => '~','testkopt2' =>'testvalue2' },
          )
        end
        it "should raise error if not a hash " do
          expect {
            Puppet::Type.type(:cobbler_profile).new(
              :name   => "testprofile1",
              :ensure => :present,
              :distro => 'testdistro1',
              param   => 'not/a/hash',
            )
          }.to raise_error(Puppet::ResourceError)
        end
        it "should default to {}" do
          type = Puppet::Type.type(:cobbler_profile).new(
            :name   => "testprofile1",
            :ensure => :present,
            :distro => 'testdistro1',
          )
          expect(type.should(param)).to eq({})
        end
      end
    end
    [
      :virt_cpus,
      :virt_ram
    ].each do |param|
      context param do
        it "should support integer value" do
            Puppet::Type.type(:cobbler_profile).new(
              :name   => "testprofile1",
              :ensure => :present,
              :distro => 'testdistro1',
              param   => 1,
            )
        end
        it "should raise error if not an integer" do
            expect {
              Puppet::Type.type(:cobbler_profile).new(
                :name   => "testprofile1",
                :ensure => :present,
                :distro => 'testdistro1',
                param   => 'not_an_integer',
              )
            }.to raise_error(Puppet::ResourceError)
        end
        it "should default to nil" do
          type = Puppet::Type.type(:cobbler_profile).new(
            :name   => "testprofile1",
            :ensure => :present,
            :distro => 'testdistro1',
          )
          expect(type.should(param)).nil?
        end
      end
    end
    context "virt_type" do
      [:xenpv, :xenfv, :qemu, :kvm, :vmware,:openvz].each do |value|
        it "should support #{value}" do
          Puppet::Type.type(:cobbler_profile).new(
            :name      => "testprofile1",
            :ensure    => :present,
            :distro    => 'testdistro1',
            :virt_type => value,
          )
        end
      end
      it "should raise error if not valid value" do
        expect {
          Puppet::Type.type(:cobbler_profile).new(
            :name      => "testprofile1",
            :ensure    => :present,
            :distro    => 'testdistro1',
            :virt_type => 'not_valid_value',
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "should default to nil" do
        type = Puppet::Type.type(:cobbler_profile).new(
          :name   => "testprofile1",
          :ensure => :present,
          :distro => 'testdistro1',
        )
        expect(type.should(:virt_type)).nil?
      end
    end
  end
end
