<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'time function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'gives the time' do
      pp = <<-EOS
      $o = time()
      notice(inline_template('time is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        m = r.stdout.match(/time is (\d+)\D/)

        # When I wrote this test
        expect(Integer(m[1])).to be > 1398894170
      end
    end
    it 'takes a timezone argument' do
      pp = <<-EOS
      $o = time('UTC')
      notice(inline_template('time is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        m = r.stdout.match(/time is (\d+)\D/)

        expect(Integer(m[1])).to be > 1398894170
=======
require 'spec_helper_acceptance'

describe 'time function' do
  describe 'success' do
    pp1 = <<-DOC
      $o = time()
      notice(inline_template('time is <%= @o.inspect %>'))
    DOC
    it 'gives the time' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        m = r.stdout.match(%r{time is (\d+)\D})
        # When I wrote this test
        expect(Integer(m[1])).to be > 1_398_894_170
      end
    end

    pp2 = <<-DOC
      $o = time('UTC')
      notice(inline_template('time is <%= @o.inspect %>'))
    DOC
    it 'takes a timezone argument' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        m = r.stdout.match(%r{time is (\d+)\D})
        expect(Integer(m[1])).to be > 1_398_894_170
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles more arguments'
    it 'handles invalid timezones'
  end
end
