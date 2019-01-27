<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'is_hash function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'is_hashs arrays' do
      pp = <<-EOS
      $a = ['aaa','bbb','ccc']
      $o = is_hash($a)
      notice(inline_template('is_hash is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/is_hash is false/)
      end
    end
    it 'is_hashs empty hashs' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'is_hash function' do
  describe 'success' do
    pp1 = <<-DOC
      $a = ['aaa','bbb','ccc']
      $o = is_hash($a)
      notice(inline_template('is_hash is <%= @o.inspect %>'))
    DOC
    it 'is_hashs arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_hash is false})
      end
    end

    pp2 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = {}
      $b = true
      $o = is_hash($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_hashs strings' do
      pp = <<-EOS
=======
    DOC
    it 'is_hashs empty hashs' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp3 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = "aoeu"
      $b = false
      $o = is_hash($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
    it 'is_hashs hashes' do
      pp = <<-EOS
=======
    DOC
    it 'is_hashs strings' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp4 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      $a = {'aaa'=>'bbb'}
      $b = true
      $o = is_hash($a)
      if $o == $b {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'is_hashs hashes' do
      apply_manifest(pp4, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
