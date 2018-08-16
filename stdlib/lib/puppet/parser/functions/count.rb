<<<<<<< HEAD
module Puppet::Parser::Functions
  newfunction(:count, :type => :rvalue, :arity => -2, :doc => <<-EOS
Takes an array as first argument and an optional second argument.
Count the number of elements in array that matches second argument.
If called with only an array it counts the number of elements that are not nil/undef.
    EOS
  ) do |args|

    if (args.size > 2) then
      raise(ArgumentError, "count(): Wrong number of arguments "+
        "given #{args.size} for 1 or 2.")
=======
#
# count.rb
#
module Puppet::Parser::Functions
  newfunction(:count, :type => :rvalue, :arity => -2, :doc => <<-DOC
    Takes an array as first argument and an optional second argument.
    Count the number of elements in array that matches second argument.
    If called with only an array it counts the number of elements that are not nil/undef.
  DOC
             ) do |args|

    if args.size > 2
      raise(ArgumentError, "count(): Wrong number of arguments given #{args.size} for 1 or 2.")
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    collection, item = args

<<<<<<< HEAD
    if item then
      collection.count item
    else
      collection.count { |obj| obj != nil && obj != :undef && obj != '' }
=======
    if item
      collection.count item
    else
      collection.count { |obj| !obj.nil? && obj != :undef && obj != '' }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end
end
