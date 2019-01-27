<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'is_float function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'is_floats arrays' do
      pp = <<-EOS
      $a = ['aaa.com','bbb','ccc']
      $o = is_float($a)
      notice(inline_template('is_float is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/is_float is false/)
      end
    end
    it 'is_floats true' do
      pp = <<-EOS
      $a = true
      $o = is_float($a)
      notice(inline_template('is_float is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/is_float is false/)
      end
    end
    it 'is_floats strings' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'is_float function' do
  describe 'success' do
    pp1 = <<-DOC
      $a = ['aaa.com','bbb','ccc']
      $o = is_float($a)
      notice(inline_template('is_float is <%= @o.inspect %>'))
    DOC
    it 'is_floats arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_float is false})
      end
    end

    pp2 = <<-DOC
      $a = true
      $o = is_float($a)
      notice(inline_template('is_float is <%= @o.inspect %>'))
    DOC
    it 'is_floats true' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_float is false})
      end
    end

    pp3 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = "3.5"
      $b = true
      $o = is_float($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_floats floats' do
      pp = <<-EOS
=======
    DOC
    it 'is_floats strings' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp4 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = 3.5
      $b = true
      $o = is_float($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_floats integers' do
      pp = <<-EOS
=======
    DOC
    it 'is_floats floats' do
      apply_manifest(pp4, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp5 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = 3
      $b = false
      $o = is_float($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_floats hashes' do
      pp = <<-EOS
      $a = {'aaa'=>'www.com'}
      $o = is_float($a)
      notice(inline_template('is_float is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/is_float is false/)
=======
    DOC
    it 'is_floats integers' do
      apply_manifest(pp5, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp6 = <<-DOC
      $a = {'aaa'=>'www.com'}
      $o = is_float($a)
      notice(inline_template('is_float is <%= @o.inspect %>'))
    DOC
    it 'is_floats hashes' do
      apply_manifest(pp6, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_float is false})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-arrays'
  end
end
