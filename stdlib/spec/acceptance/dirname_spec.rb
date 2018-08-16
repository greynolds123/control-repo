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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        end
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
