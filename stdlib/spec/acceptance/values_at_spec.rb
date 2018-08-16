<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'values_at function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'returns a specific value' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'values_at function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = ['a','b','c','d','e']
      $two = 1
      $output = values_at($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS

      expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\["b"\]/)
    end
    it 'returns a specific negative index value' do
      pending("negative numbers don't work")
      pp = <<-EOS
=======
    DOC
    it 'returns a specific value' do
      expect(apply_manifest(pp1, :catch_failures => true).stdout).to match(%r{\["b"\]})
    end

    pp2 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = ['a','b','c','d','e']
      $two = -1
      $output = values_at($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS

      expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\["e"\]/)
    end
    it 'returns a range of values' do
      pp = <<-EOS
=======
    DOC
    it 'returns a specific negative index value' do
      pending("negative numbers don't work")
      expect(apply_manifest(pp2, :catch_failures => true).stdout).to match(%r{\["e"\]})
    end

    pp3 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = ['a','b','c','d','e']
      $two = "1-3"
      $output = values_at($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS

      expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\["b", "c", "d"\]/)
    end
    it 'returns a negative specific value and range of values' do
      pp = <<-EOS
=======
    DOC
    it 'returns a range of values' do
      expect(apply_manifest(pp3, :catch_failures => true).stdout).to match(%r{\["b", "c", "d"\]})
    end

    pp4 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = ['a','b','c','d','e']
      $two = ["1-3",0]
      $output = values_at($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS

      expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\["b", "c", "d", "a"\]/)
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments' do
      pp = <<-EOS
      $one = ['a','b','c','d','e']
      $output = values_at($one)
      notice(inline_template('<%= @output.inspect %>'))
      EOS

      expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/Wrong number of arguments/)
    end
    it 'handles non-indicies arguments' do
      pp = <<-EOS
=======
    DOC
    it 'returns a negative specific value and range of values' do
      expect(apply_manifest(pp4, :catch_failures => true).stdout).to match(%r{\["b", "c", "d", "a"\]})
    end
  end

  describe 'failure' do
    pp5 = <<-DOC
      $one = ['a','b','c','d','e']
      $output = values_at($one)
      notice(inline_template('<%= @output.inspect %>'))
    DOC
    it 'handles improper number of arguments' do
      expect(apply_manifest(pp5, :expect_failures => true).stderr).to match(%r{Wrong number of arguments})
    end

    pp6 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = ['a','b','c','d','e']
      $two = []
      $output = values_at($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS

      expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/at least one positive index/)
=======
    DOC
    it 'handles non-indicies arguments' do
      expect(apply_manifest(pp6, :expect_failures => true).stderr).to match(%r{at least one positive index})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    it 'detects index ranges smaller than the start range'
    it 'handles index ranges larger than array'
    it 'handles non-integer indicies'
  end
end
