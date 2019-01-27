<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'is_ipv6_address function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'is_ipv6_addresss' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'is_ipv6_address function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = "fe80:0000:cd12:d123:e2f8:47ff:fe09:dd74"
      $b = true
      $o = is_ipv6_address($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_ipv6_addresss ipv6 compressed' do
      pp = <<-EOS
=======
    DOC
    it 'is_ipv6_addresss' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = "fe00::1"
      $b = true
      $o = is_ipv6_address($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_ipv6_addresss strings' do
      pp = <<-EOS
=======
    DOC
    it 'is_ipv6_addresss ipv6 compressed' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp3 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = "aoeu"
      $b = false
      $o = is_ipv6_address($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_ipv6_addresss ip out of range' do
      pp = <<-EOS
=======
    DOC
    it 'is_ipv6_addresss strings' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp4 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = 'fe80:0000:cd12:d123:e2f8:47ff:fe09:gggg'
      $b = false
      $o = is_ipv6_address($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'is_ipv6_addresss ip out of range' do
      apply_manifest(pp4, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
