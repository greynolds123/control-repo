#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe 'pe_sort' do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("pe_sort")).to eq("function_pe_sort")
  end

  it "should raise a ParseError if there is less than 1 argument" do
    expect(subject).to run.with_params().and_raise_error(Puppet::ParseError)
  end

  it "should sort elements in a string" do
    expect(subject).to run.with_params("cbda").and_return('abcd')
  end

  it "should sort elements in an array" do
    expect(subject).to run.with_params(["c", "b", "a"]).and_return(['a','b','c'])
  end
end
