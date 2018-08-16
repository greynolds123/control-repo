<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'shuffle function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'shuffles arrays' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'shuffle function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = ["1", "2", "3", "4", "5", "6", "7", "8", "the","public","art","galleries"]
      # Anagram: Large picture halls, I bet
      $o = shuffle($a)
      notice(inline_template('shuffle is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to_not match(/shuffle is \["1", "2", "3", "4", "5", "6", "7", "8", "the", "public", "art", "galleries"\]/)
      end
    end
    it 'shuffles strings' do
      pp = <<-EOS
      $a = "blowzy night-frumps vex'd jack q"
      $o = shuffle($a)
      notice(inline_template('shuffle is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to_not match(/shuffle is "blowzy night-frumps vex'd jack q"/)
=======
    DOC
    it 'shuffles arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).not_to match(%r{shuffle is \["1", "2", "3", "4", "5", "6", "7", "8", "the", "public", "art", "galleries"\]})
      end
    end

    pp2 = <<-DOC
      $a = "blowzy night-frumps vex'd jack q"
      $o = shuffle($a)
      notice(inline_template('shuffle is <%= @o.inspect %>'))
    DOC
    it 'shuffles strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).not_to match(%r{shuffle is "blowzy night-frumps vex'd jack q"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings or arrays'
  end
end
