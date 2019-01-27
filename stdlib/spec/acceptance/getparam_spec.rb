<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'getparam function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'getparam a notify' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'getparam function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      notify { 'rspec':
        message => 'custom rspec message',
      }
      $o = getparam(Notify['rspec'], 'message')
      notice(inline_template('getparam is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/getparam is "custom rspec message"/)
=======
    DOC
    it 'getparam a notify' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{getparam is "custom rspec message"})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings'
  end
end
