module Puppet::Parser::Functions
  newfunction(:pe_create_amq_augeas_command, :type => :rvalue, :doc => <<-EOS
This function creates an augeas command for all elements in an array.
*Examples:*

    $context = 'excludedDestinations/topic'
    $selectors = ['#attribute/physicalName=foo', '#attribute/physicalName=bar']
    $attribute = 'physicalName'
    $values = ['foo.>', 'bar.>']
    pe_create_amq_augeas_command($context, $selectors, $attribute, $values)

Will return: [
'set excludedDestinations/topic[#attribute/physicalName=foo]/#attribute/physicalName foo.>',
'set excludedDestinations/topic[#attribute/physicalName=bar]/#attribute/physicalName bar.>'
]
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "pe_create_amq_augeas_command(): Wrong number of arguments " +
      "given (#{arguments.size} for 4)") if arguments.size < 4

    context = arguments[0]

    unless context.is_a?(String)
      raise Puppet::ParseError, "pe_create_amq_augeas_command(): expected first argument to be a String, got #{context.inspect}"
    end

    # Selector is optional, so except nil
    selectors = arguments[1]

    if selectors
      unless selectors.is_a?(Array)
        raise Puppet::ParseError, "pe_create_amq_augeas_command(): expected second argument to be an Array, got #{selectors.inspect}"
      end
    end

    attribute = arguments[2]

    unless attribute.is_a?(String)
      raise Puppet::ParseError, "pe_create_amq_augeas_command(): expected third argument to be a String, got #{attribute.inspect}"
    end

    values = arguments[3]

    unless values.is_a?(Array)
      raise Puppet::ParseError, "pe_create_amq_augeas_command(): expected fourth argument to be an Array, got #{values.inspect}"
    end

    if selectors && selectors.size != values.size
      raise Puppet::ParseError, "pe_create_amq_augeas_command(): expected second and fourth argument to be the same size, got #{selectors.size} and #{values.size}"
    end

    result = values.each_with_index.collect do |value, idx|
      command = "set #{context}"
      command += "[#{selectors[idx]}]" if selectors
      command += "/#attribute/#{attribute} "
      command += value
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :

