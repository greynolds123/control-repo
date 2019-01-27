require 'puppetlabs_spec_helper/module_spec_helper'
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> b234704ac85e5944ab85d8a528657f7c75be3c6d

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
    :environment               => 'rp_env',
    :operatingsystemmajrelease => '6',
    :operatingsystemrelease    => '6.1',
    :operatingsystem           => 'RedHat',
  }
end
<<<<<<< HEAD
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
=======
>>>>>>> b234704ac85e5944ab85d8a528657f7c75be3c6d
