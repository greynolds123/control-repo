<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'validate_re function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'validates a string' do
      pp = <<-EOS
      $one = 'one'
      $two = '^one$'
      validate_re($one,$two)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates an array' do
      pp = <<-EOS
      $one = 'one'
      $two = ['^one$', '^two']
      validate_re($one,$two)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates a failed array' do
      pp = <<-EOS
      $one = 'one'
      $two = ['^two$', '^three']
      validate_re($one,$two)
      EOS

      apply_manifest(pp, :expect_failures => true)
    end
    it 'validates a failed array with a custom error message' do
      pp = <<-EOS
      $one = '3.4.3'
      $two = '^2.7'
      validate_re($one,$two,"The $puppetversion fact does not match 2.7")
      EOS

      expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/does not match/)
    end
  end
=======
require 'spec_helper_acceptance'

describe 'validate_re function' do
  describe 'success' do
    pp1 = <<-DOC
      $one = 'one'
      $two = '^one$'
      validate_re($one,$two)
    DOC
    it 'validates a string' do
      apply_manifest(pp1, :catch_failures => true)
    end

    pp2 = <<-DOC
      $one = 'one'
      $two = ['^one$', '^two']
      validate_re($one,$two)
    DOC
    it 'validates an array' do
      apply_manifest(pp2, :catch_failures => true)
    end

    pp3 = <<-DOC
      $one = 'one'
      $two = ['^two$', '^three']
      validate_re($one,$two)
    DOC
    it 'validates a failed array' do
      apply_manifest(pp3, :expect_failures => true)
    end

    pp4 = <<-DOC
      $one = '3.4.3'
      $two = '^2.7'
      validate_re($one,$two,"The $puppetversion fact does not match 2.7")
    DOC
    it 'validates a failed array with a custom error message' do
      expect(apply_manifest(pp4, :expect_failures => true).stderr).to match(%r{does not match})
    end
  end

>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  describe 'failure' do
    it 'handles improper number of arguments'
    it 'handles improper argument types'
  end
end
