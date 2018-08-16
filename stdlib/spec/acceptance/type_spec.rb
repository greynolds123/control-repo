<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'type function', :unless => (UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) || is_future_parser_enabled?) do
  describe 'success' do
    it 'types arrays' do
      pp = <<-EOS
      $a = ["the","public","art","galleries"]
      # Anagram: Large picture halls, I bet
      $o = type($a)
      notice(inline_template('type is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/type is "array"/)
      end
    end
    it 'types strings' do
      pp = <<-EOS
      $a = "blowzy night-frumps vex'd jack q"
      $o = type($a)
      notice(inline_template('type is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/type is "string"/)
=======
require 'spec_helper_acceptance'

describe 'type function' do
  describe 'success' do
    pp1 = <<-DOC
      $a = ["the","public","art","galleries"]
      # Anagram: Large picture halls, I bet
      $o = type($a)
      notice(inline_template('type is <%= @o.to_s %>'))
    DOC
    it 'types arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{type is Tuple\[String.*, String.*, String.*, String.*\]})
      end
    end

    pp2 = <<-DOC
      $a = "blowzy night-frumps vex'd jack q"
      $o = type($a)
      notice(inline_template('type is <%= @o.to_s %>'))
    DOC
    it 'types strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{type is String})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
    it 'types hashes'
    it 'types integers'
    it 'types floats'
    it 'types booleans'
  end
  describe 'failure' do
    it 'handles no arguments'
  end
end
