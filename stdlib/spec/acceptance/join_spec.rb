<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'join function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'joins arrays' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'join function', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  describe 'success' do
    pp = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = ['aaa','bbb','ccc']
      $b = ':'
      $c = 'aaa:bbb:ccc'
      $o = join($a,$b)
      if $o == $c {
        notify { 'output correct': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
=======
    DOC
    it 'joins arrays' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
    it 'handles non arrays'
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
