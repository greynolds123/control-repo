<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'pick_default function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'pick_defaults a default value' do
      pp = <<-EOS
      $a = undef
      $o = pick_default($a, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/picked is "default"/)
      end
    end
    it 'pick_defaults with no value' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'pick_default function' do
  describe 'success' do
    pp1 = <<-DOC
      $a = undef
      $o = pick_default($a, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
    DOC
    it 'pick_defaults a default value' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{picked is "default"})
      end
    end

    pp2 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = undef
      $b = undef
      $o = pick_default($a,$b)
      notice(inline_template('picked is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/picked is ""/)
      end
    end
    it 'pick_defaults the first set value' do
      pp = <<-EOS
=======
    DOC
    it 'pick_defaults with no value' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{picked is ""})
      end
    end

    pp3 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = "something"
      $b = "long"
      $o = pick_default($a, $b, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/picked is "something"/)
=======
    DOC
    it 'pick_defaults the first set value' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{picked is "something"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
<<<<<<< HEAD
    it 'raises error with no values' do
      pp = <<-EOS
      $o = pick_default()
      notice(inline_template('picked is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :expect_failures => true) do |r|
        expect(r.stderr).to match(/Must receive at least one argument/)
=======
    pp4 = <<-DOC
      $o = pick_default()
      notice(inline_template('picked is <%= @o.inspect %>'))
    DOC
    it 'raises error with no values' do
      apply_manifest(pp4, :expect_failures => true) do |r|
        expect(r.stderr).to match(%r{Must receive at least one argument})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
end
