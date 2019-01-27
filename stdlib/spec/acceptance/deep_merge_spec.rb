<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'deep_merge function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should deep merge two hashes' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'deep_merge function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $hash1 = {'one' => 1, 'two' => 2, 'three' => { 'four' => 4 } }
      $hash2 = {'two' => 'dos', 'three' => { 'five' => 5 } }
      $merged_hash = deep_merge($hash1, $hash2)

      if $merged_hash != { 'one' => 1, 'two' => 'dos', 'three' => { 'four' => 4, 'five' => 5 } } {
        fail("Hash was incorrectly merged.")
      }
<<<<<<< HEAD
      EOS

=======
    DOC
    it 'deeps merge two hashes' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      apply_manifest(pp, :catch_failures => true)
    end
  end
end
