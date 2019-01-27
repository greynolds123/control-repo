<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'grep function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'greps arrays' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'grep function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = ['aaabbb','bbbccc','dddeee']
      $b = 'bbb'
      $c = ['aaabbb','bbbccc']
      $o = grep($a,$b)
      if $o == $c {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'greps arrays' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-arrays'
  end
end
