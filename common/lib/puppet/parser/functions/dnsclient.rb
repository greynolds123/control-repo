module Puppet::Parser::Functions
# This function is a global helper function for dns_client

  Puppet::Functions.create_function(:'common::dnsclient') do
    dispatch :dnsclient do
    #..
    end

    def dnsclient()
      scope     = closure_scope
      dns_cient = scope['facts']['network']['dnsclient']
      #..
    end
  end
