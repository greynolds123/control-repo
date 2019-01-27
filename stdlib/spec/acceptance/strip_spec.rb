<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'strip function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'strips arrays' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'strip function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = ["  the   ","   public   ","   art","galleries   "]
      # Anagram: Large picture halls, I bet
      $o = strip($a)
      notice(inline_template('strip is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/strip is \["the", "public", "art", "galleries"\]/)
      end
    end
    it 'strips strings' do
      pp = <<-EOS
      $a = "   blowzy night-frumps vex'd jack q   "
      $o = strip($a)
      notice(inline_template('strip is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/strip is "blowzy night-frumps vex'd jack q"/)
=======
    DOC
    it 'strips arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{strip is \["the", "public", "art", "galleries"\]})
      end
    end

    pp2 = <<-DOC
      $a = "   blowzy night-frumps vex'd jack q   "
      $o = strip($a)
      notice(inline_template('strip is <%= @o.inspect %>'))
    DOC
    it 'strips strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{strip is "blowzy night-frumps vex'd jack q"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings or arrays'
  end
end
