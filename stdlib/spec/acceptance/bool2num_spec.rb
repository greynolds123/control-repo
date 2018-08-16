<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'bool2num function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    ['false', 'f', '0', 'n', 'no'].each do |bool|
      it "should convert a given boolean, #{bool}, to 0" do
        pp = <<-EOS
        $input = "#{bool}"
        $output = bool2num($input)
        notify { "$output": }
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/Notice: 0/)
=======
require 'spec_helper_acceptance'

describe 'bool2num function' do
  describe 'success' do
    %w[false f 0 n no].each do |bool|
      pp1 = <<-DOC
        $input = "#{bool}"
        $output = bool2num($input)
        notify { "$output": }
      DOC
      it "should convert a given boolean, #{bool}, to 0" do
        apply_manifest(pp1, :catch_failures => true) do |r|
          expect(r.stdout).to match(%r{Notice: 0})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        end
      end
    end

<<<<<<< HEAD
    ['true', 't', '1', 'y', 'yes'].each do |bool|
      it "should convert a given boolean, #{bool}, to 1" do
        pp = <<-EOS
        $input = "#{bool}"
        $output = bool2num($input)
        notify { "$output": }
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/Notice: 1/)
=======
    %w[true t 1 y yes].each do |bool|
      pp2 = <<-DOC
        $input = "#{bool}"
        $output = bool2num($input)
        notify { "$output": }
      DOC
      it "should convert a given boolean, #{bool}, to 1" do
        apply_manifest(pp2, :catch_failures => true) do |r|
          expect(r.stdout).to match(%r{Notice: 1})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        end
      end
    end
  end
end
