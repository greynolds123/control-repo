<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'values function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'returns an array of values' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'values function', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $arg = {
        'a' => 1,
        'b' => 2,
        'c' => 3,
      }
      $output = values($arg)
      notice(inline_template('<%= @output.sort.inspect %>'))
<<<<<<< HEAD
      EOS
      if is_future_parser_enabled?
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\[1, 2, 3\]/)
      else
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\["1", "2", "3"\]/)
      end

    end
  end
  describe 'failure' do
    it 'handles non-hash arguments' do
      pp = <<-EOS
      $arg = "foo"
      $output = values($arg)
      notice(inline_template('<%= @output.inspect %>'))
      EOS

      expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/Requires hash/)
=======
    DOC
    it 'returns an array of values' do
      expect(apply_manifest(pp1, :catch_failures => true).stdout).to match(%r{\[1, 2, 3\]})
    end
  end

  describe 'failure' do
    pp2 = <<-DOC
      $arg = "foo"
      $output = values($arg)
      notice(inline_template('<%= @output.inspect %>'))
    DOC
    it 'handles non-hash arguments' do
      expect(apply_manifest(pp2, :expect_failures => true).stderr).to match(%r{Requires hash})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
  end
end
