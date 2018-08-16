<<<<<<< HEAD

# hack to enable all the expect syntax (like allow_any_instance_of) in rspec-puppet examples
=======
# automatically load any shared examples or contexts
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

# HACK: to enable all the expect syntax (like allow_any_instance_of) in rspec-puppet examples
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
RSpec::Mocks::Syntax.enable_expect(RSpec::Puppet::ManifestMatchers)

RSpec.configure do |config|
  # supply tests with a possibility to test for the future parser
  config.add_setting :puppet_future
  config.puppet_future = Puppet.version.to_f >= 4.0

  config.before :each do
    # Ensure that we don't accidentally cache facts and environment between
    # test cases.  This requires each example group to explicitly load the
    # facts being exercised with something like
    # Facter.collection.loader.load(:ipaddress)
    Facter.clear
    Facter.clear_messages
<<<<<<< HEAD
    
=======

>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    RSpec::Mocks.setup
  end

  config.after :each do
    RSpec::Mocks.verify
    RSpec::Mocks.teardown
  end
end

# Helper class to test handling of arguments which are derived from string
class AlsoString < String
end
