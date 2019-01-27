<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'keys function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'keyss hashes' do
      pp = <<-EOS
      $a = {'aaa'=>'bbb','ccc'=>'ddd'}
      $o = keys($a)
      notice(inline_template('keys is <%= @o.sort.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/keys is \["aaa", "ccc"\]/)
=======
require 'spec_helper_acceptance'

describe 'keys function', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  describe 'success' do
    pp = <<-DOC
      $a = {'aaa'=>'bbb','ccc'=>'ddd'}
      $o = keys($a)
      notice(inline_template('keys is <%= @o.sort.inspect %>'))
    DOC
    it 'keyss hashes' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{keys is \["aaa", "ccc"\]})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
    it 'handles non hashes'
    it 'handles empty hashes'
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
