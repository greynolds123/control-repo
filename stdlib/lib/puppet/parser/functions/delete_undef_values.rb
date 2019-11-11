#
# delete_undef_values.rb
#
module Puppet::Parser::Functions
  newfunction(:delete_undef_values, :type => :rvalue, :doc => <<-DOC
    Returns a copy of input hash or array with all undefs deleted.

    *Examples:*

        $hash = delete_undef_values({a=>'A', b=>'', c=>undef, d => false})

    Would return: {a => 'A', b => '', d => false}

        $array = delete_undef_values(['A','',undef,false])

    Would return: ['A','',false]

<<<<<<< HEAD
=======
    Note that since Puppet 4.0.0 the equivalent can be performed with the filter() function in Puppet:

        $array.filter |$val| { $val =~ NotUndef }
        $hash.filter |$key, $val| { $val =~ NotUndef }

>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      DOC
             ) do |args|

    raise(Puppet::ParseError, "delete_undef_values(): Wrong number of arguments given (#{args.size})") if args.empty?

    unless args[0].is_a?(Array) || args[0].is_a?(Hash)
      raise(Puppet::ParseError, "delete_undef_values(): expected an array or hash, got #{args[0]} type  #{args[0].class} ")
    end
    result = args[0].dup
    if result.is_a?(Hash)
<<<<<<< HEAD
      result.delete_if { |_key, val| val.equal? :undef }
    elsif result.is_a?(Array)
      result.delete :undef
=======
      result.delete_if { |_, val| val.equal?(:undef) || val.nil? }
    elsif result.is_a?(Array)
      result.delete :undef
      result.delete nil
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
    result
  end
end
