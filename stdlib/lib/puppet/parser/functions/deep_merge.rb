<<<<<<< HEAD
module Puppet::Parser::Functions
  newfunction(:deep_merge, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
=======
#
# deep_merge.rb
#
module Puppet::Parser::Functions
  newfunction(:deep_merge, :type => :rvalue, :doc => <<-'DOC') do |args|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    Recursively merges two or more hashes together and returns the resulting hash.

    For example:

        $hash1 = {'one' => 1, 'two' => 2, 'three' => { 'four' => 4 } }
        $hash2 = {'two' => 'dos', 'three' => { 'five' => 5 } }
        $merged_hash = deep_merge($hash1, $hash2)
        # The resulting hash is equivalent to:
        # $merged_hash = { 'one' => 1, 'two' => 'dos', 'three' => { 'four' => 4, 'five' => 5 } }

    When there is a duplicate key that is a hash, they are recursively merged.
    When there is a duplicate key that is not a hash, the key in the rightmost hash will "win."

<<<<<<< HEAD
    ENDHEREDOC

    if args.length < 2
      raise Puppet::ParseError, ("deep_merge(): wrong number of arguments (#{args.length}; must be at least 2)")
    end

    deep_merge = Proc.new do |hash1,hash2|
      hash1.merge(hash2) do |key,old_value,new_value|
=======
    DOC

    if args.length < 2
      raise Puppet::ParseError, "deep_merge(): wrong number of arguments (#{args.length}; must be at least 2)"
    end

    deep_merge = proc do |hash1, hash2|
      hash1.merge(hash2) do |_key, old_value, new_value|
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
        if old_value.is_a?(Hash) && new_value.is_a?(Hash)
          deep_merge.call(old_value, new_value)
        else
          new_value
        end
      end
    end

<<<<<<< HEAD
    result = Hash.new
    args.each do |arg|
      next if arg.is_a? String and arg.empty? # empty string is synonym for puppet's undef
=======
    result = {}
    args.each do |arg|
      next if arg.is_a?(String) && arg.empty? # empty string is synonym for puppet's undef
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      # If the argument was not a hash, skip it.
      unless arg.is_a?(Hash)
        raise Puppet::ParseError, "deep_merge: unexpected argument type #{arg.class}, only expects hash arguments"
      end

      result = deep_merge.call(result, arg)
    end
<<<<<<< HEAD
    return( result )
=======
    return(result)
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end
end
