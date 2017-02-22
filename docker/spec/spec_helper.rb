require 'puppetlabs_spec_helper/module_spec_helper'
<<<<<<< HEAD

RSpec::Matchers.define :require_string_for do |property|
  match do |type_class|
    config = {:name => 'name'}
    config[property] = 2
    expect do
      type_class.new(config)
    end.to raise_error(Puppet::Error, /#{property} should be a String/)
  end
  failure_message do |type_class|
    "#{type_class} should require #{property} to be a String"
  end
end

RSpec::Matchers.define :require_hash_for do |property|
  match do |type_class|
    config = {:name => 'name'}
    config[property] = 2
    expect do
      type_class.new(config)
    end.to raise_error(Puppet::Error, /#{property} should be a Hash/)
  end
  failure_message do |type_class|
    "#{type_class} should require #{property} to be a Hash"
  end
end
=======
>>>>>>> 61a94e602d9e9814c0d27f76e0942de0d08f50a1
