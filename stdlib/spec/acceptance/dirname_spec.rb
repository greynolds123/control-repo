<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'dirname function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    context 'absolute path' do
      it 'returns the dirname' do
        pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'dirname function' do
  describe 'success' do
    context 'with absolute path' do
      pp1 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        $a = '/path/to/a/file.txt'
        $b = '/path/to/a'
        $o = dirname($a)
        if $o == $b {
          notify { 'output correct': }
        }
<<<<<<< HEAD
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/Notice: output correct/)
        end
      end
    end
    context 'relative path' do
      it 'returns the dirname' do
        pp = <<-EOS
=======
      DOC
      it 'returns the dirname' do
        apply_manifest(pp1, :catch_failures => true) do |r|
          expect(r.stdout).to match(%r{Notice: output correct})
        end
      end
    end
    context 'with relative path' do
      pp2 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        $a = 'path/to/a/file.txt'
        $b = 'path/to/a'
        $o = dirname($a)
        if $o == $b {
          notify { 'output correct': }
        }
<<<<<<< HEAD
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/Notice: output correct/)
=======
      DOC
      it 'returns the dirname' do
        apply_manifest(pp2, :catch_failures => true) do |r|
          expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        end
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
