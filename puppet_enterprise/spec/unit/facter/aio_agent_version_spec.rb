#!/usr/bin/env rspec

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'facter/aio_agent_version'

describe "aio_agent_version fact helper" do
  include FakeFS::SpecHelpers

  before :each do
    Facter.flush
  end

  context "when a developer puppet agent is installed" do
    ['1.1.0.110.1', '1.1.0.110.1.g123123'].each do |version|
      context "version => #{version}" do
        before :each do
          FileUtils.mkdir_p('/opt/puppetlabs/puppet/')
          File.open("/opt/puppetlabs/puppet/VERSION", 'w') {|f| f.write(version) }
        end

        it "return the full puppet agent version" do
          AIOAgentVersionCustomFact.get_aio_agent_version.should eq('1.1.0.110.1')
        end
      end
    end
  end

  context "when a released puppet agent is installed" do
    before :each do
      FileUtils.mkdir_p('/opt/puppetlabs/puppet/')
      File.open("/opt/puppetlabs/puppet/VERSION", 'w') {|f| f.write('1.1.0.0') }
    end

    it "return the full puppet agent version" do
      AIOAgentVersionCustomFact.get_aio_agent_version.should eq('1.1.0.0')
    end
  end

  context "when the puppet agent version is malformed" do
    ['3.2', '3', 'a.b.c', '3.2.rc9.100'].each do |version|
      context "version => #{version}" do
        before :each do
          FileUtils.mkdir_p('/opt/puppetlabs/puppet/')
          File.open("/opt/puppetlabs/puppet/VERSION", 'w') {|f| f.write(version) }
        end

        it "return nil" do
          AIOAgentVersionCustomFact.get_aio_agent_version.should be_nil
        end
      end
    end
  end

  context "when puppet agent is not installed" do
    it "returns nil" do
      AIOAgentVersionCustomFact.get_aio_agent_version.should be_nil
    end
  end
end
