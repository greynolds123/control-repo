<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'any2array function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should create an empty array' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'any2array function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $input = ''
      $output = any2array($input)
      validate_array($output)
      notify { "Output: ${output}": }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: Output: /)
      end
    end

    it 'should leave arrays modified' do
      pp = <<-EOS
      $input = ['test', 'array']
      $output = any2array($input)
      validate_array($output)
      notify { "Output: ${output}": }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: Output: (\[|)test(,\s|)array(\]|)/)
      end
    end

    it 'should turn a hash into an array' do
      pp = <<-EOS
=======
    DOC
    it 'creates an empty array' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: Output: })
      end
    end

    pp2 = <<-DOC
      $input = ['array', 'test']
      $output = any2array($input)
      validate_array($output)
      notify { "Output: ${output}": }
    DOC
    it 'leaves arrays modified' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: Output: (\[|)array(,\s|)test(\]|)})
      end
    end

    pp3 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $input = {'test' => 'array'}
      $output = any2array($input)

      validate_array($output)
      # Check each element of the array is a plain string.
      validate_string($output[0])
      validate_string($output[1])
      notify { "Output: ${output}": }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: Output: (\[|)test(,\s|)array(\]|)/)
=======
    DOC
    it 'turns a hash into an array' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: Output: (\[|)test(,\s|)array(\]|)})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
end
