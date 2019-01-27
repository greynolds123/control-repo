#
# clamp.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:clamp, :type => :rvalue, :arity => -2, :doc => <<-EOS
    Clamps value to a range.
    EOS
  ) do |args|

    args.flatten!

    raise(Puppet::ParseError, 'clamp(): Wrong number of arguments, ' +
          'need three to clamp') if args.size != 3
=======
module Puppet::Parser::Functions
  newfunction(:clamp, :type => :rvalue, :arity => -2, :doc => <<-DOC
    Clamps value to a range.
    DOC
             ) do |args|

    args.flatten!

    raise(Puppet::ParseError, 'clamp(): Wrong number of arguments, need three to clamp') if args.size != 3
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    # check values out
    args.each do |value|
      case [value.class]
<<<<<<< HEAD
        when [String]
          raise(Puppet::ParseError, "clamp(): Required explicit numeric (#{value}:String)") unless value =~ /^\d+$/
        when [Hash]
          raise(Puppet::ParseError, "clamp(): The Hash type is not allowed (#{value})")
=======
      when [String]
        raise(Puppet::ParseError, "clamp(): Required explicit numeric (#{value}:String)") unless value =~ %r{^\d+$}
      when [Hash]
        raise(Puppet::ParseError, "clamp(): The Hash type is not allowed (#{value})")
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end

    # convert to numeric each element
    # then sort them and get a middle value
<<<<<<< HEAD
    args.map{ |n| n.to_i }.sort[1]
=======
    args.map { |n| n.to_i }.sort[1]
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end
