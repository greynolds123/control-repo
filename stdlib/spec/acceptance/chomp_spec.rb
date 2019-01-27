<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'chomp function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should eat the newline' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'chomp function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $input = "test\n"
      if size($input) != 5 {
        fail("Size of ${input} is not 5.")
      }
      $output = chomp($input)
      if size($output) != 4 {
        fail("Size of ${input} is not 4.")
      }
<<<<<<< HEAD
      EOS

=======
    DOC
    it 'eats the newline' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      apply_manifest(pp, :catch_failures => true)
    end
  end
end
