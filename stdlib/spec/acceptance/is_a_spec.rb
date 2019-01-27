<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

if get_puppet_version =~ /^4/
  describe 'is_a function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
    it 'should match a string' do
      pp = <<-EOS
      if 'hello world'.is_a(String) {
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end

    it 'should not match a integer as string' do
      pp = <<-EOS
      if 5.is_a(String) {
        notify { 'output wrong': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).not_to match(/Notice: output wrong/)
=======
require 'spec_helper_acceptance'

if return_puppet_version =~ %r{^4}
  describe 'is_a function' do
    pp1 = <<-DOC
      if 'hello world'.is_a(String) {
        notify { 'output correct': }
      }
    DOC
    it 'matches a string' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-DOC
      if 5.is_a(String) {
        notify { 'output wrong': }
      }
    DOC
    it 'does not match a integer as string' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).not_to match(%r{Notice: output wrong})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
end
