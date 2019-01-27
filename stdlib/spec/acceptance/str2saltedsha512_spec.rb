<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'str2saltedsha512 function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'works with "y"' do
      pp = <<-EOS
      $o = str2saltedsha512('password')
      notice(inline_template('str2saltedsha512 is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/str2saltedsha512 is "[a-f0-9]{136}"/)
=======
require 'spec_helper_acceptance'

describe 'str2saltedsha512 function' do
  describe 'success' do
    pp = <<-DOC
      $o = str2saltedsha512('password')
      notice(inline_template('str2saltedsha512 is <%= @o.inspect %>'))
    DOC
    it 'works with "y"' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{str2saltedsha512 is "[a-f0-9]{136}"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles more than one argument'
    it 'handles non strings'
  end
end
