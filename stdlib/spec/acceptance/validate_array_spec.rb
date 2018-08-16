<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'validate_array function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'validates a single argument' do
      pp = <<-EOS
      $one = ['a', 'b']
      validate_array($one)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates an multiple arguments' do
      pp = <<-EOS
      $one = ['a', 'b']
      $two = [['c'], 'd']
      validate_array($one,$two)
      EOS

      apply_manifest(pp, :catch_failures => true)
=======
require 'spec_helper_acceptance'

describe 'validate_array function' do
  describe 'success' do
    pp1 = <<-DOC
      $one = ['a', 'b']
      validate_array($one)
    DOC
    it 'validates a single argument' do
      apply_manifest(pp1, :catch_failures => true)
    end

    pp2 = <<-DOC
      $one = ['a', 'b']
      $two = [['c'], 'd']
      validate_array($one,$two)
    DOC
    it 'validates an multiple arguments' do
      apply_manifest(pp2, :catch_failures => true)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
    [
      %{validate_array({'a' => 'hash' })},
      %{validate_array('string')},
      %{validate_array(false)},
<<<<<<< HEAD
      %{validate_array(undef)}
    ].each do |pp|
      it "rejects #{pp.inspect}" do
        expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/is not an Array\.  It looks to be a/)
=======
      %{validate_array(undef)},
    ].each do |pp|
      it "rejects #{pp.inspect}" do
        expect(apply_manifest(pp, :expect_failures => true).stderr).to match(%r{is not an Array\.  It looks to be a})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments'
  end
end
