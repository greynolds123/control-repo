<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'suffix function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'suffixes array of values' do
      pp = <<-EOS
      $o = suffix(['a','b','c'],'p')
      notice(inline_template('suffix is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/suffix is \["ap", "bp", "cp"\]/)
      end
    end
    it 'suffixs with empty array' do
      pp = <<-EOS
      $o = suffix([],'p')
      notice(inline_template('suffix is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/suffix is \[\]/)
      end
    end
    it 'suffixs array of values with undef' do
      pp = <<-EOS
      $o = suffix(['a','b','c'], undef)
      notice(inline_template('suffix is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/suffix is \["a", "b", "c"\]/)
=======
require 'spec_helper_acceptance'

describe 'suffix function' do
  describe 'success' do
    pp1 = <<-DOC
      $o = suffix(['a','b','c'],'p')
      notice(inline_template('suffix is <%= @o.inspect %>'))
    DOC
    it 'suffixes array of values' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{suffix is \["ap", "bp", "cp"\]})
      end
    end

    pp2 = <<-DOC
      $o = suffix([],'p')
      notice(inline_template('suffix is <%= @o.inspect %>'))
    DOC
    it 'suffixs with empty array' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{suffix is \[\]})
      end
    end

    pp3 = <<-DOC
      $o = suffix(['a','b','c'], undef)
      notice(inline_template('suffix is <%= @o.inspect %>'))
    DOC
    it 'suffixs array of values with undef' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{suffix is \["a", "b", "c"\]})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'fails with no arguments'
    it 'fails when first argument is not array'
    it 'fails when second argument is not string'
  end
end
