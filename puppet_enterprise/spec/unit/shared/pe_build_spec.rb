#!/usr/bin/env rspec

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'shared/pe_build'

describe "pe_build fact helper" do
  include FakeFS::SpecHelpers

  before :each do
    Facter.clear
  end

  context "when PE is installed" do
    ['3.2.0', '3.2.0-rc0-209-gc832af7', '2015.10.99'].each do |version|
      context "version => #{version}" do
        before :each do
          FileUtils.mkdir_p('/opt/puppetlabs/server/')
          File.open("/opt/puppetlabs/server/pe_build", 'w') {|f| f.write(version) }
        end

        it "return the full PE version" do
          PEBuild.get_pe_build.should eq(version)
        end
      end
    end

    context "when the PE version is malformed" do
      ['3.2', '3', 'a.b.c', '3.2.rc9.100'].each do |version|
        context "version => #{version}" do
          before :each do
            FileUtils.mkdir_p('/opt/puppetlabs/server/')
            File.open("/opt/puppetlabs/server/pe_build", 'w') {|f| f.write(version) }
          end

          it "return the full PE version" do
            PEBuild.get_pe_build.should be_nil
          end
        end
      end
    end
  end

  context "when PE is not installed" do
    it "returns nil" do
      PEBuild.get_pe_build.should be_nil
    end
  end
end
