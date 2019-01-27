<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'abs function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should accept a string' do
      pp = <<-EOS
      $input  = '-34.56'
      $output = abs($input)
      notify { "$output": }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: 34.56/)
      end
    end

    it 'should accept a float' do
      pp = <<-EOS
      $input  = -34.56
      $output = abs($input)
      notify { "$output": }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: 34.56/)
=======
require 'spec_helper_acceptance'

describe 'abs function' do
  describe 'success' do
    pp1 = <<-DOC
      $input  = '-34.56'
      $output = abs($input)
      notify { "$output": }
    DOC
    it 'accepts a string' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: 34.56})
      end
    end

    pp2 = <<-DOC
      $input  = -35.46
      $output = abs($input)
      notify { "$output": }
    DOC
    it 'accepts a float' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: 35.46})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
end
