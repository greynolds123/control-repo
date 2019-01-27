<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'lstrip function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'lstrips arrays' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'lstrip function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = ["  the   ","   public   ","   art","galleries   "]
      # Anagram: Large picture halls, I bet
      $o = lstrip($a)
      notice(inline_template('lstrip is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/lstrip is \["the   ", "public   ", "art", "galleries   "\]/)
      end
    end
    it 'lstrips strings' do
      pp = <<-EOS
      $a = "   blowzy night-frumps vex'd jack q   "
      $o = lstrip($a)
      notice(inline_template('lstrip is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/lstrip is "blowzy night-frumps vex'd jack q   "/)
=======
    DOC
    it 'lstrips arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{lstrip is \["the   ", "public   ", "art", "galleries   "\]})
      end
    end

    pp2 = <<-DOC
      $a = "   blowzy night-frumps vex'd jack q   "
      $o = lstrip($a)
      notice(inline_template('lstrip is <%= @o.inspect %>'))
    DOC
    it 'lstrips strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{lstrip is "blowzy night-frumps vex'd jack q   "})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings or arrays'
  end
end
