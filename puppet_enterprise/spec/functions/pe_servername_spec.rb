#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "pe_servername" do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("pe_servername")).to eq("function_pe_servername")
  end

  it "should raise a ParseError if there are arguments" do
    expect(subject).to run.with_params(['1']).and_raise_error(Puppet::ParseError)
  end

  it "should return nil if servername is unset" do
    expect(subject).to run.with_params().and_return(nil)
  end

  context "servername is set" do
    servername = 'foobar'
    before(:each) {
      scope.expects(:exist?).with('servername').returns(true)
      scope.expects(:lookupvar).with('servername').returns(servername)
    }

    it "should return servername" do
      expect(subject).to run.with_params().and_return(servername)
    end
  end
end
