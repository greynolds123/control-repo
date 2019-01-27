<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'is_function_available function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'is_function_availables arrays' do
      pp = <<-EOS
      $a = ['fail','include','require']
      $o = is_function_available($a)
      notice(inline_template('is_function_available is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/is_function_available is false/)
      end
    end
    it 'is_function_availables true' do
      pp = <<-EOS
      $a = true
      $o = is_function_available($a)
      notice(inline_template('is_function_available is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/is_function_available is false/)
      end
    end
    it 'is_function_availables strings' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'is_function_available function' do
  describe 'success' do
    pp1 = <<-DOC
      $a = ['fail','include','require']
      $o = is_function_available($a)
      notice(inline_template('is_function_available is <%= @o.inspect %>'))
    DOC
    it 'is_function_availables arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_function_available is false})
      end
    end

    pp2 = <<-DOC
      $a = true
      $o = is_function_available($a)
      notice(inline_template('is_function_available is <%= @o.inspect %>'))
    DOC
    it 'is_function_availables true' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_function_available is false})
      end
    end

    pp3 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = "fail"
      $b = true
      $o = is_function_available($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_function_availables function_availables' do
      pp = <<-EOS
      $a = "is_function_available"
      $o = is_function_available($a)
      notice(inline_template('is_function_available is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/is_function_available is true/)
=======
    DOC
    it 'is_function_availables strings' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp4 = <<-DOC
      $a = "is_function_available"
      $o = is_function_available($a)
      notice(inline_template('is_function_available is <%= @o.inspect %>'))
    DOC
    it 'is_function_availables function_availables' do
      apply_manifest(pp4, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_function_available is true})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-arrays'
  end
end
