#
# type3x.rb
#
<<<<<<< HEAD

module Puppet::Parser::Functions
  newfunction(:type3x, :type => :rvalue, :doc => <<-EOS
DEPRECATED: This function will be removed when puppet 3 support is dropped; please migrate to the new parser's typing system.

Returns the type when passed a value. Type can be one of:

* string
* array
* hash
* float
* integer
* boolean
    EOS
  ) do |args|
    raise(Puppet::ParseError, "type3x(): Wrong number of arguments " +
      "given (#{args.size} for 1)") if args.size < 1
=======
module Puppet::Parser::Functions
  newfunction(:type3x, :type => :rvalue, :doc => <<-DOC
    DEPRECATED: This function will be removed when puppet 3 support is dropped; please migrate to the new parser's typing system.

    Returns the type when passed a value. Type can be one of:

    * string
    * array
    * hash
    * float
    * integer
    * boolean
  DOC
             ) do |args|
    raise(Puppet::ParseError, "type3x(): Wrong number of arguments given (#{args.size} for 1)") unless args.size == 1
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    value = args[0]

    klass = value.class

<<<<<<< HEAD
    if not [TrueClass, FalseClass, Array, Bignum, Fixnum, Float, Hash, String].include?(klass)
=======
    unless [TrueClass, FalseClass, Array, Bignum, Fixnum, Float, Hash, String].include?(klass) # rubocop:disable Lint/UnifiedInteger
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      raise(Puppet::ParseError, 'type3x(): Unknown type')
    end

    klass = klass.to_s # Ugly ...

    # We note that Integer is the parent to Bignum and Fixnum ...
    result = case klass
<<<<<<< HEAD
      when /^(?:Big|Fix)num$/ then 'integer'
      when /^(?:True|False)Class$/ then 'boolean'
      else klass
    end

    if result == "String" then
      if value == value.to_i.to_s then
        result = "Integer"
      elsif value == value.to_f.to_s then
        result = "Float"
=======
             when %r{^(?:Big|Fix)num$} then 'integer'
             when %r{^(?:True|False)Class$} then 'boolean'
             else klass
             end

    if result == 'String'
      if value == value.to_i.to_s
        result = 'Integer'
      elsif value == value.to_f.to_s
        result = 'Float'
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end

    return result.downcase
  end
end

# vim: set ts=2 sw=2 et :
