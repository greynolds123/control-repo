#! /usr/bin/env ruby
require 'spec_helper'

describe "Windows facts", :if => !!Facter::Util::Config.is_windows? do
  it "should report on the COMMON_APPDATA directory" do
    File.should be_directory(Facter.fact(:common_appdata).value)
  end
end
