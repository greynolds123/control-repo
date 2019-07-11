require 'puppetlabs_spec_helper/module_spec_helper'
<<<<<<< HEAD
=======

RSpec.configure do |config|
  config.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
  config.before :each do
    # Ensure that we don't accidentally cache facts and environment between
    # test cases.  This requires each example group to explicitly load the
    # facts being exercised with something like
    # Facter.collection.loader.load(:ipaddress)
    Facter.clear
    Facter.clear_messages
  end
  config.default_facts = {
    :environment => 'rp_env',
  }
end
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
