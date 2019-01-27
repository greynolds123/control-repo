<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'chop function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should eat the last character' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'chop function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $input = "test"
      if size($input) != 4 {
        fail("Size of ${input} is not 4.")
      }
      $output = chop($input)
      if size($output) != 3 {
        fail("Size of ${input} is not 3.")
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true)
    end

    it 'should eat the last two characters of \r\n' do
      pp = <<-'EOS'
=======
    DOC
    it 'eats the last character' do
      apply_manifest(pp1, :catch_failures => true)
    end

    pp2 = <<-'DOC'
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $input = "test\r\n"
      if size($input) != 6 {
        fail("Size of ${input} is not 6.")
      }
      $output = chop($input)
      if size($output) != 4 {
        fail("Size of ${input} is not 4.")
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true)
    end

    it 'should not fail on empty strings' do
      pp = <<-EOS
      $input = ""
      $output = chop($input)
      EOS

      apply_manifest(pp, :catch_failures => true)
=======
    DOC
    it 'eats the last two characters of \r\n' do
      apply_manifest(pp2, :catch_failures => true)
    end

    pp3 = <<-DOC
      $input = ""
      $output = chop($input)
    DOC
    it 'does not fail on empty strings' do
      apply_manifest(pp3, :catch_failures => true)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end
end
