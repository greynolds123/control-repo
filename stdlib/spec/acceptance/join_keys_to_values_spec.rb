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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
    it 'handles non hashes'
    it 'handles empty hashes'
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
