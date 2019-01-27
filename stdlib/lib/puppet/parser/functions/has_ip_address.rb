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
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    Puppet::Parser::Functions.autoloader.load(:has_interface_with) \
      unless Puppet::Parser::Functions.autoloader.loaded?(:has_interface_with)

    function_has_interface_with(['ipaddress', args[0]])
<<<<<<< HEAD

=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end
end

# vim:sts=2 sw=2
