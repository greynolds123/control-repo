#
# validate_ldap_sub_dn.rb
#

module Puppet::Parser::Functions
  newfunction(:validate_ldap_sub_dn, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise Puppet::ParseError, 'validate_ldap_sub_dn(): Wrong number of ' +
      "arguments given (#{arguments.size} for 2)" if arguments.size != 2

    base = arguments[0]
    item = arguments[1]

    function_validate_ldap_dn([base])

    unless item.is_a?(Array)
      item = [item]
    end

    if item.size == 0
      raise Puppet::ParseError, 'validate_ldap_sub_dn(): Requires an array ' +
        'with at least 1 element'
    end

    item.each do |i|
      unless i.is_a?(String)
        raise Puppet::ParseError, 'validate_ldap_sub_dn(): Requires either ' +
          'an array or string to work with'
      end

      begin
        function_validate_ldap_dn([i])
        # Crude, but it should work
        raise unless i =~ /(?:^|,)#{Regexp.escape(base)}$/
      rescue
        raise Puppet::ParseError, 'validate_ldap_sub_dn(): ' +
          "#{i.inspect} is not a valid LDAP subtree distinguished name"
      end
    end
  end
end
