<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'getvar function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'getvars from classes' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'getvar function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      class a::data { $foo = 'aoeu' }
      include a::data
      $b = 'aoeu'
      $o = getvar("a::data::foo")
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'getvars from classes' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
