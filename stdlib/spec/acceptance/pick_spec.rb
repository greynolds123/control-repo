<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'pick function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'picks a default value' do
      pp = <<-EOS
      $a = undef
      $o = pick($a, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/picked is "default"/)
      end
    end
    it 'picks the first set value' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'pick function' do
  describe 'success' do
    pp1 = <<-DOC
      $a = undef
      $o = pick($a, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
    DOC
    it 'picks a default value' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{picked is "default"})
      end
    end

    pp2 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = "something"
      $b = "long"
      $o = pick($a, $b, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/picked is "something"/)
      end
    end
  end
  describe 'failure' do
    it 'raises error with all undef values' do
      pp = <<-EOS
=======
    DOC
    it 'picks the first set value' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{picked is "something"})
      end
    end
  end

  describe 'failure' do
    pp3 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = undef
      $b = undef
      $o = pick($a, $b)
      notice(inline_template('picked is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :expect_failures => true) do |r|
        expect(r.stderr).to match(/must receive at least one non empty value/)
=======
    DOC
    it 'raises error with all undef values' do
      apply_manifest(pp3, :expect_failures => true) do |r|
        expect(r.stderr).to match(%r{must receive at least one non empty value})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
