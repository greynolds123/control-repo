<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'ceiling function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'ceilings floats' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'ceiling function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = 12.8
      $b = 13
      $o = ceiling($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'ceilings integers' do
      pp = <<-EOS
=======
    DOC
    it 'ceilings floats' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = 7
      $b = 7
      $o = ceiling($a)
      if $o == $b {
<<<<<<< HEAD
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
        notify { 'output is correct': }
      }
    DOC
    it 'ceilings integers' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output is correct})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
