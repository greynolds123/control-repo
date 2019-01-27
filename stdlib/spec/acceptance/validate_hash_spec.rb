<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'validate_hash function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'validates a single argument' do
      pp = <<-EOS
      $one = { 'a' => 1 }
      validate_hash($one)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'validates an multiple arguments' do
      pp = <<-EOS
      $one = { 'a' => 1 }
      $two = { 'b' => 2 }
      validate_hash($one,$two)
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
=======
require 'spec_helper_acceptance'

describe 'validate_hash function' do
  describe 'success' do
    pp1 = <<-DOC
      $one = { 'a' => 1 }
      validate_hash($one)
    DOC
    it 'validates a single argument' do
      apply_manifest(pp1, :catch_failures => true)
    end

    pp2 = <<-DOC
      $one = { 'a' => 1 }
      $two = { 'b' => 2 }
      validate_hash($one,$two)
    DOC
    it 'validates an multiple arguments' do
      apply_manifest(pp2, :catch_failures => true)
    end

>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    [
      %{validate_hash('{ "not" => "hash" }')},
      %{validate_hash('string')},
      %{validate_hash(["array"])},
<<<<<<< HEAD
      %{validate_hash(undef)}
    ].each do |pp|
      it "rejects #{pp.inspect}" do
        expect(apply_manifest(pp, :expect_failures => true).stderr).to match(//)
=======
      %{validate_hash(undef)},
    ].each do |pp3|
      it "rejects #{pp3.inspect}" do
        expect(apply_manifest(pp3, :expect_failures => true).stderr).to match(%r{})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments'
  end
end
