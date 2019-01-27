<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'base64 function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should encode then decode a string' do
      pp = <<-EOS
      $encodestring = base64('encode', 'thestring')
      $decodestring = base64('decode', $encodestring)
      notify { $decodestring: }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/thestring/)
=======
require 'spec_helper_acceptance'

describe 'base64 function' do
  describe 'success' do
    pp = <<-DOC
      $encodestring = base64('encode', 'thestring')
      $decodestring = base64('decode', $encodestring)
      notify { $decodestring: }
    DOC
    it 'encodes then decode a string' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{thestring})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
