#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "pe_create_amq_augeas_command" do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("pe_create_amq_augeas_command")).to eq("function_pe_create_amq_augeas_command")
  end

  it "should raise a ParseError if there are fewer than 4 arguments" do
    expect(subject).to run.with_params(['1','2','3']).and_raise_error(Puppet::ParseError)
  end

  it "should raise a ParseError if the first argument is not a string" do
    expect(subject).to run.with_params([1,'2','3','4']).and_raise_error(Puppet::ParseError)
  end

  it "should raise a ParseError if the second argument is not an array" do
    expect(subject).to run.with_params(['1','2','3',['4']]).and_raise_error(Puppet::ParseError)
  end

  it "should raise a ParseError if the third argument is not a string" do
    expect(subject).to run.with_params(['1',['2'],3,['4']]).and_raise_error(Puppet::ParseError)
  end

  it "should raise a ParseError if the fourth argument is not an array" do
    expect(subject).to run.with_params(['1',['2'],'3','4']).and_raise_error(Puppet::ParseError)
  end

  it "should raise a ParseError if the second and fourth argument are not the same size array" do
    expect(subject).to run.with_params(['1',['2'],'3',['4', '5']]).and_raise_error(Puppet::ParseError)
  end

  it "should create an array of augeas commands without selectors" do
    context = 'fakeContext/element'
    attribute = 'name'
    values = ['foo', 'bar']
    expect(subject).to run.with_params(context, nil, attribute, values).and_return([
      'set fakeContext/element/#attribute/name foo',
      'set fakeContext/element/#attribute/name bar'
    ])
  end

  it "should create an array of augeas commands with selectors" do
    context = 'fakeContext/element'
    selectors = ['#attribute/name=foo', '#attribute/name=bar']
    attribute = 'name'
    values = ['foo', 'bar']

    expect(subject).to run.with_params(context, selectors, attribute, values).and_return([
      'set fakeContext/element[#attribute/name=foo]/#attribute/name foo',
      'set fakeContext/element[#attribute/name=bar]/#attribute/name bar'
    ])
  end
end
