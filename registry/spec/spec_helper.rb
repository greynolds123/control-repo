
<<<<<<< HEAD
dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require 'mocha'
require 'puppet'
require 'rspec'
require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.mock_with :mocha

  if File::ALT_SEPARATOR && RUBY_VERSION =~ /^1\./
    require 'win32console'
    c.output_stream = $stdout
    c.error_stream = $stderr
    c.formatters.each { |f| f.instance_variable_set(:@output, $stdout) }
  end

  c.expect_with :rspec do |e|
    e.syntax = [:should, :expect]
  end
end

# We need this because the RAL uses 'should' as a method.  This
# allows us the same behaviour but with a different method name.
class Object
  alias :must :should
end
=======
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

begin
  require 'spec_helper_local' if File.file?(File.join(File.dirname(__FILE__), 'spec_helper_local.rb'))
rescue LoadError => loaderror
  warn "Could not require spec_helper_local: #{loaderror.message}"
end

include RspecPuppetFacts

default_facts = {
  puppetversion: Puppet.version,
  facterversion: Facter.version,
}

default_facts_path = File.expand_path(File.join(File.dirname(__FILE__), 'default_facts.yml'))
default_module_facts_path = File.expand_path(File.join(File.dirname(__FILE__), 'default_module_facts.yml'))

if File.exist?(default_facts_path) && File.readable?(default_facts_path)
  default_facts.merge!(YAML.safe_load(File.read(default_facts_path)))
end

if File.exist?(default_module_facts_path) && File.readable?(default_module_facts_path)
  default_facts.merge!(YAML.safe_load(File.read(default_module_facts_path)))
end

RSpec.configure do |c|
  c.default_facts = default_facts
  c.before :each do
    # set to strictest setting for testing
    # by default Puppet runs at warning level
    Puppet.settings[:strict] = :warning
  end
end

def ensure_module_defined(module_name)
  module_name.split('::').reduce(Object) do |last_module, next_module|
    last_module.const_set(next_module, Module.new) unless last_module.const_defined?(next_module)
    last_module.const_get(next_module)
  end
end

# 'spec_overrides' from sync.yml will appear below this line
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
