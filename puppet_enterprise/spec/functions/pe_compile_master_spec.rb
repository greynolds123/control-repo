#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "pe_compile_master" do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("pe_compile_master")).to eq("function_pe_compile_master")
  end

  it "should raise a ParseError if there are arguments" do
    expect(subject).to run.with_params('1').and_raise_error(Puppet::ParseError)
  end

  context "with servername/fqdn mocked" do
    let(:fqdn) { nil }
    let(:servername) { nil }

    before(:each) {
      scope.expects(:function_pe_servername).with([]).returns(servername)
      scope.expects(:lookupvar).with('fqdn').returns(fqdn)
    }

    context "servername unset, fqdn set" do
      let(:fqdn) { 'foobar' }
      let(:servername) { nil }

      it "should return true" do
        expect(subject).to run.with_params().and_return(false)
      end
    end

    context "servername is the same as fqdn" do
      let(:fqdn) { 'foobar' }
      let(:servername) { 'foobar' }

      it "should return false" do
        expect(subject).to run.with_params().and_return(false)
      end
    end

    context "servername is different from fqdn" do
      let(:fqdn) { 'foobar' }
      let(:servername) { 'bazbaz' }

      it "should return false" do
        expect(subject).to run.with_params().and_return(true)
      end
    end

    context "servername is set, fqdn unset" do
      let(:fqdn) { nil }
      let(:servername) { 'bazbaz' }

      it "should raise a ParseError" do
        scope.unstub(:function_pe_servername)
        expect(subject).to run.with_params().and_raise_error(Puppet::ParseError)
      end
    end
  end
end
