#!/usr/bin/env rspec

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'shared/aio_build'

describe "aio_build fact helper" do
  include FakeFS::SpecHelpers

  before :each do
    Facter.clear
  end

  context "when puppet agent is installed" do
    ['1.1.0.110', '1.1.0.111.g123123'].each do |version|
      context "version => #{version}" do
        before :each do
          FileUtils.mkdir_p('/opt/puppetlabs/puppet/')
          File.open("/opt/puppetlabs/puppet/VERSION", 'w') {|f| f.write(version) }
        end

        it "return the full puppet agent version" do
          AIOAgentBuild.get_aio_build.should eq(version)
        end
      end
    end
  end

  context "when puppet agent is not installed" do
    it "returns nil" do
      AIOAgentBuild.get_aio_build.should be_nil
    end
  end
end
