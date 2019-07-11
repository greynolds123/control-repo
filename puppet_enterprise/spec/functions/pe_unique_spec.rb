#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "pe_unique" do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("pe_unique")).to eq("function_pe_unique")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect(subject).to run.with_params().and_raise_error(Puppet::ParseError)
  end

  it "should remove duplicate elements in a string" do
    expect(subject).to run.with_params("aabbc").and_return('abc')
  end

  it "should remove duplicate elements in an array" do
    expect(subject).to run.with_params(["a","a","b","b","c"]).and_return(['a','b','c'])
  end
end
