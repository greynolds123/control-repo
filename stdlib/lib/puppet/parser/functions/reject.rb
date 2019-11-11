#
# reject.rb
#
module Puppet::Parser::Functions
  newfunction(:reject, :type => :rvalue, :doc => <<-DOC) do |args|
    This function searches through an array and rejects all elements that match
    the provided regular expression.

    *Examples:*

        reject(['aaa','bbb','ccc','aaaddd'], 'aaa')

    Would return:

        ['bbb','ccc']
<<<<<<< HEAD
=======

    Note that since Puppet 4.0.0 the same is in general done with the filter function. Here is the
    equivalence of the reject() function:

        ['aaa','bbb','ccc','aaaddd'].filter |$x| { $x !~ /aaa/ }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
DOC

    if args.size != 2
      raise Puppet::ParseError,
            "reject(): Wrong number of arguments given #{args.size} for 2"
    end

    ary = args[0]
    pattern = Regexp.new(args[1])

    ary.reject { |e| e =~ pattern }
  end
end

# vim: set ts=2 sw=2 et :
