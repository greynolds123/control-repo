<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'parseyaml function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'parses valid yaml' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'parseyaml function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = "---\nhunter: washere\ntests: passing\n"
      $o = parseyaml($a)
      $tests = $o['tests']
      notice(inline_template('tests are <%= @tests.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/tests are "passing"/)
=======
    DOC
    it 'parses valid yaml' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{tests are "passing"})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end

  describe 'failure' do
<<<<<<< HEAD
    it 'returns the default value on incorrect yaml' do
      pp = <<-EOS
=======
    pp2 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = "---\nhunter: washere\ntests: passing\n:"
      $o = parseyaml($a, {'tests' => 'using the default value'})
      $tests = $o['tests']
      notice(inline_template('tests are <%= @tests.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/tests are "using the default value"/)
      end
    end

    it 'raises error on incorrect yaml' do
      pp = <<-EOS
=======
    DOC
    it 'returns the default value on incorrect yaml' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{tests are "using the default value"})
      end
    end

    pp3 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = "---\nhunter: washere\ntests: passing\n:"
      $o = parseyaml($a)
      $tests = $o['tests']
      notice(inline_template('tests are <%= @tests.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :expect_failures => true) do |r|
        expect(r.stderr).to match(/(syntax error|did not find expected key)/)
      end
    end


    it 'raises error on incorrect number of arguments' do
      pp = <<-EOS
      $o = parseyaml()
      EOS

      apply_manifest(pp, :expect_failures => true) do |r|
        expect(r.stderr).to match(/wrong number of arguments/i)
=======
    DOC
    it 'raises error on incorrect yaml' do
      apply_manifest(pp3, :expect_failures => true) do |r|
        expect(r.stderr).to match(%r{(syntax error|did not find expected key)})
      end
    end

    pp4 = <<-DOC
      $o = parseyaml()
    DOC
    it 'raises error on incorrect number of arguments' do
      apply_manifest(pp4, :expect_failures => true) do |r|
        expect(r.stderr).to match(%r{wrong number of arguments}i)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
