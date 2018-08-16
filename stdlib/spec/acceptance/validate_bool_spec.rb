<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'validate_bool function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'validates a single argument' do
      pp = <<-EOS
      $one = true
      validate_bool($one)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates an multiple arguments' do
      pp = <<-EOS
      $one = true
      $two = false
      validate_bool($one,$two)
      EOS

      apply_manifest(pp, :catch_failures => true)
=======
require 'spec_helper_acceptance'

describe 'validate_bool function' do
  describe 'success' do
    pp1 = <<-DOC
      $one = true
      validate_bool($one)
    DOC
    it 'validates a single argument' do
      apply_manifest(pp1, :catch_failures => true)
    end

    pp2 = <<-DOC
      $one = true
      $two = false
      validate_bool($one,$two)
    DOC
    it 'validates an multiple arguments' do
      apply_manifest(pp2, :catch_failures => true)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
    [
      %{validate_bool('true')},
      %{validate_bool('false')},
      %{validate_bool([true])},
<<<<<<< HEAD
      %{validate_bool(undef)}
    ].each do |pp|
      it "rejects #{pp.inspect}" do
        expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/is not a boolean\.  It looks to be a/)
=======
      %{validate_bool(undef)},
    ].each do |pp3|
      it "rejects #{pp3.inspect}" do
        expect(apply_manifest(pp3, :expect_failures => true).stderr).to match(%r{is not a boolean\.  It looks to be a})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments'
  end
end
