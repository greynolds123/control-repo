<<<<<<< HEAD
=======
# This file is managed via modulesync
# https://github.com/voxpupuli/modulesync
# https://github.com/voxpupuli/modulesync_config
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

<<<<<<< HEAD
if Dir.exist?(File.expand_path('../../lib', __FILE__)) && RUBY_VERSION !~ %r{^1.9}
=======
if Dir.exist?(File.expand_path('../../lib', __FILE__))
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  require 'coveralls'
  require 'simplecov'
  require 'simplecov-console'
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
<<<<<<< HEAD
    SimpleCov::Formatter::Console,
    Coveralls::SimpleCov::Formatter
=======
    SimpleCov::Formatter::Console
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  ]
  SimpleCov.start do
    track_files 'lib/**/*.rb'
    add_filter '/spec'
    add_filter '/vendor'
    add_filter '/.vendor'
  end
end

RSpec.configure do |c|
<<<<<<< HEAD
  default_facts = {
    puppetversion: Puppet.version,
    facterversion: Facter.version
  }
  default_facts.merge!(YAML.load(File.read(File.expand_path('../default_facts.yml', __FILE__)))) if File.exist?(File.expand_path('../default_facts.yml', __FILE__))
  default_facts.merge!(YAML.load(File.read(File.expand_path('../default_module_facts.yml', __FILE__)))) if File.exist?(File.expand_path('../default_module_facts.yml', __FILE__))
  c.default_facts = default_facts
end

# vim: syntax=ruby
=======
  default_facts = {}
  default_facts.merge!(YAML.load(File.read(File.expand_path('../default_facts.yml', __FILE__)))) if File.exist?(File.expand_path('../default_facts.yml', __FILE__))
  default_facts.merge!(YAML.load(File.read(File.expand_path('../default_module_facts.yml', __FILE__)))) if File.exist?(File.expand_path('../default_module_facts.yml', __FILE__))
  c.default_facts = default_facts

  # Coverage generation
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
