<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
require 'spec_helper_acceptance'

describe 'ensure_resource function' do
  describe 'success' do
<<<<<<< HEAD
    it 'ensures a resource already declared' do
      apply_manifest('')
      pp = <<-EOS
      notify { "test": loglevel => 'err' }
      ensure_resource('notify', 'test', { 'loglevel' => 'err' })
      EOS

      apply_manifest(pp, :expect_changes => true)
    end

    it 'ensures a undeclared resource' do
      apply_manifest('')
      pp = <<-EOS
      ensure_resource('notify', 'test', { 'loglevel' => 'err' })
      EOS

      apply_manifest(pp, :expect_changes => true)
=======
    pp1 = <<-DOC
      notify { "test": loglevel => 'err' }
      ensure_resource('notify', 'test', { 'loglevel' => 'err' })
    DOC
    it 'ensures a resource already declared' do
      apply_manifest('')

      apply_manifest(pp1, :expect_changes => true)
    end

    pp2 = <<-DOC
      ensure_resource('notify', 'test', { 'loglevel' => 'err' })
    DOC
    it 'ensures a undeclared resource' do
      apply_manifest('')

      apply_manifest(pp2, :expect_changes => true)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
    it 'takes defaults arguments'
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings'
  end
end
