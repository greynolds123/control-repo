<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'delete_undef_values function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should delete elements of the array' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'delete_undef_values function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $output = delete_undef_values({a=>'A', b=>'', c=>undef, d => false})
      if $output == { a => 'A', b => '', d => false } {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'deletes elements of the array' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
end
