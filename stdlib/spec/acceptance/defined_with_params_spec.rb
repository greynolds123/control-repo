<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'defined_with_params function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should successfully notify' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'defined_with_params function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      user { 'dan':
        ensure => present,
      }

      if defined_with_params(User[dan], {'ensure' => 'present' }) {
        notify { 'User defined with ensure=>present': }
      }
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: User defined with ensure=>present/)
=======
    DOC
    it 'successfullies notify' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: User defined with ensure=>present})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
