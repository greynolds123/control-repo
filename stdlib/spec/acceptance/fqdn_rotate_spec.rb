<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'fqdn_rotate function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    include_context "with faked facts"
    context "when the FQDN is 'fakehost.localdomain'" do
      before :each do
        fake_fact("fqdn", "fakehost.localdomain")
      end

      it 'rotates arrays' do
        pp = <<-EOS
        $a = ['a','b','c','d']
        $o = fqdn_rotate($a)
        notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/fqdn_rotate is \["d", "a", "b", "c"\]/)
        end
      end
      it 'rotates arrays with custom seeds' do
        pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'fqdn_rotate function' do
  describe 'success' do
    include_context 'with faked facts'
    context "when the FQDN is 'fakehost.localdomain'" do
      before :each do
        fake_fact('fqdn', 'fakehost.localdomain')
      end

      pp1 = <<-DOC
        $a = ['a','b','c','d']
        $o = fqdn_rotate($a)
        notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
      DOC
      it 'rotates arrays' do
        apply_manifest(pp1, :catch_failures => true) do |r|
          expect(r.stdout).to match(%r{fqdn_rotate is \["d", "a", "b", "c"\]})
        end
      end

      pp2 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        $a = ['a','b','c','d']
        $s = 'seed'
        $o = fqdn_rotate($a, $s)
        notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
<<<<<<< HEAD
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/fqdn_rotate is \["c", "d", "a", "b"\]/)
        end
      end
      it 'rotates strings' do
        pp = <<-EOS
        $a = 'abcd'
        $o = fqdn_rotate($a)
        notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/fqdn_rotate is "dabc"/)
        end
      end
      it 'rotates strings with custom seeds' do
        pp = <<-EOS
=======
      DOC
      it 'rotates arrays with custom seeds' do
        apply_manifest(pp2, :catch_failures => true) do |r|
          expect(r.stdout).to match(%r{fqdn_rotate is \["c", "d", "a", "b"\]})
        end
      end

      pp3 = <<-DOC
        $a = 'abcd'
        $o = fqdn_rotate($a)
        notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
      DOC
      it 'rotates strings' do
        apply_manifest(pp3, :catch_failures => true) do |r|
          expect(r.stdout).to match(%r{fqdn_rotate is "dabc"})
        end
      end

      pp4 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        $a = 'abcd'
        $s = 'seed'
        $o = fqdn_rotate($a, $s)
        notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
<<<<<<< HEAD
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/fqdn_rotate is "cdab"/)
=======
      DOC
      it 'rotates strings with custom seeds' do
        apply_manifest(pp4, :catch_failures => true) do |r|
          expect(r.stdout).to match(%r{fqdn_rotate is "cdab"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        end
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles invalid arguments'
  end
end
