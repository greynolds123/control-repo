#!/usr/bin/env ruby

require 'spec_helper'
require 'puppet/face'

describe "node face: purge" do
  let(:subject) {

  Puppet::Face.define(:node, :current) do
    action :deactivate do
      when_invoked do |*args|
      end
    end

    action :clean do
      when_invoked do |*args|
      end
    end
  end }

  it "should fail if no node is given" do
    expect { subject.purge }.to raise_error ArgumentError, /provide at least one node/
  end

  it "should quit with message if deactivate does not exist" do
    Puppet::Interface.stubs(:find_action).returns(nil)
    expect{subject.purge("meow")}.to raise_error(RuntimeError, /cannot be run/)
  end

  it "should call the deactivate command" do
    subject.expects(:deactivate).with("meow")
    subject.purge("meow")
  end

  it "should call the clean command" do
    subject.expects(:clean).with("meow")
    subject.purge("meow")
  end

  it "should output instructions when it is finished" do
    purge = subject.get_action(:purge)
    maybe = purge.when_rendering(:console).call(["meow"])
    expect(maybe).to match(/"meow" was purged/)
  end
end
