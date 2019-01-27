<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'join_keys_to_values function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'join_keys_to_valuess hashes' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'join_keys_to_values function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = {'aaa'=>'bbb','ccc'=>'ddd'}
      $b = ':'
      $o = join_keys_to_values($a,$b)
      notice(inline_template('join_keys_to_values is <%= @o.sort.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/join_keys_to_values is \["aaa:bbb", "ccc:ddd"\]/)
=======
    DOC
    it 'join_keys_to_valuess hashes' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{join_keys_to_values is \["aaa:bbb", "ccc:ddd"\]})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
    it 'handles non hashes'
    it 'handles empty hashes'
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
