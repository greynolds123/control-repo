<<<<<<< HEAD
#!/usr/bin/env rspec

require 'spec_helper'

describe "PE Version specs" do
=======
require 'spec_helper'

describe 'PE Version specs' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  before :each do
    # Explicitly load the pe_version.rb file which contains generated facts
    # that cannot be automatically loaded.  Puppet 2.x implements
    # Facter.collection.load while Facter 1.x markes Facter.collection.load as
    # a private method.
    if Facter.collection.respond_to? :load
      Facter.collection.load(:pe_version)
    else
      Facter.collection.loader.load(:pe_version)
    end
  end
<<<<<<< HEAD
  
  context "When puppetversion is nil" do
    before :each do
      Facter.fact(:puppetversion).stubs(:value).returns(nil)
    end
    
    it "pe_version is nil" do
      expect(Facter.fact(:puppetversion).value).to be_nil
=======

  context 'when puppetversion is nil' do
    before :each do
      Facter.fact(:puppetversion).stubs(:value).returns(nil)
    end

    it 'puppetversion is nil' do
      expect(Facter.fact(:puppetversion).value).to be_nil
    end

    it 'pe_version is nil' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      expect(Facter.fact(:pe_version).value).to be_nil
    end
  end

<<<<<<< HEAD
  context "If PE is installed" do
    %w{ 2.6.1 2.10.300 }.each do |version|
=======
  context 'when PE is installed' do
    %w[2.6.1 2.10.300].each do |version|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      puppetversion = "2.7.19 (Puppet Enterprise #{version})"
      context "puppetversion => #{puppetversion}" do
        before :each do
          Facter.fact(:puppetversion).stubs(:value).returns(puppetversion)
        end

<<<<<<< HEAD
        (major,minor,patch) = version.split(".")

        it "Should return true" do
=======
        (major, minor, patch) = version.split('.')

        it 'returns true' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
          expect(Facter.fact(:is_pe).value).to eq(true)
        end

        it "Should have a version of #{version}" do
          expect(Facter.fact(:pe_version).value).to eq(version)
        end

        it "Should have a major version of #{major}" do
          expect(Facter.fact(:pe_major_version).value).to eq(major)
        end

        it "Should have a minor version of #{minor}" do
          expect(Facter.fact(:pe_minor_version).value).to eq(minor)
        end

        it "Should have a patch version of #{patch}" do
          expect(Facter.fact(:pe_patch_version).value).to eq(patch)
        end
      end
    end
  end

<<<<<<< HEAD
  context "When PE is not installed" do
    before :each do
      Facter.fact(:puppetversion).stubs(:value).returns("2.7.19")
    end

    it "is_pe is false" do
      expect(Facter.fact(:is_pe).value).to eq(false)
    end

    it "pe_version is nil" do
      expect(Facter.fact(:pe_version).value).to be_nil
    end

    it "pe_major_version is nil" do
      expect(Facter.fact(:pe_major_version).value).to be_nil
    end

    it "pe_minor_version is nil" do
      expect(Facter.fact(:pe_minor_version).value).to be_nil
    end

    it "Should have a patch version" do
      expect(Facter.fact(:pe_patch_version).value).to be_nil
    end
  end

=======
  context 'when PE is not installed' do
    before :each do
      Facter.fact(:puppetversion).stubs(:value).returns('2.7.19')
    end

    it 'is_pe is false' do
      expect(Facter.fact(:is_pe).value).to eq(false)
    end

    it 'pe_version is nil' do
      expect(Facter.fact(:pe_version).value).to be_nil
    end

    it 'pe_major_version is nil' do
      expect(Facter.fact(:pe_major_version).value).to be_nil
    end

    it 'pe_minor_version is nil' do
      expect(Facter.fact(:pe_minor_version).value).to be_nil
    end

    it 'has a patch version' do
      expect(Facter.fact(:pe_patch_version).value).to be_nil
    end
  end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
