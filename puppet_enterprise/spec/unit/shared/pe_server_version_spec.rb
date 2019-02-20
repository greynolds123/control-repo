#!/usr/bin/env rspec

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'shared/pe_server_version'

describe "pe_server_version fact helper" do
  include FakeFS::SpecHelpers

  before :each do
    Facter.clear
  end

  context "when PE is installed" do
    ['3.2.0', '4.0.0'].each do |version|
      context "version => #{version}" do
        before :each do
          FileUtils.mkdir_p('/opt/puppetlabs/server/')
          File.open("/opt/puppetlabs/server/pe_version", 'w') {|f| f.write(version) }
        end

        it "return the full PE version" do
          PEServerVersion.get_pe_server_version.should eq(version)
        end
      end
    end
  end

  context "when PE is not installed" do
    it "returns nil" do
      PEServerVersion.get_pe_server_version.should be_nil
    end
  end
end
