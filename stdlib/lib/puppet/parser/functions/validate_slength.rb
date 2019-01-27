<<<<<<< HEAD
module Puppet::Parser::Functions

  newfunction(:validate_slength, :doc => <<-'ENDHEREDOC') do |args|
=======
#
# validate_slength.rb
#
module Puppet::Parser::Functions
  newfunction(:validate_slength, :doc => <<-'DOC') do |args|
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    Validate that the first argument is a string (or an array of strings), and
    less/equal to than the length of the second argument. An optional third
    parameter can be given the minimum length. It fails if the first
    argument is not a string or array of strings, and if arg 2 and arg 3 are
    not convertable to a number.

    The following values will pass:

      validate_slength("discombobulate",17)
      validate_slength(["discombobulate","moo"],17)
      validate_slength(["discombobulate","moo"],17,3)

    The following valueis will not:

      validate_slength("discombobulate",1)
      validate_slength(["discombobulate","thermometer"],5)
      validate_slength(["discombobulate","moo"],17,10)

<<<<<<< HEAD
    ENDHEREDOC

    function_deprecation([:validate_slength, 'This method is deprecated, please use the stdlib validate_legacy function, with String[]. There is further documentation for validate_legacy function in the README.'])

    raise Puppet::ParseError, "validate_slength(): Wrong number of arguments (#{args.length}; must be 2 or 3)" unless args.length == 2 or args.length == 3
=======
    DOC

    function_deprecation([:validate_slength, 'This method is deprecated, please use the stdlib validate_legacy function,
                            with String[]. There is further documentation for validate_legacy function in the README.'])

    raise Puppet::ParseError, "validate_slength(): Wrong number of arguments (#{args.length}; must be 2 or 3)" unless args.length == 2 || args.length == 3
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870

    input, max_length, min_length = *args

    begin
      max_length = Integer(max_length)
      raise ArgumentError if max_length <= 0
    rescue ArgumentError, TypeError
      raise Puppet::ParseError, "validate_slength(): Expected second argument to be a positive Numeric, got #{max_length}:#{max_length.class}"
    end

    if min_length
      begin
        min_length = Integer(min_length)
        raise ArgumentError if min_length < 0
<<<<<<< HEAD
    rescue ArgumentError, TypeError
=======
      rescue ArgumentError, TypeError
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        raise Puppet::ParseError, "validate_slength(): Expected third argument to be unset or a positive Numeric, got #{min_length}:#{min_length.class}"
      end
    else
      min_length = 0
    end

<<<<<<< HEAD
    raise Puppet::ParseError, "validate_slength(): Expected second argument to be equal to or larger than third argument" unless max_length >= min_length

    validator = lambda do |str|
      unless str.length <= max_length and str.length >= min_length
=======
    raise Puppet::ParseError, 'validate_slength(): Expected second argument to be equal to or larger than third argument' unless max_length >= min_length

    validator = ->(str) do
      unless str.length <= max_length && str.length >= min_length
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        raise Puppet::ParseError, "validate_slength(): Expected length of #{input.inspect} to be between #{min_length} and #{max_length}, was #{input.length}"
      end
    end

    case input
    when String
      validator.call(input)
    when Array
      input.each_with_index do |arg, pos|
<<<<<<< HEAD
        if arg.is_a? String
          validator.call(arg)
        else
          raise Puppet::ParseError, "validate_slength(): Expected element at array position #{pos} to be a String, got #{arg.class}"
        end
=======
        raise Puppet::ParseError, "validate_slength(): Expected element at array position #{pos} to be a String, got #{arg.class}" unless arg.is_a? String
        validator.call(arg)
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    else
      raise Puppet::ParseError, "validate_slength(): Expected first argument to be a String or Array, got #{input.class}"
    end
  end
end
