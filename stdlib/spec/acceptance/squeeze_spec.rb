<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'squeeze function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'squeezes arrays' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'squeeze function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      # Real words!
      $a = ["wallless", "laparohysterosalpingooophorectomy", "brrr", "goddessship"]
      $o = squeeze($a)
      notice(inline_template('squeeze is <%= @o.inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/squeeze is \["wales", "laparohysterosalpingophorectomy", "br", "godeship"\]/)
      end
    end
    it 'squeezez arrays with an argument'
    it 'squeezes strings' do
      pp = <<-EOS
      $a = "wallless laparohysterosalpingooophorectomy brrr goddessship"
      $o = squeeze($a)
      notice(inline_template('squeeze is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/squeeze is "wales laparohysterosalpingophorectomy br godeship"/)
      end
    end

    it 'squeezes strings with an argument' do
      pp = <<-EOS
      $a = "countessship duchessship governessship hostessship"
      $o = squeeze($a, 's')
      notice(inline_template('squeeze is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/squeeze is "counteship ducheship governeship hosteship"/)
=======
    DOC
    it 'squeezes arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{squeeze is \["wales", "laparohysterosalpingophorectomy", "br", "godeship"\]})
      end
    end

    it 'squeezez arrays with an argument'
    pp2 = <<-DOC
      $a = "wallless laparohysterosalpingooophorectomy brrr goddessship"
      $o = squeeze($a)
      notice(inline_template('squeeze is <%= @o.inspect %>'))
    DOC
    it 'squeezes strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{squeeze is "wales laparohysterosalpingophorectomy br godeship"})
      end
    end

    pp3 = <<-DOC
      $a = "countessship duchessship governessship hostessship"
      $o = squeeze($a, 's')
      notice(inline_template('squeeze is <%= @o.inspect %>'))
    DOC
    it 'squeezes strings with an argument' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{squeeze is "counteship ducheship governeship hosteship"})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings or arrays'
  end
end
