#
# is_mac_address.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:is_mac_address, :type => :rvalue, :doc => <<-EOS
Returns true if the string passed to this function is a valid mac address.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_mac_address(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
=======
module Puppet::Parser::Functions
  newfunction(:is_mac_address, :type => :rvalue, :doc => <<-DOC
    Returns true if the string passed to this function is a valid mac address.
    DOC
             ) do |arguments|

    if arguments.size != 1
      raise(Puppet::ParseError, "is_mac_address(): Wrong number of arguments given #{arguments.size} for 1")
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    mac = arguments[0]

<<<<<<< HEAD
    if /^[a-f0-9]{1,2}(:[a-f0-9]{1,2}){5}$/i.match(mac) then
      return true
    else
      return false
    end

=======
    return true if %r{^[a-f0-9]{1,2}(:[a-f0-9]{1,2}){5}$}i =~ mac
    return false
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end

# vim: set ts=2 sw=2 et :
