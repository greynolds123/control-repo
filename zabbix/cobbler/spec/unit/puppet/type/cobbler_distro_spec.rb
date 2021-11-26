describe Puppet::Type.type(:cobbler_distro) do
  # Validating parameters
  context "when validating parameters" do
    [
      :name,
      :path,
      :provider
    ].each do |param|
      it "should have a #{param} parameter" do
        expect(Puppet::Type.type(:cobbler_distro).attrtype(param)).to eq(:param)
      end
    end
  end
  # Valiadting properties
  context "when validating properties" do
    [
      :arch,
      :comment,
      :initrd,
      :kernel,
      :ksmeta,
      :owners,
    ].each do |prop|
      it "should have a #{prop} property" do
        expect(Puppet::Type.type(:cobbler_distro).attrtype(prop)).to eq(:property)
      end
    end
  end

  context "when validating parameters values" do
    it "raise error if path is not set" do
      expect {
        Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present
        )
      }.to raise_error(Puppet::ResourceError)
    end
    it "raise error if path is not an absolute path" do
      expect {
        Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => 'not/absoulte/path',
        )
      }.to raise_error(Puppet::ResourceError)
    end
    it "should support path parameter" do
      Puppet::Type.type(:cobbler_distro).new(
        :name   => "testdistro1",
        :ensure => :present,
        :path   => '/path/to/mnt',
      )
    end
    it "should support kernel and initrd parameters" do
      Puppet::Type.type(:cobbler_distro).new(
        :name   => "testdistro1",
        :ensure => :present,
        :initrd => '/path/to/initrd',
        :kernel => '/path/to/kernel',
      )
    end
    it "should support :present for ensure parameter" do
      Puppet::Type.type(:cobbler_distro).new(
        :name => "testdistro1",
        :ensure => :present,
        :path   => '/path/to/mnt',
      )
    end
    it "should support :absent for ensure parameter" do
      Puppet::Type.type(:cobbler_distro).new(
        :name => "testdistro1",
        :ensure => :absent,
        :path   => '/path/to/mnt',
      )
    end
  end

  context "when validating properties values" do
    context "arch" do
      [:i386, :x86_64, :ia64, :ppc, :ppc64, :s390, :arm].each do |arch|
        it "should support #{arch}" do
          Puppet::Type.type(:cobbler_distro).new(
            :name   => "testdistro1",
            :ensure => :present,
            :arch   => arch,
            :path   => '/path/to/mnt',
          )
        end
      end
    end
    context "owners" do
      it "should support array as a value" do
        Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => '/path/to/mnt',
          :owners => ['admin1', 'admin2'],
        )
      end
      it "should support string as a value" do
        Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => '/path/to/mnt',
          :owners => 'admin1'
        )
      end
      it "should default to ['admin']" do
        type = Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => '/path/to/mnt',
        )
        expect(type.should(:owners)).to eq([:admin])
      end
    end
    context "comment" do
      it "should support string as a value" do
        Puppet::Type.type(:cobbler_distro).new(
          :name    => "testdistro1",
          :ensure  => :present,
          :path    => '/path/to/mnt',
          :comment => 'test comment',
        )
      end
      it "should default to ''" do
        type = Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => '/path/to/mnt',
        )
        expect(type.should(:comment)).nil?
      end
    end
    context "kernel" do
      it "raise error if initrd or path is not set" do
        expect {
          Puppet::Type.type(:cobbler_distro).new(
            :name   => "testdistro1",
            :ensure => :present,
            :kernel => '/path/to/kernel',
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "raise error if not an absolute path" do
        expect {
          Puppet::Type.type(:cobbler_distro).new(
            :name   => "testdistro1",
            :ensure => :present,
            :kernel => 'not/absolute/path',
            :initrd => '/path/to/initrd',
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "support absolute path" do
        Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :kernel => '/path/to/kernel',
          :initrd => '/path/to/initrd',
        )
      end
      it "should default to nil" do
        type = Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => '/path/to/mnt',
        )
        expect(type.should(:kernel)).nil?
      end
    end
    context "ksmeta" do
      it "should support hash" do
        Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => '/path/to/mnt',
          :ksmeta => {'key': 'value'},
        )
      end
      it "should rise error if not a hash" do
        expect {
          Puppet::Type.type(:cobbler_distro).new(
            :name   => "testdistro1",
            :ensure => :present,
            :path   => '/path/to/mnt',
            :ksmeta => 'not_a_hash',
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "should default to {}" do
        type = Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => '/path/to/mnt',
        )
        expect(type.should(:ksmeta)).to eq({})
      end
    end
    context "initrd" do
      it "raise error if kernel or path is not set" do
        expect {
          Puppet::Type.type(:cobbler_distro).new(
            :name   => "testdistro1",
            :ensure => :present,
            :initrd => '/path/to/initrd',
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "raise error if not an absolute path" do
        expect {
          Puppet::Type.type(:cobbler_distro).new(
            :name   => "testdistro1",
            :ensure => :present,
            :initrd => 'not/absolute/path',
            :kernel => '/path/to/kernel',
          )
        }.to raise_error(Puppet::ResourceError)
      end
      it "support absolute path" do
        Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :kernel => '/path/to/kernel',
          :initrd => '/path/to/initrd',
        )
      end
      it "should default to nil" do
        type = Puppet::Type.type(:cobbler_distro).new(
          :name   => "testdistro1",
          :ensure => :present,
          :path   => '/path/to/mnt',
        )
        expect(type.should(:initrd)).nil?
      end
    end
  end

end
