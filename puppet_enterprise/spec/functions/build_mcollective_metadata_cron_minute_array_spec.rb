#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "build_mcollective_metadata_cron_minute_array" do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("build_mcollective_metadata_cron_minute_array")).to eq("function_build_mcollective_metadata_cron_minute_array")
  end

  it "should raise a ParseError if there are fewer than 2 arguments" do
    expect(subject).to run.with_params(1).and_raise_error(Puppet::ParseError)
  end

  it "should raise a ParseError if there are more than 2 arguments" do
    expect(subject).to run.with_params(1,2,3).and_raise_error(Puppet::ParseError)
  end

  it "should return correctly" do
    expect(subject).to run.with_params(15, 1).and_return([1,16,31,46])
  end

  it "should return correctly 2" do
    expect(subject).to run.with_params(18, 3).and_return([3,21,39])
  end

  it "should return correctly 3" do
    expect(subject).to run.with_params(35, 8).and_return([8])
  end

  it "should return correctly 4" do
    expect(subject).to run.with_params(10, 4).and_return([4,14,24,34,44,54])
  end
end
