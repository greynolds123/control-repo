<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'upcase function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'upcases arrays' do
      pp = <<-EOS
      $a = ["wallless", "laparohysterosalpingooophorectomy", "brrr", "goddessship"]
      $o = upcase($a)
      notice(inline_template('upcase is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/upcase is \["WALLLESS", "LAPAROHYSTEROSALPINGOOOPHORECTOMY", "BRRR", "GODDESSSHIP"\]/)
      end
    end
    it 'upcases strings' do
      pp = <<-EOS
      $a = "wallless laparohysterosalpingooophorectomy brrr goddessship"
      $o = upcase($a)
      notice(inline_template('upcase is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/upcase is "WALLLESS LAPAROHYSTEROSALPINGOOOPHORECTOMY BRRR GODDESSSHIP"/)
=======
require 'spec_helper_acceptance'

describe 'upcase function' do
  describe 'success' do
    pp1 = <<-DOC
      $a = ["wallless", "laparohysterosalpingooophorectomy", "brrr", "goddessship"]
      $o = upcase($a)
      notice(inline_template('upcase is <%= @o.inspect %>'))
    DOC
    it 'upcases arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{upcase is \["WALLLESS", "LAPAROHYSTEROSALPINGOOOPHORECTOMY", "BRRR", "GODDESSSHIP"\]})
      end
    end

    pp2 = <<-DOC
      $a = "wallless laparohysterosalpingooophorectomy brrr goddessship"
      $o = upcase($a)
      notice(inline_template('upcase is <%= @o.inspect %>'))
    DOC
    it 'upcases strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{upcase is "WALLLESS LAPAROHYSTEROSALPINGOOOPHORECTOMY BRRR GODDESSSHIP"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings or arrays'
  end
end
