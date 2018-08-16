#
# has_ip_address
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:has_ip_address, :type => :rvalue, :doc => <<-EOS
Returns true if the client has the requested IP address on some interface.

This function iterates through the 'interfaces' fact and checks the
'ipaddress_IFACE' facts, performing a simple string comparison.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "has_ip_address(): Wrong number of arguments " +
          "given (#{args.size} for 1)") if args.size != 1
=======
module Puppet::Parser::Functions
  newfunction(:has_ip_address, :type => :rvalue, :doc => <<-DOC
    Returns true if the client has the requested IP address on some interface.

    This function iterates through the 'interfaces' fact and checks the
    'ipaddress_IFACE' facts, performing a simple string comparison.
    DOC
             ) do |args|

    raise(Puppet::ParseError, "has_ip_address(): Wrong number of arguments given (#{args.size} for 1)") if args.size != 1
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    Puppet::Parser::Functions.autoloader.load(:has_interface_with) \
      unless Puppet::Parser::Functions.autoloader.loaded?(:has_interface_with)

    function_has_interface_with(['ipaddress', args[0]])
<<<<<<< HEAD

=======
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end

# vim:sts=2 sw=2
