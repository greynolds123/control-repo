#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "cookie_secret_key" do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("cookie_secret_key")).to eq("function_cookie_secret_key")
  end

  it "should return a 16 character string with no arguments specified" do
    expect(subject).to run.with_params(nil).and_return(/\w{16}/)
  end

  it "should return a string with the length specified" do
    expect(subject).to run.with_params(32).and_return(/\w{32}/)
  end
end
