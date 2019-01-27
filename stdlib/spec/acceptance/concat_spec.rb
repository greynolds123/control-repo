<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'concat function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should concat one array to another' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'concat function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $output = concat(['1','2','3'],['4','5','6'])
      validate_array($output)
      if size($output) != 6 {
        fail("${output} should have 6 elements.")
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'should concat arrays and primitives to array' do
      pp = <<-EOS
=======
    DOC
    it 'concats one array to another' do
      apply_manifest(pp1, :catch_failures => true)
    end

    pp2 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $output = concat(['1','2','3'],'4','5','6',['7','8','9'])
      validate_array($output)
      if size($output) != 9 {
        fail("${output} should have 9 elements.")
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'should concat multiple arrays to one' do
      pp = <<-EOS
=======
    DOC
    it 'concats arrays and primitives to array' do
      apply_manifest(pp2, :catch_failures => true)
    end

    pp3 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $output = concat(['1','2','3'],['4','5','6'],['7','8','9'])
      validate_array($output)
      if size($output) != 9 {
        fail("${output} should have 9 elements.")
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'should concat hash arguments' do
      pp = <<-EOS
=======
    DOC
    it 'concats multiple arrays to one' do
      apply_manifest(pp3, :catch_failures => true)
    end

    pp4 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $output = concat([{"a" => "b"}], {"c" => "d", "e" => "f"})
      validate_array($output)
      if size($output) != 2 {
        fail("${output} should have 2 elements.")
      }
      if $output[1] != {"c" => "d", "e" => "f"} {
        fail("${output} does not have the expected hash for the second element.")
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true)
=======
    DOC
    it 'concats hash arguments' do
      apply_manifest(pp4, :catch_failures => true)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
  end
end
