<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'uriescape function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'uriescape strings' do
      pp = <<-EOS
      $a = ":/?#[]@!$&'()*+,;= \\\"{}"
      $o = uriescape($a)
      notice(inline_template('uriescape is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/uriescape is ":\/\?%23\[\]@!\$&'\(\)\*\+,;=%20%22%7B%7D"/)
=======
require 'spec_helper_acceptance'

describe 'uriescape function' do
  describe 'success' do
    pp = <<-DOC
      $a = ":/?#[]@!$&'()*+,;= \\\"{}"
      $o = uriescape($a)
      notice(inline_template('uriescape is <%= @o.inspect %>'))
    DOC
    it 'uriescape strings' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{uriescape is ":\/\?%23\[\]@!\$&'\(\)\*\+,;=%20%22%7B%7D"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
    it 'does nothing if a string is already safe'
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings or arrays'
  end
end
