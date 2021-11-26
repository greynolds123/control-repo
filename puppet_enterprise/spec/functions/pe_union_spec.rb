#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "pe_union" do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("pe_union")).to eq("function_pe_union")
  end

  it "should raise a ParseError if there are fewer than 2 arguments" do
    expect(subject).to run.with_params([]).and_raise_error(Puppet::ParseError)
  end

  it "should join two arrays together" do
    expect(subject).to run.with_params(["a","b","c"],["b","c","d"]).and_return(["a","b","c","d"])
  end
end
