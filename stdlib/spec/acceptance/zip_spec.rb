<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'
require 'puppet'

describe 'zip function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'zips two arrays of numbers together' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'zip function' do
  describe 'success' do
    pp1 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = [1,2,3,4]
      $two = [5,6,7,8]
      $output = zip($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS
      if is_future_parser_enabled?
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\[\[1, 5\], \[2, 6\], \[3, 7\], \[4, 8\]\]/)
      else
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\[\["1", "5"\], \["2", "6"\], \["3", "7"\], \["4", "8"\]\]/)
      end
    end
    it 'zips two arrays of numbers & bools together' do
      pp = <<-EOS
=======
    DOC
    it 'zips two arrays of numbers together' do
      expect(apply_manifest(pp1, :catch_failures => true).stdout).to match(%r{\[\[1, 5\], \[2, 6\], \[3, 7\], \[4, 8\]\]})
    end

    pp2 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = [1,2,"three",4]
      $two = [true,true,false,false]
      $output = zip($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS
      if is_future_parser_enabled?
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\[\[1, true\], \[2, true\], \["three", false\], \[4, false\]\]/)
      else
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\[\["1", true\], \["2", true\], \["three", false\], \["4", false\]\]/)
      end
    end
    it 'zips two arrays of numbers together and flattens them' do
      # XXX This only tests the argument `true`, even though the following are valid:
      # 1 t y true yes
      # 0 f n false no
      # undef undefined
      pp = <<-EOS
=======
    DOC
    it 'zips two arrays of numbers & bools together' do
      expect(apply_manifest(pp2, :catch_failures => true).stdout).to match(%r{\[\[1, true\], \[2, true\], \["three", false\], \[4, false\]\]})
    end

    # XXX This only tests the argument `true`, even though the following are valid:
    # 1 t y true yes
    # 0 f n false no
    # undef undefined
    pp3 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = [1,2,3,4]
      $two = [5,6,7,8]
      $output = zip($one,$two,true)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS
      if is_future_parser_enabled?
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\[1, 5, 2, 6, 3, 7, 4, 8\]/)
      else
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\["1", "5", "2", "6", "3", "7", "4", "8"\]/)
      end
    end
    it 'handles unmatched length' do
      # XXX Is this expected behavior?
      pp = <<-EOS
=======
    DOC
    it 'zips two arrays of numbers together and flattens them' do
      expect(apply_manifest(pp3, :catch_failures => true).stdout).to match(%r{\[1, 5, 2, 6, 3, 7, 4, 8\]})
    end

    # XXX Is this expected behavior?
    pp4 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = [1,2]
      $two = [5,6,7,8]
      $output = zip($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS
      if is_future_parser_enabled?
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\[\[1, 5\], \[2, 6\]\]/)
      else
        expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/\[\["1", "5"\], \["2", "6"\]\]/)
      end
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments' do
      pp = <<-EOS
      $one = [1,2]
      $output = zip($one)
      notice(inline_template('<%= @output.inspect %>'))
      EOS

      expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/Wrong number of arguments/)
    end
    it 'handles improper argument types' do
      pp = <<-EOS
=======
    DOC
    it 'handles unmatched length' do
      expect(apply_manifest(pp4, :catch_failures => true).stdout).to match(%r{\[\[1, 5\], \[2, 6\]\]})
    end
  end

  describe 'failure' do
    pp5 = <<-DOC
      $one = [1,2]
      $output = zip($one)
      notice(inline_template('<%= @output.inspect %>'))
    DOC
    it 'handles improper number of arguments' do
      expect(apply_manifest(pp5, :expect_failures => true).stderr).to match(%r{Wrong number of arguments})
    end

    pp6 = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $one = "a string"
      $two = [5,6,7,8]
      $output = zip($one,$two)
      notice(inline_template('<%= @output.inspect %>'))
<<<<<<< HEAD
      EOS

      expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/Requires array/)
=======
    DOC
    it 'handles improper argument types' do
      expect(apply_manifest(pp6, :expect_failures => true).stderr).to match(%r{Requires array})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end
end
