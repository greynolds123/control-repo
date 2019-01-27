<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'delete_values function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should delete elements of the hash' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'delete_values function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = { 'a' => 'A', 'b' => 'B', 'B' => 'C', 'd' => 'B' }
      $b = { 'a' => 'A', 'B' => 'C' }
      $o = delete_values($a, 'B')
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'deletes elements of the hash' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles non-hash arguments'
    it 'handles improper argument counts'
  end
end
