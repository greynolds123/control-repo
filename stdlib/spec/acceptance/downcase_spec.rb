<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'downcase function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'returns the downcase' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'downcase function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = 'AOEU'
      $b = 'aoeu'
      $o = downcase($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'doesn\'t affect lowercase words' do
      pp = <<-EOS
=======
    DOC
    it 'returns the downcase' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = 'aoeu aoeu'
      $b = 'aoeu aoeu'
      $o = downcase($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'doesn\'t affect lowercase words' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-strings'
  end
end
