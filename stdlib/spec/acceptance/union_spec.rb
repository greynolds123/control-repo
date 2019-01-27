<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'union function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'unions arrays' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'union function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = ["the","public"]
      $b = ["art"]
      $c = ["galleries"]
      # Anagram: Large picture halls, I bet
      $o = union($a,$b,$c)
      notice(inline_template('union is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/union is \["the", "public", "art", "galleries"\]/)
=======
    DOC
    it 'unions arrays' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{union is \["the", "public", "art", "galleries"\]})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non arrays'
  end
end
