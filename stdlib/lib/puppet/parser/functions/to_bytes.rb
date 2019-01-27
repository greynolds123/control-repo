<<<<<<< HEAD
module Puppet::Parser::Functions
  newfunction(:to_bytes, :type => :rvalue, :doc => <<-EOS
=======
#
# to_bytes.rb
#
module Puppet::Parser::Functions
  newfunction(:to_bytes, :type => :rvalue, :doc => <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    Converts the argument into bytes, for example 4 kB becomes 4096.
    Takes a single string value as an argument.
    These conversions reflect a layperson's understanding of
    1 MB = 1024 KB, when in fact 1 MB = 1000 KB, and 1 MiB = 1024 KiB.
<<<<<<< HEAD
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "to_bytes(): Wrong number of arguments " +
          "given (#{arguments.size} for 1)") if arguments.size != 1
=======
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "to_bytes(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    arg = arguments[0]

    return arg if arg.is_a? Numeric

<<<<<<< HEAD
    value,prefix = */([0-9.e+-]*)\s*([^bB]?)/.match(arg)[1,2]
=======
    value, prefix = *%r{([0-9.e+-]*)\s*([^bB]?)}.match(arg)[1, 2]
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    value = value.to_f
    case prefix
    when '' then return value.to_i
<<<<<<< HEAD
    when 'k' then return (value*(1<<10)).to_i
    when 'M' then return (value*(1<<20)).to_i
    when 'G' then return (value*(1<<30)).to_i
    when 'T' then return (value*(1<<40)).to_i
    when 'P' then return (value*(1<<50)).to_i
    when 'E' then return (value*(1<<60)).to_i
=======
    when 'k' then return (value * (1 << 10)).to_i
    when 'M' then return (value * (1 << 20)).to_i
    when 'G' then return (value * (1 << 30)).to_i
    when 'T' then return (value * (1 << 40)).to_i
    when 'P' then return (value * (1 << 50)).to_i
    when 'E' then return (value * (1 << 60)).to_i
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    else raise Puppet::ParseError, "to_bytes(): Unknown prefix #{prefix}"
    end
  end
end
