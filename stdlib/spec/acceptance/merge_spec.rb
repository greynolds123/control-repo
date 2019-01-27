<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'merge function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should merge two hashes' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'merge function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = {'one' => 1, 'two' => 2, 'three' => { 'four' => 4 } }
      $b = {'two' => 'dos', 'three' => { 'five' => 5 } }
      $o = merge($a, $b)
      notice(inline_template('merge[one]   is <%= @o["one"].inspect %>'))
      notice(inline_template('merge[two]   is <%= @o["two"].inspect %>'))
      notice(inline_template('merge[three] is <%= @o["three"].inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/merge\[one\]   is ("1"|1)/)
        expect(r.stdout).to match(/merge\[two\]   is "dos"/)
        expect(r.stdout).to match(/merge\[three\] is {"five"=>("5"|5)}/)
=======
    DOC
    regex_array = [%r{merge\[one\]   is ("1"|1)}, %r{merge\[two\]   is "dos"}, %r{merge\[three\] is {"five"=>("5"|5)}}]
    it 'merges two hashes' do
      apply_manifest(pp, :catch_failures => true) do |r|
        regex_array.each do |i|
          expect(r.stdout).to match(i)
        end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
end
