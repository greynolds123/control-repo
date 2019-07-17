# Namespaced prefix function from puppetlabs-stdlib
# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/parser/functions/delete_undef_values.rb

module Puppet::Parser::Functions
  newfunction(:pe_delete_undef_values, :type => :rvalue, :doc => <<-EOS
Returns a copy of input hash or array with all undefs deleted.

*Examples:*

    $hash = pe_delete_undef_values({a=>'A', b=>'', c=>undef, d => false})

Would return: {a => 'A', b => '', d => false}

    $array = pe_delete_undef_values(['A','',undef,false])

Would return: ['A','',false]

      EOS
    ) do |args|

    raise(Puppet::ParseError,
          "pe_delete_undef_values(): Wrong number of arguments given " +
          "(#{args.size})") if args.size < 1

    unless args[0].is_a? Array or args[0].is_a? Hash
      raise(Puppet::ParseError,
            "pe_delete_undef_values(): expected an array or hash, got #{args[0]} type  #{args[0].class} ")
    end
    result = args[0].dup
    if result.is_a?(Hash)
      result.delete_if {|key, val| val.equal?(:undef) || val.nil?}
    elsif result.is_a?(Array)
      result.delete :undef
      result.delete nil
    end
    result
  end
end
