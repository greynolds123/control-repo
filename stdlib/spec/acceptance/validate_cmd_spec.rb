<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'validate_cmd function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'validates a true command' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'validate_cmd function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $one = 'foo'
      if $::osfamily == 'windows' {
        $two = 'echo' #shell built-in
      } else {
        $two = '/bin/echo'
      }
      validate_cmd($one,$two)
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates a fail command' do
      pp = <<-EOS
=======
    DOC
    it 'validates a true command' do
      apply_manifest(pp1, :catch_failures => true)
    end

    pp2 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $one = 'foo'
      if $::osfamily == 'windows' {
        $two = 'C:/aoeu'
      } else {
        $two = '/bin/aoeu'
      }
      validate_cmd($one,$two)
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :expect_failures => true)
    end
    it 'validates a fail command with a custom error message' do
      pp = <<-EOS
=======
    DOC
    it 'validates a fail command' do
      apply_manifest(pp2, :expect_failures => true)
    end

    pp3 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $one = 'foo'
      if $::osfamily == 'windows' {
        $two = 'C:/aoeu'
      } else {
        $two = '/bin/aoeu'
      }
      validate_cmd($one,$two,"aoeu is dvorak")
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :expect_failures => true) do |output|
        expect(output.stderr).to match(/aoeu is dvorak/)
=======
    DOC
    it 'validates a fail command with a custom error message' do
      apply_manifest(pp3, :expect_failures => true) do |output|
        expect(output.stderr).to match(%r{aoeu is dvorak})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments'
    it 'handles improper argument types'
  end
end
