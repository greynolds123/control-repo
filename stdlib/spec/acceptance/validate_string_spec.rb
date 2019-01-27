<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'validate_string function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'validates a single argument' do
      pp = <<-EOS
      $one = 'string'
      validate_string($one)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates an multiple arguments' do
      pp = <<-EOS
      $one = 'string'
      $two = 'also string'
      validate_string($one,$two)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates undef' do
      pp = <<-EOS
      validate_string(undef)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates a non-string' do
      {
        %{validate_string({ 'a' => 'hash' })} => "Hash",
        %{validate_string(['array'])}         => "Array",
        %{validate_string(false)}             => "FalseClass",
      }.each do |pp,type|
        expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/a #{type}/)
=======
require 'spec_helper_acceptance'

describe 'validate_string function' do
  describe 'success' do
    pp1 = <<-DOC
      $one = 'string'
      validate_string($one)
    DOC
    it 'validates a single argument' do
      apply_manifest(pp1, :catch_failures => true)
    end

    pp2 = <<-DOC
      $one = 'string'
      $two = 'also string'
      validate_string($one,$two)
    DOC
    it 'validates an multiple arguments' do
      apply_manifest(pp2, :catch_failures => true)
    end

    pp3 = <<-DOC
      validate_string(undef)
    DOC
    it 'validates undef' do
      apply_manifest(pp3, :catch_failures => true)
    end

    {
      %{validate_string({ 'a' => 'hash' })} => 'Hash',
      %{validate_string(['array'])}         => 'Array',
      %{validate_string(false)}             => 'FalseClass',
    }.each do |pp4, type|
      it "validates a non-string: #{pp4.inspect}" do
        expect(apply_manifest(pp4, :expect_failures => true).stderr).to match(%r{a #{type}})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments'
  end
end
