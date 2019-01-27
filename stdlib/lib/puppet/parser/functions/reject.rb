#
# reject.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:reject, :type => :rvalue, :doc => <<-EOS) do |args|
This function searches through an array and rejects all elements that match
the provided regular expression.

*Examples:*

    reject(['aaa','bbb','ccc','aaaddd'], 'aaa')

Would return:

    ['bbb','ccc']
EOS

    if (args.size != 2)
      raise Puppet::ParseError,
        "reject(): Wrong number of arguments given #{args.size} for 2"
=======
module Puppet::Parser::Functions
  newfunction(:reject, :type => :rvalue, :doc => <<-DOC) do |args|
    This function searches through an array and rejects all elements that match
    the provided regular expression.

    *Examples:*

        reject(['aaa','bbb','ccc','aaaddd'], 'aaa')

    Would return:

        ['bbb','ccc']
DOC

    if args.size != 2
      raise Puppet::ParseError,
            "reject(): Wrong number of arguments given #{args.size} for 2"
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    ary = args[0]
    pattern = Regexp.new(args[1])

    ary.reject { |e| e =~ pattern }
  end
end

# vim: set ts=2 sw=2 et :
