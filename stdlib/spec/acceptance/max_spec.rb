<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'max function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'maxs arrays' do
      pp = <<-EOS
      $o = max("the","public","art","galleries")
      notice(inline_template('max is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/max is "the"/)
=======
require 'spec_helper_acceptance'

describe 'max function' do
  describe 'success' do
    pp = <<-DOC
      $o = max("the","public","art","galleries")
      notice(inline_template('max is <%= @o.inspect %>'))
    DOC
    it 'maxs arrays' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{max is "the"})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
  end
end
