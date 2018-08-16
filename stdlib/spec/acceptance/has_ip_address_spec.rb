<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'has_ip_address function', :unless => ((UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem'))) or (fact('osfamily') == 'windows') or (fact('osfamily') == 'AIX')) do
  describe 'success' do
    it 'has_ip_address existing ipaddress' do
      pp = <<-EOS
      $a = '127.0.0.1'
      $o = has_ip_address($a)
      notice(inline_template('has_ip_address is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/has_ip_address is true/)
      end
    end
    it 'has_ip_address absent ipaddress' do
      pp = <<-EOS
      $a = '128.0.0.1'
      $o = has_ip_address($a)
      notice(inline_template('has_ip_address is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/has_ip_address is false/)
=======
require 'spec_helper_acceptance'

describe 'has_ip_address function', :unless => ((fact('osfamily') == 'windows') || (fact('osfamily') == 'AIX')) do
  describe 'success' do
    pp1 = <<-DOC
      $a = '127.0.0.1'
      $o = has_ip_address($a)
      notice(inline_template('has_ip_address is <%= @o.inspect %>'))
    DOC
    it 'has_ip_address existing ipaddress' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{has_ip_address is true})
      end
    end

    pp2 = <<-DOC
      $a = '128.0.0.1'
      $o = has_ip_address($a)
      notice(inline_template('has_ip_address is <%= @o.inspect %>'))
    DOC
    it 'has_ip_address absent ipaddress' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{has_ip_address is false})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings'
  end
end
