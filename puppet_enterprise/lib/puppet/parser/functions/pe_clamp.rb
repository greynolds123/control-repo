#
# clamp.rb
#

module Puppet::Parser::Functions
  newfunction(:pe_clamp, :type => :rvalue, :arity => -2, :doc => <<-EOS
    Clamps value to a range.
    EOS
  ) do |args|

    args.flatten!

    raise(Puppet::ParseError, 'pe_clamp(): Wrong number of arguments, need three to clamp') if args.size != 3

    # check values out
    args.each do |value|
      case [value.class]
        when [String]
          raise(Puppet::ParseError, "pe_clamp(): Required explicit numeric (#{value}:String)") unless value =~ /^\d+$/
        when [Hash]
          raise(Puppet::ParseError, "pe_clamp(): The Hash type is not allowed (#{value})")
      end
    end

    # convert to numeric each element
    # then sort them and get a middle value
    args.map{ |n| n.to_i }.sort[1]
  end
end
