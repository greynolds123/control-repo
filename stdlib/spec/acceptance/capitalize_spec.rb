<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'capitalize function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should capitalize the first letter of a string' do
      pp = <<-EOS
      $input = 'this is a string'
      $output = capitalize($input)
      notify { $output: }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: This is a string/)
      end
    end

    it 'should capitalize the first letter of an array of strings' do
      pp = <<-EOS
      $input = ['this', 'is', 'a', 'string']
      $output = capitalize($input)
      notify { $output: }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: This/)
        expect(r.stdout).to match(/Notice: Is/)
        expect(r.stdout).to match(/Notice: A/)
        expect(r.stdout).to match(/Notice: String/)
=======
require 'spec_helper_acceptance'

describe 'capitalize function' do
  describe 'success' do
    pp1 = <<-DOC
        $input = 'this is a string'
        $output = capitalize($input)
        notify { $output: }
    DOC
    it 'capitalizes the first letter of a string' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: This is a string})
      end
    end

    pp2 = <<-DOC
      $input = ['this', 'is', 'a', 'string']
      $output = capitalize($input)
      notify { $output: }
    DOC
    regex_array = [%r{Notice: This}, %r{Notice: Is}, %r{Notice: A}, %r{Notice: String}]
    it 'capitalizes the first letter of an array of strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        regex_array.each do |i|
          expect(r.stdout).to match(i)
        end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
