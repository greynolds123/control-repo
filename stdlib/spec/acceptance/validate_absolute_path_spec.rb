<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'validate_absolute_path function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    %w{
=======
require 'spec_helper_acceptance'

describe 'validate_absolute_path function' do
  describe 'success' do
    %w[
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      C:/
      C:\\\\
      C:\\\\WINDOWS\\\\System32
      C:/windows/system32
      X:/foo/bar
      X:\\\\foo\\\\bar
      /var/tmp
      /var/lib/puppet
      /var/opt/../lib/puppet
<<<<<<< HEAD
    }.each do |path|
      it "validates a single argument #{path}" do
        pp = <<-EOS
        $one = '#{path}'
        validate_absolute_path($one)
        EOS

=======
    ].each do |path|
      pp = <<-DOC
        $one = '#{path}'
        validate_absolute_path($one)
      DOC
      it "validates a single argument #{path}" do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        apply_manifest(pp, :catch_failures => true)
      end
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments'
    it 'handles relative paths'
  end
end
