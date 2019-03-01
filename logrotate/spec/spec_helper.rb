<<<<<<< HEAD
require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'puppetlabs_spec_helper/module_spec_helper'
=======
require 'rspec-puppet'

RSpec.configure do |c|
  c.module_path = File.expand_path(File.join(__FILE__, '..', 'fixtures', 'modules'))
  c.manifest_dir = File.expand_path(File.join(__FILE__, '..', 'fixtures', 'manifests'))
end
>>>>>>> 9efba6f74fd2ad28af39d76b1cfd9531dfdba0fd
