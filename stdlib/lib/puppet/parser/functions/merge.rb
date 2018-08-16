<<<<<<< HEAD
module Puppet::Parser::Functions
  newfunction(:merge, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
=======
#
# merge.rb
#
module Puppet::Parser::Functions
  newfunction(:merge, :type => :rvalue, :doc => <<-'DOC') do |args|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    Merges two or more hashes together and returns the resulting hash.

    For example:

        $hash1 = {'one' => 1, 'two', => 2}
        $hash2 = {'two' => 'dos', 'three', => 'tres'}
        $merged_hash = merge($hash1, $hash2)
        # The resulting hash is equivalent to:
        # $merged_hash =  {'one' => 1, 'two' => 'dos', 'three' => 'tres'}

    When there is a duplicate key, the key in the rightmost hash will "win."

<<<<<<< HEAD
    ENDHEREDOC

    if args.length < 2
      raise Puppet::ParseError, ("merge(): wrong number of arguments (#{args.length}; must be at least 2)")
    end

    # The hash we accumulate into
    accumulator = Hash.new
    # Merge into the accumulator hash
    args.each do |arg|
      next if arg.is_a? String and arg.empty? # empty string is synonym for puppet's undef
=======
    DOC

    if args.length < 2
      raise Puppet::ParseError, "merge(): wrong number of arguments (#{args.length}; must be at least 2)"
    end

    # The hash we accumulate into
    accumulator = {}
    # Merge into the accumulator hash
    args.each do |arg|
      next if arg.is_a?(String) && arg.empty? # empty string is synonym for puppet's undef
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      unless arg.is_a?(Hash)
        raise Puppet::ParseError, "merge: unexpected argument type #{arg.class}, only expects hash arguments"
      end
      accumulator.merge!(arg)
    end
    # Return the fully merged hash
    accumulator
  end
end
