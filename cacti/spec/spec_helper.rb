require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts
require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.mock_framework = :rspec

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.hiera_config = File.expand_path(File.join(__FILE__, '../fixtures/hiera.yaml'))
end
