#
# enclose_ipv6.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:enclose_ipv6, :type => :rvalue, :doc => <<-EOS
Takes an array of ip addresses and encloses the ipv6 addresses with square brackets.
    EOS
  ) do |arguments|

    require 'ipaddr'

    rescuable_exceptions = [ ArgumentError ]
    if defined?(IPAddr::InvalidAddressError)
	    rescuable_exceptions << IPAddr::InvalidAddressError
    end

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "enclose_ipv6(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end
    unless arguments[0].is_a?(String) or arguments[0].is_a?(Array) then
      raise(Puppet::ParseError, "enclose_ipv6(): Wrong argument type "+
        "given #{arguments[0].class} expected String or Array")
=======
module Puppet::Parser::Functions
  newfunction(:enclose_ipv6, :type => :rvalue, :doc => <<-DOC
    Takes an array of ip addresses and encloses the ipv6 addresses with square brackets.
  DOC
             ) do |arguments|

    require 'ipaddr'

    rescuable_exceptions = [ArgumentError]
    if defined?(IPAddr::InvalidAddressError)
      rescuable_exceptions << IPAddr::InvalidAddressError
    end

    if arguments.size != 1
      raise(Puppet::ParseError, "enclose_ipv6(): Wrong number of arguments given #{arguments.size} for 1")
    end
    unless arguments[0].is_a?(String) || arguments[0].is_a?(Array)
      raise(Puppet::ParseError, "enclose_ipv6(): Wrong argument type given #{arguments[0].class} expected String or Array")
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end

    input = [arguments[0]].flatten.compact
    result = []

    input.each do |val|
      unless val == '*'
        begin
          ip = IPAddr.new(val)
        rescue *rescuable_exceptions
<<<<<<< HEAD
          raise(Puppet::ParseError, "enclose_ipv6(): Wrong argument "+
                "given #{val} is not an ip address.")
        end
        val = "[#{ip.to_s}]" if ip.ipv6?
=======
          raise(Puppet::ParseError, "enclose_ipv6(): Wrong argument given #{val} is not an ip address.")
        end
        val = "[#{ip}]" if ip.ipv6?
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
      result << val
    end

    return result.uniq
  end
end
