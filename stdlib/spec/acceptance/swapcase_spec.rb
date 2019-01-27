<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'swapcase function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'works with strings' do
      pp = <<-EOS
      $o = swapcase('aBcD')
      notice(inline_template('swapcase is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/swapcase is "AbCd"/)
=======
require 'spec_helper_acceptance'

describe 'swapcase function' do
  describe 'success' do
    pp = <<-DOC
      $o = swapcase('aBcD')
      notice(inline_template('swapcase is <%= @o.inspect %>'))
    DOC
    it 'works with strings' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{swapcase is "AbCd"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
    it 'works with arrays'
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non arrays or strings'
  end
end
