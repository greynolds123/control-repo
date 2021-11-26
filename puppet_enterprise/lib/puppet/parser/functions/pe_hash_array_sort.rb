module Puppet::Parser::Functions
  newfunction(:pe_hash_array_sort, :type => :rvalue, :doc => <<-EOS
    Sorts an Array containing Hashes using the supplied Hash key or Array of Hash keys.
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, "pe_hash_array_sort(): Wrong number of arguments (#{arguments.size}) " +
                                  "expected an Array of Hashes and key or Array of keys to sort Hashes upon")
    end

    array_to_sort = arguments[0]

    unless array_to_sort.is_a?(Array)
      raise(Puppet::ParseError, 'pe_hash_array_sort(): Requires array to work with')
    end

    array_to_sort.each { |elem|
      unless elem.is_a?(Hash)
        raise(Puppet::ParseError, 'pe_hash_array_sort(): Array must contain Hashes')
      end
    }

    keys = arguments[1]

    if keys.is_a?(Array)
      array_to_sort.sort_by { |entry| keys.map { |k| entry[k]} }
    else
      array_to_sort.sort_by { |k| k[keys] }
    end

  end
end
