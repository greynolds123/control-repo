<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'delete function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should delete elements of the array' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'delete function' do
  pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $output = delete(['a','b','c','b'], 'b')
      if $output == ['a','c'] {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
  DOC
  describe 'success' do
    it 'deletes elements of the array' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
