module Puppet::Parser::Functions
  newfunction(:pe_pick_array, :type => :rvalue, :doc => <<-EOS
This defines a function exactly like pe_pick which operates on arrays, and picks the array from the list of available arrays that is not empty.
EOS
) do |args|
    args = args.compact
    args.delete(:undef)
    args.delete(:undefined)
    args.delete([])
    # This checks to see if there are no more args left once []s are removed
    if args[0].to_s.empty? then
      fail Puppet::ParserError, "pe_pick_array(): must receive at least one non empty array"
    else
      return args[0]
    end
  end
end