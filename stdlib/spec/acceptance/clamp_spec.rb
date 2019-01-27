<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'clamp function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'clamps list of values' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'clamp function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $x = 17
      $y = 225
      $z = 155
      $o = clamp($x, $y, $z)
      if $o == $z {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'clamps array of values' do
      pp = <<-EOS
=======
    DOC
    it 'clamps list of values' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = [7, 19, 66]
      $b = 19
      $o = clamp($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'clamps array of values' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles no arguments'
  end
end
